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

## Software

Additional software for working with tape devices:

    sudo apt install lsscsi

## General tape commands

List installed SCSI tape devices:

    lsscsi

Result:

    [0:0:2:0]    tape    HP       C1533A           A708  /dev/st0 
    [1:0:0:0]    disk    ATA      WDC WD2500AAKX-6 1H18  /dev/sda 
    [3:0:0:0]    cd/dvd  hp       DVD A  DH16ABSH  YHDD  /dev/sr0 
    [7:0:0:0]    disk    WD       Elements 25A2    1021  /dev/sdb

So our tape device is ` /dev/st0`.

Display tape status:

    sudo mt -f /dev/st0 status

Result:

    drive type = 114
    drive status = 318767104
    sense key error = 0
    residue count = 0
    file number = 0
    block number = 0

Rewind tape:

    sudo mt -f /dev/st0 rewind

Eject tape:

    sudo mt -f /dev/st0 eject

## Loading a tape

1. Check the write-protect tab on the bottom of the tape, and slide it to
the open position:

    ![](./img/dds-protect.jpg)

2. Insert the tape into the drive. Make sure the printed side is on top, and that the tape is inserted in the direction of the arrow symbol:

    ![](./img/dds-insert.jpg)

## Procedure for reading an NTBackup tape

1. Load the tape

2. Determine the block size by entering:

        sudo dd if=/dev/st0 of=tmp.dd ibs=128 count=1

    If this results in a *Cannot allocate memory* error message, repeat the above command with a larger ibs value (e.g. 256). Repeat until the error goes away and some data is read. For instance:

        sudo dd if=/dev/st0 of=tmp.dd ibs=512 count=1

    Results in:

        1+0 records in
        1+0 records out
        512 bytes copied, 0.308845 s, 1.7 kB/s
    
    Which means that the block size is 512 bytes.

 3. Read blocks (note that we're using the non-rewinding tape device ` /dev/nst0` here):

        for f in `seq 1 10`; do sudo dd if=/dev/nst0 of=tapeblock`printf "%06g" $f`.bin ibs=512; done

    Question: why 10 iterations? What does each iteration represent (a backup session? something else?)

## Resources

- [15 Useful Linux and Unix Tape Managements Commands For Sysadmins](https://www.cyberciti.biz/hardware/unix-linux-basic-tape-management-commands/)

- [Recovering NTBackup Tapes](https://www.108.bz/posts/it/recovering-ntbackup-tapes/)

- [Linux Set the Block Size for a SCSI Tape Device](https://www.cyberciti.biz/faq/rhel-centos-debian-set-tape-blocksize/)

- [mtftar](https://github.com/sjmurdoch/mtftar) - mtftar is a tool for translating a MTF stream to a TAR stream