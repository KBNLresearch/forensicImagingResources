# DDS tape

## Introduction

[Digital Data Storage (DDS)](https://en.wikipedia.org/wiki/Digital_Data_Storage) is a family of tape formats that are based on [digital audio tape](https://en.wikipedia.org/wiki/Digital_audio_tape) (DAT).

## Hardware

### Tape reader

|**Model**|[HP SureStore DAT8](http://www.hp.com/ecomcat/hpcatalog/specs/S4112B.htm)|
|:--|:--|
|**Media**|DDS-2 (8 GB), DDS-1 (2.6 GB and 4 GB)|
|**Interface**|Single-ended, narrow SCSI-2|
|**Connector**|50-contact, centronics-type connector ("SCSI-1 Connector" AKA "Alternative 2, A-cable connector"), female (see also the topmost connector [here](http://www.paralan.com/sediff.html))[^1]|
|**Cable**|Attached to the device is a [Single Ended HD68 TO LD50 SCSI Cable](https://web.archive.org/web/20180606100950/http://www.itinstock.com/hp-c5665-61001-single-ended-hd68-to-ld50-scsi-cable-1-meter-40938-p.asp). The connector other end is a 68-pin DB68 (MD68) male connector (also known as High-Density or HD 68 and Half-Pitch or HP68)|
|**Workstation connection**|With this [HD68 to VHDCI adapter](https://web.archive.org/web/20181002103944/https://www.ramelectronics.net/sm-044-r.aspx) the reader can be hooked up to the workstation's SCSI controller (which has a female VHDCI connector)|

[^1]: This is somewhat strange, since the specs explicitly state the drive has a SCSI-2 interface

### SCSI controller

|**Model**|[Adaptec SCSI Card 29320LPE](https://storage.microsemi.com/en-us/support/scsi/u320/asc-29320lpe/)|
|:--|:--|
|**Bus System Interface Type**|[PCI Express](https://en.wikipedia.org/wiki/PCI_Express) x1|
|**External Connectors**|[68-pin VHDCI](https://en.wikipedia.org/wiki/Very-high-density_cable_interconnect)|
|**Data Transfer Rate**|Up to 320 MByte/sec.|

#### Note on bracket height

Note that by default the controller has a standard height (120 mm) bracket that won't fit into a low-profile (79.2 mm) slot! When these controllers were sold new, they came with a replacement low-profile bracket, but these are often not included with used ones. The low-profile replacement brackets are sometimes sold separately on eBay.

## Procedure for reading a tape