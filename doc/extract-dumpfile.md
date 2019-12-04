# Extract contents of Unix dump file

## Introduction

[Unix dump](http://fileformats.archiveteam.org/wiki/Unix_dump) was a backup utility that was widely used in the '90s. This document describes how to extract the contents of a *dump* file to an empty directory.

## Software

[**Restore**](https://linux.die.net/man/8/restore), which is part of *dump* package. It can be installed using:

    sudo apt install dump

## Hardware

It is strongly recommended to extract *dump* files to an [*Ext4*](\https://en.wikipedia.org/wiki/Ext4)-formatted disk. Extracting to an [*NTFS*](https://en.wikipedia.org/wiki/NTFS) file system (which is the default used by most commercially sold USB disks) is likely to result in errors, as the names of directories and files inside a *dump* file may contain characters that are not compatible with *NTFS*, and as a result these files are not extracted! 

## Procedure for extracting a dump file

<hr>

**CAUTION**: by default *restore* extracts the contents of a *dump* file to the system's root directory, i.e. it tries to recover a full backup. In nearly all modern-day cases this behaviour is unwanted, and it could even wreak havoc on your machine's file system.  Extraction to a user-defined directory is possible, but it does require some user interaction (which limits the possibilities for automating the recovery procedure).

<hr>

1. Create an empty directory, and then go to that directory in the command terminal, e.g.:

        mkdir file000002

        cd file000002

2. Run `restore` as sudo with the following command-line arguments[^1]:

        sudo restore -xvf ../../tapes-DDS/1/file000002.dd .

    Here, `../../tapes-DDS/1/file000002.dd` points to the dump file. Note that the final `.` argument defines the files *inside* the dump file that are to be extracted (here: all of them), it does *not* define an output path!

3. After a while the following prompt appears:

        You have not read any volumes yet.
        Unless you know which volume your file(s) are on you should start
        with the last volume and work towards the first.
        Specify next volume # (none if no more volumes):

    Now enter `1`. This will start the extraction process.

4.  After a while another prompt appears:

        set owner/mode for '.'? [yn]

    Now enter `n` [^2] and wait for `restore` to finish.

5. Move one directory level up:

        cd ..

6. Finally set the permissions on the extracted files and directories using the following two commands (replacing `file000002` with the name of your extraction directory):

        sudo find ./file000002 -type f -exec chmod 644 {} \;

        sudo find ./file000002 -type d -exec chmod 755 {} \;

Done!

## Troubleshooting

In some cases you may get errors like this during extraction:

    restore: ./Answerbook/SS2INSTALL/Conformit�_aux__Normes_de_S�curit�: cannot create file: Invalid or incomplete multibyte or wide character

This typically happens when extracting to *NTFS*-formatted disks. Extracting to an *Ext4* formatted disk should get rid of this problem.

## Resources

- How to Restore Specific UFS Files Noninteractively (Oracle): <https://docs.oracle.com/cd/E19253-01/817-5093/bkuprestoretasks-72504/index.html>

- How to Restore UFS Files Interactively (Oracle): <https://docs.oracle.com/cd/E19253-01/817-5093/bkuprestoretasks-63510/index.html>


[^1]: If you don't run `restore` as sudo, extraction results in a flood of `chown: Operation not permitted` messages (the files *are* extracted though).

[^2]: Needs further investigation, implications of this setting and what it does are not 100% clear to me.