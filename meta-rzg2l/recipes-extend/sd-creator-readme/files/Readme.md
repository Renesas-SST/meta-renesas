# RZ/G2L-SBC SD Card creator flashing for Linux and Windows Platforms

This release also includes automated host-side scripts that simplify the process of flashing the filesystem to SD cards. The flashing approach differs based on the host platform:

- Linux: The flashing process is performed directly on the host PC, where the SD card is inserted, and a script writes the filesystem to the SD card.

- Windows: The flashing process uses User Datagram Protocol (UDP), where the SD card remains inserted in the RZ/G2L-SBC board, and the filesystem is flashed remotely from the host PC.

Select the appropriate script for your platform and follow the instructions to complete the flashing process

## Outline of the folder
```
sd-creator
├── linux                                                    <---- SD card flashing script package folder on Linux
│   ├── sd_flash.sh                                          <---- SD card flashing script on Linux
│   └── Readme.md                                            <---- SD card flashing guideline on Linux
├── Readme.md
└── windows                                                  <---- SD card flashing script package folder on Windows
    ├── config.ini
    ├── flash_filesystem.bat                                 <---- SD card flashing script on Windows
    ├── Readme.md                                            <---- SD card flashing guideline on Windows
    └── tools
        ├── AdbWinApi.dll
        ├── cygterm.cfg
        ├── fastboot.bat
        ├── fastboot.exe
        ├── flash_system_image.ttl
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
