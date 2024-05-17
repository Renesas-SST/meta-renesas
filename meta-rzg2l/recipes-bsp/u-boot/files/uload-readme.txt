# Program IPL from U-Boot console

In case users want to program IPL directly from U-Boot, we prepare some scripts to automate the flashing process.

The scripts support on both Linux and Windows OS.

## Outline of the folder
```
uload-bootloader
├── bl2_bp-rzpi.bin
├── fip-rzpi.bin
├── uload_bootloader_flash.py                    <---- Bootloader flashing script on Linux
├── uload-bootloader-windows-script              <---- Bootloader flashing script package on Windows
│   ├── config.ini
│   ├── Readme.txt                               <---- Bootloader flashing guideline on Windows
│   ├── tools
│   │   ├── cygterm.cfg
│   │   ├── TERATERM.INI
│   │   ├── ttermpro.exe
│   │   ├── ttpcmn.dll
│   │   ├── ttpfile.dll
│   │   ├── ttpmacro.exe
│   │   ├── ttpset.dll
│   │   ├── ttxssh.dll
│   │   └── uload-flash_bootloader.ttl
│   └── uload-flash_bootloader.bat               <---- Bootloader flashing script on Windows
└── uload-readme.txt                             <---- This document
```

## On Linux

Please run the follow command to know how to use the script:

```
./uload_bootloader_flash.py -h
```

**Note:**

**1. Before performing a flashing, make sure the board is powered off and SD Card is attached on the board with the latest root filesystem (for details, see `Prepare image and rootfs in microSD card on Linux/Windows` in the startup guide `README.md`)**

**2. (Optional) Default bootloader images (.bin) are located in the folder `/boot/uload-bootloader` of the root filesystem. You can put your own bootloader images there and perform a flashing by some manual steps in U-Boot console as below:**

- Step 1: probe the QSPI NOR flash on RZG2L SBC board.
```
=> sf probe
```

- Step 2: erase the current IPL

**Warning: this step will erase all data on QSPI NOR flash. If step 3 and step 4 are not proceed next, you will not be able to boot RZG2L SBC board.**
```
=> sf erase 0 100000
```

- Step 3: load bl2 bootloader into DRAM and then write to QSPI NOR flash.

```
=> ext4load mmc 0:2 0x48000000 boot/uload-bootloader/bl2_bp-rzpi.bin
=> sf write 0x48000000 0 $filesize
```

- Step 4: load fip file into DRAM and then write to QSPI NOR flash.

```
=> ext4load mmc 0:2 0x48000000 boot/uload-bootloader/fip-rzpi.bin
=> sf write 0x48000000 1d200 $filesize
```

## On Windows

Please refer to `Readme.txt` file inside `uload-bootloader-windows-script` to know how to use the scripts.
