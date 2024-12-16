# RZ/G2L-SBC overlays Folder

## Description

This directory includes Device Tree Overlay (DTO) files that extend or modify the base Device Tree configuration. Overlays are used to enable or configure additional hardware features or peripherals on the RZ/G2L-SBC platform.

## A top-level directory of overlays

```
overlays                                       
├── rzpi-can.dtbo                         <---- Overlay for CAN interface
├── rzpi-dsi.dtbo                         <---- Overlay for DSI display interface
├── rzpi-ext-i2c.dtbo                     <---- Overlay for external I2C devices
├── rzpi-ext-spi.dtbo                     <---- Overlay for external SPI devices
├── rzpi-ov5640.dtbo                      <---- Overlay for OV5640 camera
└── Readme.md                             <---- This document
```

### Files
- **rzpi-can.dtbo**: Overlay for configuring the CAN interface.
- **rzpi-dsi.dtbo**: Overlay for configuring the DSI display interface.
- **rzpi-ext-i2c.dtbo**: Overlay for enabling external I2C devices.
- **rzpi-ext-spi.dtbo**: Overlay for enabling external SPI devices.
- **rzpi-ov5640.dtbo**: Overlay for integrating the OV5640 camera.