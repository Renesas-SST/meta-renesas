# RZ/G2L-SBC host folder

## Description

This directory contains files and tools used for managing and deploying images to the RZ/G2L-SBC platform. It includes build artifacts, manifests, test data, and documentation.

## A top-level directory of host

```
$ tree -L 1
host/
├── build
├── env
├── Readme.md
├── src
└── tools

4 directories, 1 file
```

- `build/`: Contains build output files such as root filesystem manifests, test data, and image metadata for various Yocto-built images.

- `env/`: Environment variable files for Yocto builds, containing exported variables that set up the build environment for different images.

- `src/`: Contains the main build scripts, including a single script that automates building the entire Yocto project from scratch.

- `tools/`: Utility scripts and tools for flashing bootloaders, creating SD card images, with support for both Linux and Windows platforms.

## Usage

Each subdirectory includes its own `Readme.md` with detailed descriptions and instructions:

- See `env/Readme.md` for environment configurations and setting up the Yocto build environment.
- See `src/rz-cmn-srp/README.md` for details on the main build script and how to use it.
- See `tools/Readme.md`  for instructions on platform-specific utilities and deployment tools.
