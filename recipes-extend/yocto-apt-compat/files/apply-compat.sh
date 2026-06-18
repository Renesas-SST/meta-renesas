#!/bin/sh
# apply-compat.sh — make a Yocto (deb-populated) rootfs safely accept external
# Debian/Ubuntu .debs without overwriting the Yocto base.
#
#   1. removes the broken APT preferences file from earlier attempts
#   2. (re)generates + builds the SONAME-verified name-bridge  (gen-bridge.sh)
#   3. installs the bridge
#   4. HOLDS every Yocto-built package + the bridge  -> apt can never rewrite the base
#   5. refreshes apt + the linker cache
#
# Non-Yocto (distro) packages remain free to install AND upgrade.
# Idempotent: safe to re-run after a Yocto image / feed update.
#
# Run as root, on the target, with gen-bridge.sh in the same directory.
set -eu

HERE=$(cd "$(dirname "$0")" && pwd)
OUTDIR="${OUTDIR:-/var/lib/yocto-compat}"
export OUTDIR
DEB="$OUTDIR/yocto-debian-compat_1.0_all.deb"

echo ">> [1/5] removing the broken APT preferences file if present"
rm -f /etc/apt/preferences.d/yocto-priority

echo ">> [2/5] generating + building the name-bridge from the live system"
sh "$HERE/gen-bridge.sh"

echo ">> [3/5] installing the bridge (deps already present; dpkg -i bypasses holds)"
dpkg -i "$DEB"

echo ">> [4/5] holding every Yocto-built package + the bridge"
dpkg-query -W -f='${Package} ${Version}\n' \
  | awk '$2 ~ /-r[0-9]+$/ {print $1}' \
  | xargs -r apt-mark hold >/dev/null
apt-mark hold yocto-debian-compat >/dev/null
echo "   held $(apt-mark showhold | wc -l) packages"

echo ">> [5/5] refreshing apt + linker cache"
ldconfig

cat <<'DONE'

Done. The Yocto base is frozen; distro packages may be added and upgraded.

VERIFY a package before installing it:
    apt-get install -s --no-install-recommends <pkg>
  Want: '0 upgraded, 0 to remove'; the install list should hold only genuine
  gaps, NOT names the bridge provides (perl-base, the *t64 libs, etc.).

After installing, CONFIRM it actually runs (no GNU ldd on a BusyBox image):
    LD_TRACE_LOADED_OBJECTS=1 /usr/bin/<binary> 2>&1 | grep -i 'not found'
    objdump -p /usr/bin/<binary> | grep NEEDED      # the SONAMEs it really wants
  Empty 'not found' output = every library resolved against the Yocto base.

If a library shows 'not found', the Yocto side ships a DIFFERENT .so major than
the distro binary needs (e.g. libtinfo: Yocto .so.5 vs distro .so.6). That name
must NOT be bridged. The generator already SONAME-verifies the curated map and
the t64 aliases, so this should only surface for a brand-new case — when it does,
just install the distro library directly; it coexists side-by-side:
    apt-get install --no-install-recommends <the-distro-lib>   # e.g. libtinfo6
    ldconfig

After a new Yocto image or feed update, re-run this script to regenerate the
bridge against the new versions.
DONE
