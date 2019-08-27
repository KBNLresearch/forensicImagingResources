# Floppy notes

Floppy drive: TEAC FD−55GFR−149U. This is one of the recommended drives to use with the FC5025 controller. Looks like jumper settings are OK out of the box.

## Compiling the drivers

First install libusb using:

    sudo apt-get install libusb-dev

Then compile the driver. Don't bother with compiling the GUI, as it needs an ancient version of GTK.


## Finding the device

Type:

    lsusb

Result:

    Bus 002 Device 002: ID 8087:8000 Intel Corp. 
    Bus 002 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 001 Device 002: ID 8087:8008 Intel Corp. 
    Bus 001 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub
    Bus 004 Device 003: ID 1058:25a3 Western Digital Technologies, Inc. 
    Bus 004 Device 001: ID 1d6b:0003 Linux Foundation 3.0 root hub
    Bus 003 Device 004: ID 04f2:b3ed Chicony Electronics Co., Ltd 
    Bus 003 Device 003: ID 046d:c31c Logitech, Inc. Keyboard K120
    Bus 003 Device 006: ID 16c0:06d6 Van Ooijen Technische Informatica 
    Bus 003 Device 002: ID 03f0:134a Hewlett-Packard Optical Mouse
    Bus 003 Device 005: ID 8087:07dc Intel Corp. 
    Bus 003 Device 001: ID 1d6b:0002 Linux Foundation 2.0 root hub

Looks like this one is the floppy drive 9disappears after unplugging the drive's USB cable):

    Bus 003 Device 006: ID 16c0:06d6 Van Ooijen Technische Informatica

## More fc5025 resources

<https://josephcarrano.files.wordpress.com/2018/06/fred_guide1.pdf>
