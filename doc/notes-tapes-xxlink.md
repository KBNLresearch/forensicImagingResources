# Notes on xxLINK tape contents 

## DLT-IV tapes

File type (Unix File):

    /media/bcadmin/Elements/Echt/tapes-DLT/29-dec-1998/file000001.dd: new-fs dump file (big endian), Previous dump Sun Apr 11 18:00:56 1999, This dump Thu Jan  1 00:00:00 1970, Volume 1, Level zero, type: tape header, Label none, Filesystem /, Device hourly.0, Host netapp0, Flags 1

Created with Linux *dump* command:

<https://linux.die.net/man/8/dump>

Use *restore* command to restore the contents of a dump file:

<https://linux.die.net/man/8/restore>


First install *restore* using:

    sudo apt install dump

Go to empty directory, then start interactive session:

    restore -if /media/bcadmin/Elements/Echt/tapes-DLT/29-dec-1998/file000001.dd

List file system:

    restore > ls

Result:

    .:
    apache.intel/  home/          msql/          perl.intel/    www/
    backup/        logs/          mysql/         perlnew.intel/ xxlink/
    bin/           mail/          nedstat/       tmp/
    etc/           messages/      perl/          tripwire/

### Block size

Block size of first tape: 64512 bytes. The *dump(8)* documentation says:

>-b blocksize
>    The number of kilobytes per dump record. The default blocksize is 10, unless the -d option has been used to specify a tape >density of 6250BPI or more, in which case the default blocksize is 32. Th maximal value is 1024. Note however that, since the IO >system slices all requests into chunks of MAXBSIZE (which can be as low as 64kB), you can experience problems with dump(8) and >restore(8) when using a higher value, depending on your kernel and/or libC versions.

So in this case a value of 63 was apparently used.

## DDS tapes

Imaging the DDS tapes shows there are the following data layouts.

### Extraction results in 3 files

Example: tape 1 ("www 20 dec '95"):

    -rwxrwxrwx 1 johan johan   12058624 Jan 22 12:40 file000001.dd
    -rwxrwxrwx 1 johan johan  208535552 Jan 22 12:44 file000002.dd
    -rwxrwxrwx 1 johan johan 1169752064 Jan 22 13:03 file000003.dd

So what are these files?

    file file000001.dd

Result:

    file000001.dd: new-fs dump file (big endian),  Previous dump Wed Dec 20 13:07:49 1995, This dump Thu Jan  1 00:00:00 1970, Volume 1, Level zero, type: tape header, Label none, Filesystem /, Device /dev/sd0a, Host www.xxlink.nl, Flags 1

And:

    file file000002.dd

Result:

    file000002.dd: new-fs dump file (big endian),  Previous dump Wed Dec 20 13:08:19 1995, This dump Thu Jan  1 00:00:00 1970, Volume 1, Level zero, type: tape header, Label none, Filesystem /usr, Device /dev/sd0g, Host www.xxlink.nl, Flags 1

And:

    file file000003.dd

Result:

    file000003.dd: new-fs dump file (big endian),  Previous dump Wed Dec 20 13:14:01 1995, This dump Thu Jan  1 00:00:00 1970, Volume 1, Level zero, type: tape header, Label none, Filesystem /home, Device /dev/sd0h, Host www.xxlink.nl, Flags 1

So it seems these are dumps from 3 different partitions `/dev/sd0a`, `/dev/sd0g` and `/dev/sd0a`, which were mounted under `/`, `/usr` and `/home`, respectively.

### Extraction results in 1 file

Example: tape 2 ("xxx 23 dec '95"):

    -rwxrwxrwx 1 johan johan 1463429120 Jan 22 13:32 file000001.dd

What is this file?

    file file000001.dd

Result:

    file000001.dd: tar archive

So this is a simple TAR archive.

Example: tape 8 ("Metal 11 nov '95 (TAR file hele machine)"):

    -rwxrwxrwx 1 johan johan 755200000 Jan 22 16:48 file000001.dd

What is this file?

    file file000001.dd

Result:

    file000001.dd: POSIX tar archive (GNU)

Also a TAR archive.

## Resources

- [dump(8)](https://linux.die.net/man/8/dump)

- [restore(8)](https://linux.die.net/man/8/restore)

- [restore Linux Commands](https://www.hscripts.com/tutorials/linux-commands/restore.html)