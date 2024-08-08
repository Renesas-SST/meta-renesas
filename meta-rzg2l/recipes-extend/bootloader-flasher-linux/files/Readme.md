# Bootloader Flashing on RZ/G2L-SBC on Linux

The script simplifies the process by automating the flashing of bootloader images onto the RZ/G2L-SBC board in a Linux environment.

## Outline of the folder
```
bootloader-flasher
└── linux
   ├── bootloader_flash.py
   └── Readme.md
```
## On Linux

### Getting help

Run the following comamnd to know how to use the script

```
./bootloader_flash.py -h
```

### Basic Usage

To run the script without passing any arguments, simply execute the following command:

```
./bootloader_flash.py
```

When no arguments are provided, the script will use the following default file paths for the images:

- Flash Writer Image: </path/to/your/package>/target/images/Flash_Writer_SCIF_rzpi.mot
- BL2 Image: </path/to/your/package>/target/images/bl2_bp-rzpi.srec
- FIP Image: </path/to/your/package>/target/images/fip-rzpi.srec

Ensure that these files are present in the current directory before executing the script.

### Custom Usage

If you want to specify different file paths or change the serial port settings or images file, you can pass the arguments as shown below:

```
./bootloader_flash.py --serial_port /dev/ttyUSB1 --serial_port_baud 9600 --image_writer /path/to/Flash_Writer_SCIF_rzpi.mot --image_bl2 /path/to/bl2_bp-rzpi.srec --image_fip /path/to/fip-rzpi.srec
```

#### Arguments
- **--serial_port**: Serial port to use for communication with the board. Default is /dev/ttyUSB0.
- **--serial_port_baud**: Baud rate for the serial port. Default is 115200.
- **--image_writer**: Path to the Flash Writer image.
- **--image_bl2**: Path to the BL2 image.
- **--image_fip**: Path to the FIP image.

#### Example command

```
./bootloader_flash.py --serial_port /dev/ttyUSB1 --serial_port_baud 9600 --image_writer /home/renesas/bootloader_images/Flash_Writer_SCIF_rzpi.mot --image_bl2 /home/renesas/bootloader_images/bl2_bp-rzpi.srec --image_fip /home/renesas/bootloader_images/fip-rzpi.srec
```
