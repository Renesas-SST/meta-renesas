# Program IPL from U-Boot console

This release also comes with automated host side scripts to help you flash the qspi boot firmware (IPL) using the images from sd card. Select the appropriate host side flashing script, execute it and power on the board.

There are scripts specific to Windows and Linux environments. However, they both perform the same operation.

## Outline of the folder
```
uload-bootloader
├── linux
│   ├── Readme.md
│   └── uload_bootloader_flash.py                  <---- Bootloader flashing script on Linux
├── Readme.md                                      <---- This document
└── windows
    ├── config.ini
    ├── Readme.md                                  <---- Bootloader flashing guideline on Windows
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
    └── uload-flash_bootloader.bat                 <---- Bootloader flashing script on Windows
```


## On Linux

Please refer to `Readme.md` file inside `linux` to know how to use the scripts.

## On Windows

Please refer to `Readme.md` file inside `windows` to know how to use the scripts.
