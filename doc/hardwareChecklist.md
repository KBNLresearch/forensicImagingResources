## Hardware checklist

|Hardware|In stock?|Comments|
|:--|:--|:--|
|Dedicated desktop for disk imaging / data extraction|1|Machine with BitCurator as main OS|
|Separate desktop / laptop|?|Needed for looking up on-line documentation, and documenting the recovery process (lab book)|
|Write blockers|-|SATA/IDE; USB; possibly SCSI (most vendors appear to have discontinued SCSI blockers)|
|USB 3.5" floppy drives|1|[Doesn't work for e.g. Mac-formatted discs](https://porterolsen.wordpress.com/2016/06/15/accessing-mac-formatted-floppy-disks-without-the-kryoflux/); might not play well with USB write blockers|
|5.25" floppy drives|1|I think we have at least 1 in storage, needs checking|
|Controller for 5.25" floppy drive/ USB adapter|-|Several options are listed [here](https://www.archiveteam.org/index.php/Rescuing_Floppy_Disks). Many colleagues use   [Kryoflux](https://www.kryoflux.com/); for 5.25" drives [Device Side Data's FC5025](http://www.deviceside.com/fc5025.html) looks like an interesting (and cheap) option|
|ZIP drives|?|I think we have at least 1 in storage, needs checking|
|Tape drive, DDS-1|1|[Digital Data Storage](https://en.wikipedia.org/wiki/Digital_Data_Storage)
|Tape drive, DLT-IV|1|[Digital Linear Tape](https://en.wikipedia.org/wiki/Digital_Linear_Tape)|
|Old, unimportant DDS-1 and DLT-IV tapes for testing|Yes, several|Needed for testing the tape readers, as we don't want to accidentally destroy any important tapes because the tape readers are not working properly!|
|SCSI PCI card(s)|-|Needed for connecting SCSI tape drives. A bit tricky because of the plethora of SCSI variants and connectors; see also [here](http://qanda.digipres.org/1160/best-way-to-read-scsi-tape-drive-on-a-modern-pc)|
|Various SCSI converters||See also the [SCSI Connector Guide](https://www.cablestogo.com/learning/connector-guides/scsi)|
|Various cables and adapters||Useful resources are [The Cable Bible](https://amiaopensource.github.io/cable-bible/), [SCSI Connector Guide](https://www.cablestogo.com/learning/connector-guides/scsi) and [the SCSI articles on Paralan](http://www.paralan.com/aboutscsi.html)|
|Power strips; spare power cables|-||
|Cans of compressed air for blowing away dust|||
|Utility kit with screwdrivers|||
|Camera (for documentation)|-||
|Grounded bench|-|Needed to for working with electronic components. Room may need other measures to reduce electrostatic discharge. See e.g. [this blog about Michigan University's Digital Preservation Lab](https://www.lib.umich.edu/blogs/bits-and-pieces/digital-preservation-lab-20)|
|Anti-static wrist straps|||

This checklist is partially based on [DIY Handboek voor Webarcheologie](https://hart.amsterdam/image/2017/11/17/20171116_freeze_diy_handboek.pdf) by Tjarda de Haan, Robert Jansma and Paul Vogel.

## Tape readers

We currently have the following tape readers:

### DDS tapes

[HP SureStore DAT8](http://www.hp.com/ecomcat/hpcatalog/specs/S4112B.htm) DDS drive. 

**Interface**: Single-ended, narrow SCSI-2.

**Connector**: drive has a 50-contact female connector which looks an awful lot like a 50-contact, centronics-type connector ("SCSI-1 Connector" AKA "Alternative 2, A-cable connector"). See also the topmost connector [here](http://www.paralan.com/sediff.html). This is somewhat strange, since the specs explicitly state the drive has a SCSI-2 interface. 

Alternatively it *might* be a 50-pin high-density SCSI connector ("SCSI-2 Connector" AKA "Alt 1, A-cable connector"); 3rd from top [here](http://www.paralan.com/sediff.html). But the distance between the two contact rows in the illustration appears to be smaller than on the actual drive.

However looking up the product code on the terminator connected to the bottom connector (which is identical to the upper one) returns [this](https://web.archive.org/web/20181002100536/https://www.ebay.com/itm/DM800-09-R-DataMate-SCSI-Terminator-50-Pin-Centronics-/350546682678), which says it is a "50-Pin Centronics" type connector, i.e. a "SCSI-1" connector (which matches the visual identification).

**Cable**: attached to the device is a [Single Ended HD68 TO LD50 SCSI Cable](https://web.archive.org/web/20180606100950/http://www.itinstock.com/hp-c5665-61001-single-ended-hd68-to-ld50-scsi-cable-1-meter-40938-p.asp). The connector that goes into the PCI card is a 68-pin DB68 (MD68) connector (also known as High-Density or HD 68 and Half-Pitch or HP68).

Note that the 50-pin connector is listed as "LD50". A search on "LD50" and "SCSI" turned up [this](http://carlsralp.www3.50megs.com/computer/connectr/scsiconn.html#ld) link, which says:

> LD50 is SCSI-1 standard and is still used for many narrow (formerly called 8bit SCSI) devices.
> Consider using the HD50 for new designs. HD50 is SCSI-2 standard, fully compatible with LD50, support higher frequency such as UltraSCSI and is smaller. 

This suggests the connector on the device is most likely indeed a centronics-type "SCSI-1" connector.

### DLT-IV tapes

[IBM 7205 440](https://www.cnet.com/products/ibm-7205-440-tape-drive-dlt-scsi/specs/) DLT drive.

* **SCSI Signaling Type**: Low Voltage Differential (LVD)
* **Interface**: Fast Wide SCSI
* **Connector Type**: 68 pin HD D-Sub (HD-68)

At the back of the machine is a 68-contact female connector, which visually matches the "68-pin high-density SCSI connector" ("SCSI-3 Connector" AKA "Alt 3, P-cable connector"); 5th from top [here](http://www.paralan.com/sediff.html). This is consistent with the specification. Additionally below the connector is a label with the text "SCSI LVD".

**Cable**: connector at the outgoing side VHDCI SCSI connector (bottommost [here](http://www.paralan.com/sediff.html)). Looking up the product code on the cable (19P0279) also returns several hits that describe it as a "VHDCI to 68pin cable" ([example](http://www.vibrant.com/IBM-19p0279.html)).

## Connecting to modern machines

See:

[Best way to read SCSI tape drive on a modern PC?](http://qanda.digipres.org/1160/best-way-to-read-scsi-tape-drive-on-a-modern-pc)

Also, the situation with different SCSI types, interfaces and connectors is quite complex, and apparently interface mismatches [can result in damage to the hardware](https://twitter.com/charles_forsyth/status/1004356758893154305). So we have to be careful here, and may need multiple SCSI cards. This needs further investigation.

More info on the compatibility between the different SCSI types can be found [here](https://en.wikipedia.org/wiki/Parallel_SCSI#Compatibility). Note:

> The SPI-5 standard (which describes up to Ultra-640) deprecates single-ended devices, so some devices may not be electrically backward compatible

### SCSI Controllers

<!--

Some options (non-exhaustive list):

* [Adaptec 2248700-R U320 PCI Express X1 1-Channel SCSI Host Bus Adapter](https://www.amazon.com/Adaptec-2248700-R-Express-1-Channel-Adapter/dp/B000NX3PII)
* [Adaptec SCSI Card 29320LPE](https://storage.microsemi.com/en-us/support/scsi/u320/asc-29320lpe/)
* [Adaptec SCSI Card 29160](https://storage.microsemi.com/en-us/support/scsi/u160/asc-29160/), [here on Marktplaats](https://link.marktplaats.nl/m1287640942); [eBay](https://www.ebay.nl/itm/Adaptec-Controller-Card-SCSI-Card-29160-PCI-SCSI-Adapter/232728027802)
* [Adaptect aha-2940uw](https://storage.microsemi.com/en-us/support/scsi/2940/aha-2940uw/), [here on Marktplaats](https://link.marktplaats.nl/m1286986209); [eBay](https://www.ebay.nl/itm/Adaptec-Controller-Card-AHA-2940-U-PCI-SCSI-Adapter-Karte-NUR/252975323891)

These controllers are often available cheap on sites like eBay and Marktplaats.

Unknown to what extent these controllers work on Linux (Ubuntu) without separately installed drivers.



* [Adaptec SCSI Card 29160](https://storage.microsemi.com/en-us/support/scsi/u160/asc-29160/). Back panel shows "LVD/SE", check [here](http://www.paralan.com/scsiexpert.html) for any possible compatibility issues. Connector (outside) is a 68-contact female connector, which visually matches the "68-pin high-density SCSI connector" ("SCSI-3 Connector" AKA "Alt 3, P-cable connector"); 5th from top [here](http://www.paralan.com/sediff.html). NOTE: Bus System Interface Type  is 64-bit PCI so won't fit in modern machine!

*  [Adaptect aha-2940](https://storage.microsemi.com/en-us/support/scsi/2940/aha-2940/). Bus System Type is PCI; might need a PCI Express to PCI Adapter  to work on modern machine. Options:
    * [Startech PCI Express to PCI Adapter Card](https://www.startech.com/nl/en/Cards-Adapters/Slot-Extension/PCI-Express-to-PCI-Adapter-Card~PEX1PCI1)
    * [Sintech PCI-E Express X1 to Dual PCI Riser Extender Card](https://www.amazon.com/gp/product/B00KZHDSLQ?psc=1&redirect=true&ref_=oh_aui_detailpage_o07_s00)

-->

[Adaptec SCSI Card 29320LPE](https://storage.microsemi.com/en-us/support/scsi/u320/asc-29320lpe/). Bus System is PCIe x1 (PCI Express), so should work on modern motherboard. External connector is [VHDCI 68-pin](http://www.paralan.com/sediff.html) (female).

### SCSI Cables

* DLT-IV machine: default cable is compatible with the Adaptec 29320LPE controller.
* DDS machine: default cable *not* compatible with Adaptec 29320LPE controller; would need an LD 50 (male) to 68-pin VHDCI 68 (male) cable. Or connect [this adapter](https://web.archive.org/web/20181002103944/https://www.ramelectronics.net/sm-044-r.aspx) (in: HD68, female; out: VHDCI male) to the existing cable.

## Reading the tapes

The following resources all use standard unix tools:

* [How to use the DAT-tape with Linux](http://www.cs.inf.ethz.ch/stricker/lab/linux_tape.html) - should work for DDS tapes (and possibly DLT tapes as well)
* [LTO 1 and 2 (Ultrium 1 and 2) tape archiving](http://www.sb.fsu.edu/~xray/Manuals/LTO-1_LTO-2_DDS_tape_archiving.html)
* [15 Useful Linux and Unix Tape Managements Commands For Sysadmins](https://www.cyberciti.biz/hardware/unix-linux-basic-tape-management-commands/)
* [Duplicating a tape drive using dd ](https://www.linuxquestions.org/questions/linux-newbie-8/duplicating-a-tape-drive-using-dd-4175592839/) - some useful suggestions on how to use dd and how to determine correct block size

## Resources

* [What kind of SCSI do I have? Single-ended or differential SCSI interface?](http://www.paralan.com/sediff.html)
* [LVD, SE, HVD, SCSI Compatibility - Or Not](http://www.paralan.com/scsiexpert.html)
* [SCSI articles on Paralan](http://www.paralan.com/aboutscsi.html)
* [SCSI Connector Guide](https://www.cablestogo.com/learning/connector-guides/scsi)
* [The Cable Bible](https://amiaopensource.github.io/cable-bible/)
* [DIY Handboek voor Webarcheologie](https://hart.amsterdam/image/2017/11/17/20171116_freeze_diy_handboek.pdf)
* [Getting to Know FRED: Introducing Workflows for Born-Digital Content](https://practicaltechnologyforarchives.org/issue4_prael_wickner/)
* [Digital Forensics and Preservation (DPC Report)](http://dx.doi.org/10.7207/twr12-03)
* [Rescuing Floppy Disks (ArchiveTeam)](https://www.archiveteam.org/index.php/Rescuing_Floppy_Disks)
* [Digital Archives Workstation Update: KryoFlux, FRED, and BitCurator Walk into a Bar…](https://blogs.princeton.edu/techsvs/2017/10/03/digital-archives-workstation-update-kryoflux-fred-and-bitcurator-walk-into-a-bar/)
* [The Archivist’s Guide to KryoFlux](https://github.com/archivistsguidetokryoflux/archivists-guide-to-kryoflux)
* [KryoFlux floppy case](https://www.thingiverse.com/thing:3089895)
* [Accessing Mac Formatted Floppy Disks without a Kryoflux](https://porterolsen.wordpress.com/2016/06/15/accessing-mac-formatted-floppy-disks-without-the-kryoflux/)
* [NYPL’s New Digital Archives Lab](https://www.nypl.org/blog/2017/01/11/nypls-new-digital-archives-lab)
* [Michigan University Digital Preservation Lab 2.0](https://www.lib.umich.edu/blogs/bits-and-pieces/digital-preservation-lab-20)
* [Building Audio, Video, And Data-Rescue Kits](https://radd.dsalo.info/wp-content/uploads/2017/10/BuildDocumentation.pdf)
* [Getting Data Out Of Its Floppy Cage](http://www.wcsarchivesblog.org/getting-data-out-of-its-floppy-cage/) - provides some details on how to get the FC5025 floppy controller working with BitCurator
* [Use Guide for the FC5025 Floppy Disk Controller](https://web.archive.org/web/20180507194729/https://mith.umd.edu/vintage-computers/fc5025-operation-instructions)
* [Bodging a case for a 5.25″ floppy drive](https://radd.dsalo.info/2017/01/bodging-a-case-for-a-5-25-floppy-drive/)
* [Digital Archaeology and/or Forensics: Working with Floppy Disks from the 1980s](https://journal.code4lib.org/articles/11986)
* [PCI card types](https://upload.wikimedia.org/wikipedia/commons/1/15/PCI_Keying.svg)
* [Adaptec SCSI controller specifications](https://storage.microsemi.com/en-us/support/scsi/)
* [Startech PCI Express to PCI Adapter Card](https://www.startech.com/nl/en/Cards-Adapters/Slot-Extension/PCI-Express-to-PCI-Adapter-Card~PEX1PCI1)
* [Sintech PCI-E Express X1 to Dual PCI Riser Extender Card](https://www.amazon.com/gp/product/B00KZHDSLQ?psc=1&redirect=true&ref_=oh_aui_detailpage_o07_s00)
* [Server-side Preservation of Dynamic Websites](http://publications.beeldengeluid.nl/pub/633/)
* [Disk Image Formats](https://wiki.harvard.edu/confluence/display/digitalpreservation/Disk+Image+Formats)
* [Automated Processing of Disk Images and Directories in BitCurator (Tim Walsh)](https://www.bitarchivist.net/blog/2017-05-01-buf2017/)