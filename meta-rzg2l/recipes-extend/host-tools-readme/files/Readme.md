# RZ/G2L-SBC Tools for Linux and Windows Platforms

## Description

This directory contains various tools and scripts used for managing and flashing bootloaders and filesystems across different platforms. The contents are organized into subdirectories based on their functionality and the operating system they support.

## A top-level directory of tools

```
tools
├── bootloader-flasher                            <---- Bootloader flashing script package folder
│   ├── linux                                     <---- Bootloader flashing script package folder on Linux
│   │   ├── bootloader_flash.py                   <---- Bootloader flashing script on Linux
│   │   └── Readme.md                             <---- Bootloader flashing script on Linux guideline
│   ├── Readme.md
│   └── windows                                   <---- Bootloader flashing script package folder on Windows
│       ├── config.ini
│       ├── flash_bootloader.bat                  <---- Bootloader flashing script on Windows
│       ├── Readme.md                             <---- Bootloader flashing script on Windows guideline
│       └── tools
│           ├── cygterm.cfg
│           ├── flash_bootloader.ttl
│           ├── TERATERM.INI
│           ├── ttermpro.exe
│           ├── ttpcmn.dll
│           ├── ttpfile.dll
│           ├── ttpmacro.exe
│           ├── ttpset.dll
│           └── ttxssh.dll
├── Readme.md                                     <---- This document
├── sd-creator                                    <---- SD card flashing script package folder
│   ├── linux                                     <---- SD card flashing script package folder on Linux
│   │   ├── sd_flash.sh                           <---- SD card flashing script on Linux
│   │   └── Readme.md                             <---- SD card flashing guideline on Linux
│   ├── Readme.md
│   └── windows                                   <---- SD card flashing script package folder on Windows
│       └── fastboot-udp-sd-flasher
│           ├── config.ini
│           ├── flash_filesystem.bat              <---- SD card flashing script on Windows
│           ├── Readme.md                         <---- SD card flashing guideline on Windows
│           └── tools
│               ├── AdbWinApi.dll
│               ├── cygterm.cfg
│               ├── fastboot.bat
│               ├── fastboot.exe
│               ├── flash_system_image.ttl
│               ├── TERATERM.INI
│               ├── ttermpro.exe
│               ├── ttpcmn.dll
│               ├── ttpfile.dll
│               ├── ttpmacro.exe
│               ├── ttpset.dll
│               └── ttxssh.dll
└── uload-bootloader                              <---- Bootloader flashing from U-Boot console package folder
    ├── linux                                     <---- Bootloader flashing from U-Boot console script package on Linux
    │   ├── uload_bootloader_flash.py             <---- Bootloader flashing from U-Boot console script on Linux
    │   └── Readme.md                             <---- Bootloader flashing from U-Boot console guideline on Linux
    ├── Readme.md
    └── windows                                   <---- Bootloader flashing from U-Boot console script package on Windows
        ├── config.ini
        ├── Readme.md                             <---- Bootloader flashing from U-Boot console guideline on Windows
        ├── tools
        │   ├── cygterm.cfg
        │   ├── TERATERM.INI
        │   ├── ttermpro.exe
        │   ├── ttpcmn.dll
        │   ├── ttpfile.dll
        │   ├── ttpmacro.exe
        │   ├── ttpset.dll
        │   ├── ttxssh.dll
        │   └── uload-flash_bootloader.ttl
        └── uload-flash_bootloader.bat             <---- Bootloader flashing script on Windows
```

## Usage

Refer to the `Readme.md` files within each subdirectory for detailed usage instructions and additional information about the specific tools and scripts provided.