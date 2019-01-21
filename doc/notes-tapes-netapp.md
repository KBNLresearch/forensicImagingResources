# Notes NetApp DLT-IV tapes

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

## Block size

Block size of first tape: 64512 bytes. The *dump(8)* documentation says:

>-b blocksize
>    The number of kilobytes per dump record. The default blocksize is 10, unless the -d option has been used to specify a tape >density of 6250BPI or more, in which case the default blocksize is 32. Th maximal value is 1024. Note however that, since the IO >system slices all requests into chunks of MAXBSIZE (which can be as low as 64kB), you can experience problems with dump(8) and >restore(8) when using a higher value, depending on your kernel and/or libC versions.

So in this case a value of 63 was apparently used.

## Resources

- [dump(8)](https://linux.die.net/man/8/dump)

- [restore(8)](https://linux.die.net/man/8/restore)

- [restore Linux Commands](https://www.hscripts.com/tutorials/linux-commands/restore.html)