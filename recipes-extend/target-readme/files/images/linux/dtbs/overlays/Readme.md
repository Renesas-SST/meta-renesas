# RZ overlays Folder

## Description

This directory includes Device Tree Overlay (DTO) files that extend or modify the base Device Tree configuration. Overlays are used to enable or configure additional hardware features or peripherals on the RZ Common System platform.

## A top-level directory of overlays

```
overlays/
├── Readme.md                                  <---- This document
├── rzg2l-evk-1.0-cru-csi-ov5645.dtbo          <---- RZ/G2L-EVK overlay for OV5645 camera
├── rzg2l-sbc-1.0-can.dtbo                     <---- RZ/G2L-SBC overlay for CAN interface
├── rzg2l-sbc-1.0-dsi.dtbo                     <---- RZ/G2L-SBC overlay for external DSI devices
├── rzg2l-sbc-1.0-ext-i2c.dtbo                 <---- RZ/G2L-SBC overlay for external I2C devices
├── rzg2l-sbc-1.0-ext-spi.dtbo                 <---- RZ/G2L-SBC overlay for external SPI camera
├── rzg2l-sbc-1.0-ov5640.dtbo                  <---- RZ/G2L-SBC overlay for OV5640 camera
├── rzv2h-rdk-1.0-audio-codec.dtbo             <---- RZ/V2H-RDK overlay for audio codec
├── rzv2h-rdk-1.0-can.dtbo                     <---- RZ/V2H-RDK overlay for CAN interface
├── rzv2h-rdk-1.0-ext-spi.dtbo                 <---- RZ/V2H-RDK overlay for external SPI
└── rzv2l-evk-1.0-cru-csi-ov5645.dtbo          <---- RZ/V2L-EVK overlay for OV5645 camera
```

### Files
- ***can.dtbo**: Overlay for configuring the CAN interface.
- ***dsi.dtbo**: Overlay for configuring the DSI display interface.
- ***ext-i2c.dtbo**: Overlay for enabling external I2C devices.
- ***ext-spi.dtbo**: Overlay for enabling external SPI devices.
- ***ov5640.dtbo**: Overlay for integrating the OV5640 camera.
- ***ov5645.dtbo**: Overlay for integrating the OV5640 camera.
- ***audio-codec.dtbo**: Overlay for configuring audio interface.
