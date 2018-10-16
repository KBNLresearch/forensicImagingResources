# 3.5" floppy disk

## Introduction

[3.5" floppy disk](https://en.wikipedia.org/wiki/Floppy_disk#%E2%80%8B3_1%E2%81%842-inch_floppy_disk) .

## Hardware

### Floppy disk drive

|**Model**|[BaseTech USB Floppy Disk Drive refurbished](https://web.archive.org/web/20181008141513/http://www.produktinfo.conrad.com/datenblaetter/1100000-1199999/001170561-an-01-ml-BASETECH_FLOPPY_LAUFWERK_USB_de_en_fr_nl.pdf)|
|:--|:--|
|**Connection**|USB 2.0/1.1|
|**Type of floppy disk**|High Density (2HD) 1.44 MByte,Normal Density (2DD), 720 kByte|

### Write blocker

|**Model**|[Tableau Forensic USB 3.0 Bridge](https://www.guidancesoftware.com/tableau/hardware/t8u)|
|:--|:--|
|**Connectors: Host (Left) Side**|USB 3.0 Standard-B connector|
|**Connectors: Device (Right) Side**|USB 3.0 Standard-A connector|

## Connecting the write blocker

1. Hook up the write blocker to the workstation using the blue USB cable (use the left-hand port on the write blocker).

2. Connect the write blocker' s power supply to the DC In (at top) and make sure the power cord is plugged into to a power socket.

## Procedure for creating a disk image

### Guymager

1. Connect the floppy disk to the right-hand USB connector on the write blocker.

2. Make sure the floppy's square write-protection tab is enabled (the hole in the corner of the disk must be uncovered).

3. Insert the floppy into the floppy disk drive.

4. Start Guymager. Result:

    ![](./img/floppy-35-guymager1.png)

5. Select the floppy device from the list (in particular , look at the *Size* field), right-click on it and select *Acquire image*

7. In the *Acquire image* dialog, make the following settings:

    - Set *File format* to *Linux dd raw*.
    - Uncheck the *Split image files* checkbox.
    - Select the destination directory for the disk image, and enter a file name (without extension).
    - Check *Calculate SHA-256* (and uncheck the *MD5* and *SHA-1* options).
    - Check *Verify image after acquisition*.

    ![](./img/floppy-35-guymager2.png)

8. Press the *Start* button and watch the progress indicator.

9. If all went well, the *State* field will read *Finished - Verified & ok*.

    ![](./img/floppy-35-guymager3.png)

9. Remove the floppy from the floppy disk drive.

The above steps result in two files:

- A file with extension *.dd*, which is the actual disk image.
- A file with extension *.info*, which contains information about the imaging process.


## Remarks

1. If we first eject the floppy device from the file manager, any newly inserted floppies are not mounted (switching the write blocker off and on fixes this)

2. Using a write blocker may be overkill if we also use the write protection tabs on the floppies? (Then again, better safe than sorry.)