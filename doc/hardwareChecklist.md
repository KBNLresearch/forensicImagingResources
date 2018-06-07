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
|Various cables and adapters||Useful resources are [The Cable Bible](https://amiaopensource.github.io/cable-bible/) and the [SCSI Connector Guide](https://www.cablestogo.com/learning/connector-guides/scsi)|
|Power strips; spare power cables|-||
|Cans of compressed air for blowing away dust|||
|Utility kit with screwdrivers|||
|Camera (for documentation)|-||

This checklist is partially based on [DIY Handboek voor Webarcheologie](https://hart.amsterdam/image/2017/11/17/20171116_freeze_diy_handboek.pdf) by Tjarda de Haan, Robert Jansma and Paul Vogel.

## Tape readers

We currently have the following tape readers:

### DDS

[HP SureStore DAT8](http://www.hp.com/ecomcat/hpcatalog/specs/S4112B.htm) DDS drive. 

**Interface**: Single-ended, narrow SCSI-2.

**Connector**: drive has a 50-contact female connector which looks an awful lot like a 50-contact, centronics-type connector ("SCSI-1 Connector" AKA "Alternative 2, A-cable connector"). See also the topmost connector [here](http://www.paralan.com/sediff.html). This is somewhat strange, since the specs explicitly state the drive has a SCSI-2 interface. 

Alternatively it *might* be a 50-pin high-density SCSI connector ("SCSI-2 Connector" AKA "Alt 1, A-cable connector"); 3rd from top [here](http://www.paralan.com/sediff.html). But the distance between the two contact rows in the illustration appears to be smaller than on the actual drive. 

**Cable**: attached to the device is a [Single Ended HD68 TO LD50 SCSI Cable](http://www.itinstock.com/hp-c5665-61001-single-ended-hd68-to-ld50-scsi-cable-1-meter-40938-p.asp). The connector that goes into the PCI card is a 68-pin DB68 (MD68) connector (also known as High-Density or HD 68 and Half-Pitch or HP68).

Note that the 50-pin connector is listed as "LD50". A search on "LD50" and "SCSI" turned up [this](http://carlsralp.www3.50megs.com/computer/connectr/scsiconn.html#ld) link, which says:

> LD50 is SCSI-1 standard and is still used for many narrow (formerly called 8bit SCSI) devices.
> Consider using the HD50 for new designs. HD50 is SCSI-2 standard, fully compatible with LD50, support higher frequency such as UltraSCSI and is smaller. 

This suggests the connector on the device is most likely indeed a centronics-type "SCSI-1" connector.

### DLT-IV

[IBM 7205 440](https://www.cnet.com/products/ibm-7205-440-tape-drive-dlt-scsi/specs/) DLT drive.

- **SCSI Signaling Type**: Low Voltage Differential (LVD)
- **Interface**: Fast Wide SCSI
- **Connector Type**: 68 pin HD D-Sub (HD-68)

At the back of the machine is a 68-contact female connector, which visually matches the "68-pin high-density SCSI connector" ("SCSI-3 Connector" AKA "Alt 3, P-cable connector"); 5th from top [here](http://www.paralan.com/sediff.html). This is consistent with the specification.

**Cable**: connector at the outgoing side VHDCI SCSI connector (bottommost [here](http://www.paralan.com/sediff.html)). Looking up the product code on the cable (19P0279) also returns several hits that describe it as a "VHDCI to 68pin cable" ([example](http://www.vibrant.com/IBM-19p0279.html)).

## Connecting to modern machines

See:

[Best way to read SCSI tape drive on a modern PC?](http://qanda.digipres.org/1160/best-way-to-read-scsi-tape-drive-on-a-modern-pc)

Also, the situation with difference SCSI types, interfaces and connectors is quite complex, and apparently interface mismatches [can result in damage to the hardware](https://twitter.com/charles_forsyth/status/1004356758893154305). So we have to be careful here, and may need multiple SCSI cards. This needs further investigation.

## Resources

* [What kind of SCSI do I have? Single-ended or differential SCSI interface?](http://www.paralan.com/sediff.html)
* [LVD, SE, HVD, SCSI Compatibility - Or Not](http://www.paralan.com/scsiexpert.html)
* [SCSI articles on Paralan](http://www.paralan.com/aboutscsi.html)
* [SCSI Connector Guide](https://www.cablestogo.com/learning/connector-guides/scsi)
* [The Cable Bible](https://amiaopensource.github.io/cable-bible/)
* [DIY Handboek voor Webarcheologie](https://hart.amsterdam/image/2017/11/17/20171116_freeze_diy_handboek.pdf)