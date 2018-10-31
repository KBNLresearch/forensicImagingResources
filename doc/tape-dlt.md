# DLT-IV tape

## Introduction

[Digital Linear Tape (DLT)](https://en.wikipedia.org/wiki/Digital_Linear_Tape) is is a family of tape formats that were developed by Digital Equipment Corporation (DEC)from 1984 onwards.

## Hardware

### Tape reader

|**Model**|[IBM 7205 440](https://www.cnet.com/products/ibm-7205-440-tape-drive-dlt-scsi/specs/)|
|:--|:--|
|**Media**|DLT IV (and possibly DLT III)|
|**SCSI Signaling Type**|Low Voltage Differential (LVD)|
|**Interface**|Fast Wide SCSI|
|**Connector**|68 pin HD D-Sub (HD-68) (see also 5th from top [here](http://www.paralan.com/sediff.html))|
|**Cable**|At the outgoing side is a male VHDCI SCSI connector (bottommost [here](http://www.paralan.com/sediff.html))|
|**Workstation connection**|Can be connected directly with workstation's SCSI controller (which has a female VHDCI connector)|

### SCSI controller

|**Model**|[Adaptec SCSI Card 29320LPE](https://storage.microsemi.com/en-us/support/scsi/u320/asc-29320lpe/)|
|:--|:--|
|**Bus System Interface Type**|[PCI Express](https://en.wikipedia.org/wiki/PCI_Express) x1|
|**External Connectors**|[68-pin VHDCI](https://en.wikipedia.org/wiki/Very-high-density_cable_interconnect)|
|**Data Transfer Rate**|Up to 320 MByte/sec.|

#### Note on bracket height

Note that by default the controller has a standard height (120 mm) bracket that won't fit into a low-profile (79.2 mm) slot! When these controllers were sold new, they came with a replacement low-profile bracket, but these are often not included with used ones. The low-profile replacement brackets are sometimes sold separately on eBay.

## Loading a tape

1. Check the write-protect tab on the bottom of the tape, and slide it to
the leftmost position. The orange indicator must be visible:

    ![](./img/dlt-protect.jpg)

2. Insert the tape into the drive. Make sure the printed side is on top, and that the tape is inserted in the direction of the arrow symbol:

    ![](./img/dlt-insert.jpg)



## Procedure for reading a tape

During first test run of script the following message was printed to the console while reading: 


    ###!!! [Parent][DispatchAsyncMessage] Error: PClientSourceOp::Msg___delete__ Route error: message sent to unknown actor ID

Unclear if this is even related to the imaging script. A Google search on this error returns almost exclusively hits that are related to bugs in Firefox. Interestingly Firefox was launched from the same terminal window, so maybe Firefox somehow sent this back to its parent process?

## Resources

- [Write protect in DLT IV Data cartridge](https://community.hpe.com/t5/StoreEver-Tape-Storage/Write-protect-in-DLT-IV-Data-cartridge/td-p/129718)