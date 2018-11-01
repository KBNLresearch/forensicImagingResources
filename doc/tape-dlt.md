# DLT-IV tape

## Introduction

[Digital Linear Tape (DLT)](https://en.wikipedia.org/wiki/Digital_Linear_Tape) is is a family of tape formats that were developed by Digital Equipment Corporation (DEC)from 1984 onwards.

## Hardware

### Tape reader

|**Model**|[IBM 7205 440](https://web.archive.org/web/20181101132449/https://www-01.ibm.com/common/ssi/cgi-bin/ssialias?infotype=DD&subtype=SM&htmlfid=649/ENUS7205-440)|
|:--|:--|
|**Media**|DLT IV (and possibly DLT III)|
|**SCSI Signaling Type**|Low Voltage Differential (LVD)|
|**Interface**|Fast Wide SCSI|
|**Connector**|68 pin HD D-Sub (HD-68) (see also 5th from top [here](http://www.paralan.com/sediff.html))|
|**Cable**|At the outgoing side is a male VHDCI SCSI connector (bottommost [here](http://www.paralan.com/sediff.html))|
|**Workstation connection**|Can be connected directly with workstation's SCSI controller (which has a female VHDCI connector)|
|**Documentation**|-[IBM 7205 Model 440 40 GB External Digital Linear Tape  Drive  Enhances  Data  Storage](https://web.archive.org/web/20181101131555/https://www-01.ibm.com/common/ssi/rep_ca/2/897/ENUS101-062/ENUS101-062.PDF)<br>-[7205 Model 440 Digital Linear Tape Drive Setup and Operator Guide](https://web.archive.org/web/20181101132208/http://ps-2.kev009.com/basil.holloway/ALL%20PDF/a4100501.pdf)|

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

Reading of 18.6 GB tape: takes about 1.5 hr.

## Resources

- [Write protect in DLT IV Data cartridge](https://community.hpe.com/t5/StoreEver-Tape-Storage/Write-protect-in-DLT-IV-Data-cartridge/td-p/129718)