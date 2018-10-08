# 3.5" floppy disk

## Introduction

[Digital Data Storage (DDS)](https://en.wikipedia.org/wiki/Floppy_disk#%E2%80%8B3_1%E2%81%842-inch_floppy_disk) is a family of tape formats that are based on [digital audio tape](https://en.wikipedia.org/wiki/Digital_audio_tape) (DAT).

## Floppy reader

|||
|:--|:--|
|**Model**|[BaseTech USB Floppy Disk Drive refurbished](https://web.archive.org/web/20181008141513/http://www.produktinfo.conrad.com/datenblaetter/1100000-1199999/001170561-an-01-ml-BASETECH_FLOPPY_LAUFWERK_USB_de_en_fr_nl.pdf)|
|**Connection**|USB 2.0/1.1|
|**Type of floppy disk**|High Density (2HD) 1.44 MByte,Normal Density (2DD), 720 kByte|

## Procedure for reading a tape

### Guymager

1. Start Guymager. Result:

    ![](./img/floppy-35-guymager1.png)

2. Insert floppy into reader.

3. Press *rescan* button in Guymager (top). Result:

  ![](./img/floppy-35-guymager2.png)

4. Click on entry for floppy device in Guymager. Result:

  ![](floppy-35-guymager3.png)

5. Right-click and select *Acquire image*:

  ![](floppy-35-guymager4.png)

6. In the *Acquire image* dialog, make the following settings:

    - File format: Linux dd raw
    - Uncheck *Split image files* checkbox
    - Select the destination directory for the disk image, and enter a file name (without extension)
    - Check *Calculate SHA-256* (and uncheck the MD5 and SHA-1 options)
    - Check *Verify image after acquisition*.

    ![](floppy-35-guymager5.png)

7. Press the *Start* button and watch the progress indicator.

8. If all went well, the *State* field will read *Finished - Verified & ok*.

  ![](floppy-35-guymager5.png)

The above steps result in two files:

    - a file with extension *.dd*, which is the actual disk image
    - a file with extension *.info*, which contains information about the imaging process.