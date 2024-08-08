# RZ/G2L-SBC Bootloader flasher for Linux and Windows Platforms

This release also comes with automated host side scripts to help you flash the bootloader images on RZ/G2L-SBC board. Select the appropriate host side flashing script, execute it and power on the board.

There are scripts specific to Windows and Linux environments. However, they both perform the same operation.

## Outline of the folder
```
bootloader-flasher
├── linux                                                    <---- Bootloader flashing script package folder on Linux
│   ├── bootloader_flash.py                                  <---- Bootloader flashing script on Linux
│   └── Readme.md                                            <---- Bootloader flashing script on Linux guideline
├── Readme.md                                                <---- This document
└── windows                                                  <---- Bootloader flashing script package folder on Windows
    ├── config.ini
    ├── flash_bootloader.bat                                 <---- Bootloader flashing script on Windows
    ├── Readme.md                                            <---- Bootloader flashing script on Windows guideline
    └── tools
        ├── cygterm.cfg
        ├── flash_bootloader.ttl
        ├── TERATERM.INI
        ├── ttermpro.exe
        ├── ttpcmn.dll
        ├── ttpfile.dll
        ├── ttpmacro.exe
        ├── ttpset.dll
        └── ttxssh.dll
```

## On Linux

Please refer to `Readme.md` file inside `linux` to know how to use the scripts.

## On Windows

Please refer to `Readme.md` file inside `windows` to know how to use the scripts.
