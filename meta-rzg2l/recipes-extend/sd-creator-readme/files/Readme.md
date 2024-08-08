# RZ/G2L-SBC SD Card creator flashing for Linux and Windows Platforms

This release also includes automated host-side scripts that simplify the process of flashing the filesystem to SD cards. Select the appropriate script for your host platform, execute it, and power on the board.

The scripts support on both Linux and Windows OS.

## Outline of the folder
```
sd-creator
├── linux                                                    <---- SD card flashing script package folder on Linux
│   ├── sd_flash.sh                                          <---- SD card flashing script on Linux
│   └── Readme.md                                            <---- SD card flashing guideline on Linux
├── Readme.md
└── windows                                                  <---- SD card flashing script package folder on Windows
    └── fastboot-udp-sd-flasher
        ├── config.ini
        ├── flash_filesystem.bat                             <---- SD card flashing script on Windows
        ├── Readme.md                                        <---- SD card flashing guideline on Windows
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
