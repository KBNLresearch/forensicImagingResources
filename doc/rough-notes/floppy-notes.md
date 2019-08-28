# Floppy notes

Floppy drive: TEAC FD−55GFR−149U. This is one of the recommended drives to use with the FC5025 controller. Looks like jumper settings are OK out of the box.

## Compiling the drivers

First install libusb using:

    sudo apt-get install libusb-dev

<!--Then install libgtk:

    sudo apt-get install libgtk-3-dev -->

Then compile the driver. Don't bother with compiling the GUI, as it needs an ancient version of GTK.

## Installation of drivers

Copy the binaries (fcbrowse, fcformats, fcdrives and fcimage) to one of the *bin* directories. In my case I used the private *.local/bin directory in my home directory. Add this this directory to the PATH variable if necessary by adding below lines to the .profile file in the home directory:

    # set PATH so it includes user's private ~/.local/bin if it exists
    if [ -d "$HOME/.local/bin" ] ; then
        PATH="$HOME/.local/bin:$PATH"
    fi

Then activate the new settings by running: 

    source ~/.profile

<!--

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

Looks like this one is the floppy drive (disappears after unplugging the drive's USB cable):

    Bus 003 Device 006: ID 16c0:06d6 Van Ooijen Technische Informatica

Cross-check with 025_fc5025.rules file from CD-ROM, which contains this line:

    SYSFS{idVendor}=="16c0", SYSFS{idProduct}=="06d6", MODE="664",

Vendor and product ids match the lsusb entry.
-->

## Using the tools

Browsing the contents of an MS-DOS formatted 1200k floppy:

    fcbrowse -f msdos12

BUT this gives the following result:

    fcbrowse: No devices found.

Same for other format values. Under Windows the device is properly recognized, so there appears to be a problem with the compiled binaries. The most likely cause is that the docs state that the tools need version 0.1.12 of libusb, which is ancient (and AFAIK it cannot be installed on a modern Linux system without conflicts).

**UPDATE**:

See also:

<https://groups.google.com/forum/#!topic/bitcurator-users/K1BPIbdKoOY/discussion>

Detailed instructions on how to compile the software here;

<https://dallibraries.atlassian.net/wiki/spaces/DFL/pages/568918043/Install+FC5025+Disk+Image+and+Browse+software+in+BitCurator+environment>


## More fc5025 resources

<https://josephcarrano.files.wordpress.com/2018/06/fred_guide1.pdf>
