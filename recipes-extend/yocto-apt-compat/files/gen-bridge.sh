#!/bin/sh
# gen-bridge.sh  —  build ONE name-bridge .deb for a Yocto (deb-populated) rootfs.
#
# Purpose: tell apt that Debian/Ubuntu package NAMES (including the t64-transition
# renames) are already satisfied by the Yocto base, so apt resolves external .debs
# against the existing system instead of pulling conflicting distro copies.
#
# Key properties:
#   * ships NO files            -> zero file collisions
#   * versioned Provides        -> satisfies versioned deps (e.g. ">= 3.12.1")
#   * SONAME-verified           -> never claims a name whose backing package ships
#                                  a DIFFERENT .so major (the libtinfo6 trap)
#   * built with ar, not dpkg-deb --build, and never `tar -T /dev/null`
#                                  -> works on a BusyBox userland
#
# Usage:
#   OUTDIR=/var/lib/yocto-compat ./gen-bridge.sh            # read live dpkg, build .deb
#   ./gen-bridge.sh /path/to/inventory.txt                 # dry-run from a file
#       (inventory = `dpkg-query -W -f='${Package} ${Version} ${Architecture}\n'`)
#
# Output: $OUTDIR/yocto-debian-compat_1.0_all.deb
set -eu

OUT="${OUTDIR:-/var/lib/yocto-compat}"
PKGDIR="$OUT/yocto-debian-compat"
DEB="$OUT/yocto-debian-compat_1.0_all.deb"
IDX="$OUT/idx"
mkdir -p "$OUT"
rm -rf "$PKGDIR"; mkdir -p "$PKGDIR/DEBIAN"

# ---- inventory source -------------------------------------------------------
if [ "${1:-}" = "" ]; then
  dpkg-query -W -f='${Package} ${Version} ${Architecture}\n' > "$OUT/inv.raw"
  SRC="$OUT/inv.raw"
else
  SRC="$1"
fi
# keep only Yocto-built packages (version ends in -rN); store name<TAB>version
awk '$2 ~ /-r[0-9]+$/ {print $1"\t"$2}' "$SRC" > "$IDX"

# ---- helpers ----------------------------------------------------------------
uver()  { echo "$1" | sed -E 's/-r[0-9]+$//; s/\+git[0-9].*$//'; }   # keep epoch, drop -rN/+git
verof() { awk -F'\t' -v n="$1" '$1==n{print $2; exit}' "$IDX"; }
have()  { awk -F'\t' -v n="$1" '$1==n{f=1} END{exit !f}' "$IDX"; }

# ships PKG NEED : does PKG install a file named NEED?
#   NEED starting with "/"  -> exact full-path match
#   otherwise               -> basename (soname file) match
ships() {
  case "$2" in
    /*) dpkg -L "$1" 2>/dev/null | grep -qx "$2" ;;
    *)  dpkg -L "$1" 2>/dev/null | sed 's:.*/::'  | grep -qx "$2" ;;
  esac
}

PROV=""; DEPS=""
addprov() { PROV="${PROV:+$PROV, }$1 (= $2)"; }
adddep()  { case " $DEPS " in *" $1 "*) : ;; *) DEPS="${DEPS:+$DEPS, }$1" ;; esac; }

# ---- 1) curated cross-name map ----------------------------------------------
# Format: ubuntu_name | yocto_pkg | required_file
# required_file is the EXACT soname (or path) an external binary needs. The entry
# is emitted ONLY if the Yocto pkg actually ships that file, so a name whose ABI
# major differs (e.g. libtinfo6 vs Yocto's libtinfo.so.5) is auto-skipped and
# left for the distro to install side-by-side.
#
# NOTE: libtinfo6 / libncurses6 / libncursesw6 are intentionally absent — Yocto's
# ncurses ships the .so.5 ABI here; those must come from the distro.
cat > "$OUT/.curated" <<'MAP'
perl-base|perl|/usr/bin/perl
libpython3.12t64|libpython3.12-1.0|libpython3.12.so.1.0
libbz2-1.0|libbz2-1|libbz2.so.1.0
libdb5.3t64|db|libdb-5.3.so
MAP

while IFS='|' read -r u y req; do
  [ -n "${u:-}" ] || continue
  if ! have "$y"; then
    echo "skip $u: backing '$y' not installed" >&2; continue
  fi
  if ! ships "$y" "$req"; then
    echo "skip $u: '$y' does not ship '$req' (ABI mismatch) -> distro will provide it" >&2
    continue
  fi
  addprov "$u" "$(uver "$(verof "$y")")"; adddep "$y"
done < "$OUT/.curated"

# ---- 2) mechanical t64 transition -------------------------------------------
# Every Yocto libfooN may also answer to libfooNt64 — but ONLY if libfooN really
# ships a .so whose major equals N. This guard prevents the libtinfo-style
# over-promise from ever being generated mechanically.
TAB="$(printf '\t')"
while IFS="$TAB" read -r name ver; do
  case "$name" in
    perl|libpython3.12-1.0|libbz2-1|db) continue ;;   # owned by curated map
    lib*[0-9]) : ;;                                   # only names ending in a digit
    *) continue ;;
  esac
  major=$(echo "$name" | sed -E 's/.*[^0-9]([0-9]+)$/\1/')
  if dpkg -L "$name" 2>/dev/null | sed 's:.*/::' | grep -qE "\.so\.${major}(\.|$)"; then
    addprov "${name}t64" "$(uver "$ver")"
  fi
  # else: package number != soname major -> skip silently (would over-promise)
done < "$IDX"

# ---- 3) write control + build the .deb with ar (BusyBox-safe) ---------------
cat > "$PKGDIR/DEBIAN/control" <<CTL
Package: yocto-debian-compat
Version: 1.0
Architecture: all
Maintainer: integration <root@localhost>
Multi-Arch: foreign
Depends: $DEPS
Provides: $PROV
Description: Name-bridge: Debian/Ubuntu virtual names -> Yocto base packages
 Ships no files. Declares the Debian package names (including the t64
 transition renames) that external .deb packages depend on as already
 satisfied by the Yocto-built base. Entries are SONAME-verified, so names
 whose ABI major differs from the Yocto package are deliberately omitted
 and left for the distro to install side-by-side.
CTL

BT="$OUT/.build"; rm -rf "$BT"; mkdir -p "$BT/empty"
(
  cd "$BT"
  echo "2.0" > debian-binary
  tar -czf control.tar.gz -C "$PKGDIR/DEBIAN" .
  tar -czf data.tar.gz -C empty .          # empty payload via empty DIR, not -T /dev/null
  rm -f "$DEB"
  ar rc "$DEB" debian-binary control.tar.gz data.tar.gz
)

np=$(echo "$PROV" | tr ',' '\n' | grep -c .)
nd=$(echo "$DEPS" | tr ',' '\n' | grep -c .)
echo "built: $DEB  (Provides: $np, Depends: $nd)"
command -v dpkg-deb >/dev/null 2>&1 && dpkg-deb -I "$DEB" >/dev/null 2>&1 \
  && echo "verified: dpkg-deb accepts the archive"
