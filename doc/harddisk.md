# Hard disk drive (internal)

## Introduction

[Hard disk drive](https://en.wikipedia.org/wiki/Hard_disk_drive).

## Hardware

### Write blocker

|**Model**|[Tableau Forensic SATA/IDE Bridge](https://www.guidancesoftware.com/tableau/hardware/t35u)|
|:--|:--|
|**Connectors: Host (Left) Side**|USB 3.0 Standard-B connector|
|**Connectors: Device (Right) Side**|SATA signal connector, IDE signal connector, 4-pin 3M drive power connector (power to SATA or IDE hard disk)|
|**SATA Device Compatibility**|SATA 1 or SATA 2 hard disk devices|
|**IDE Device Compatibility**|Parallel ATA hard disk devices with Logical Block Addressing (LBA) support|

## Connecting the write blocker

1. Hook up the write blocker to the workstation using the blue USB cable (use the left-hand port on the write blocker).

2. Connect the write blocker' s power supply to the DC In (top left) and make sure the power cord is plugged into to a power socket.

## Procedure for creating a disk image

### Guymager

1. Connect the hard disk drive to one of the connectors at the right-hand side of the write blocker using the appropriate (SATA/IDE) cables. Note that for a SATA drive you need to connect two cables: one data cable and a power cable! See the image below:

    ![](./img/sata-wb.jpg)

2. Press the power button on the write blocker.

3. Start Guymager. Result:

    ![](./img/hdd-guymager1.png)

4. Right-click on the entry for the flash drive, and select *Acquire image*.

5. In the *Acquire image* dialog, make the following settings:

    - Set *File format* to *Linux dd raw*.
    - Uncheck the *Split image files* checkbox.
    - Select the destination directory for the disk image, and enter a file name (without extension).
    - Check *Calculate SHA-256* (and uncheck the *MD5* and *SHA-1* options).
    - Check *Verify image after acquisition*.

    ![](./img/hdd-guymager2.png)

6. Press the *Start* button and watch the progress indicator.

7. If all went well, the *State* field will read *Finished - Verified & ok*.

    ![](./img/hdd-guymager3.png)

The above steps result in two files:

- A file with extension *.dd*, which is the actual disk image.
- A file with extension *.info*, which contains information about the imaging process.

<!-- TODO: verify unmount procedure, not tested! -->

8. Open a file manager window, right-click on the hdd drive icon, and select *Unmount*.

    ![](./img/hdd-unmount.png)

9. You can now safely remove the hard disk drive from the write blocker.


<!-- 

## Exporting files from disk image

TODO: in test of below procedure with 320GB dd imag, generating the directory tree takes forever, perhaps better to export directly using tsk_recover or indirectly using the tools by Tim Walsh. For the moment description is based on manual analysis.

1. Launch the *BitCurator Disk Image Access* application (located in the *Forensics and Reporting* folder on the desktop)

    ![](./img/bc-disk-image-access1.png)

2. Click on the *Open disk image* button (top-left) and select the disk image that we just created. The application now starts to generate a DFXML file, and a directory tree. For large disk images this will take a while.

-->

## Get information about the disk image

From the terminal, type:

    disktype testsata.dd

Result:

    --- testsata.dd
    Regular file, size 298.1 GiB (320072933376 bytes)
    DOS/MBR partition map
    Partition 1: 350 MiB (367001600 bytes, 716800 sectors from 2048, bootable)
    Type 0x07 (HPFS/NTFS)
    NTFS file system
        Volume size 350.0 MiB (367001088 bytes, 716799 sectors)
    Partition 2: 297.7 GiB (319703482368 bytes, 624420864 sectors from 718848)
    Type 0x07 (HPFS/NTFS)
    NTFS file system
        Volume size 297.7 GiB (319703481856 bytes, 624420863 sectors)

So in this case our disk image contains 2 partitions:

- A 350 MiB boot partition
- A 298 GiB partition

The second partition starts at sector 718848 (byte offset 512*718848 = 368050176).

## Export files from disk image

To export the second partition:

    tsk_recover -a -o 718848 ./image/testsata.dd ./fsOut