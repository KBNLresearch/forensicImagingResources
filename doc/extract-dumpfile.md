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

**CAUTION**: by default *restore* extracts the contents of a *dump* file to the system's root directory, i.e. it tries to recover a full backup. In nearly all modern-day cases this behaviour is unwanted, and it could even wreak havoc on your machine's file system.  Extraction to a user-defined directory is only possible by running *restore* in "interactive" mode, which is described below (on a side node, this severely limits the possibilities for automating the recovery procedure).

<hr>

1. Create an empty directory and go to that directory in the command terminal. Then run `restore` as sudo in interactive mode on the dump file you want to extract[^1]:

        sudo restore -if ../../tapes-DDS/1/file000002.dd

2. Inspect the contents of the dump file:

        restore > ls
    
    Result:

        5bin/        diag/        kvm/         mdec         share/       ucbinclude 
        5include/    dict/        lddrv/       net          spool        ucblib 
        5lib/        etc/         lib/         nserve       src          xpg2bin/
        adm          export/      local        old/         stand        xpg2include/
        bin/         games/       local-/      openwin/     sys          xpg2lib/
        boot         hosts/       lost+found/  pub          tmp 
        demo/        include/     man          sccs/        ucb/

3. Use the `add`command to add directories that are to be extracted to the directory list. To extract everything: 

        restore > add .

4. Run the `extract` command:

        restore > extract
    
    This results in the following prompt:

        You have not read any volumes yet.
        Unless you know which volume your file(s) are on you should start
        with the last volume and work towards the first.
        Specify next volume # (none if no more volumes):
    
5.  Now enter `1`. Response:

        set owner/mode for '.'? [yn]

6. Enter `n` [^2]

7. When the extraction is finished, exit the interactive restore session:

        restore > q

If the extraction results in errors like:

    restore: ./Answerbook/SS2INSTALL/Conformit�_aux__Normes_de_S�curit�: cannot create file: Invalid or incomplete multibyte or wide character

This typically happens when extracting to *NTFS*-formatted disks. Extracting to an *Ext4* formatted disk should get rid of this problem.

## Resources

- How to Restore UFS Files Interactively (Oracle): <https://docs.oracle.com/cd/E19253-01/817-5093/bkuprestoretasks-63510/index.html>

[^1]: If you don't run `restore` as sudo, extraction results in a flood of `chown: Operation not permitted` messages (the files *are* extracted though).

[^2]: Needs further investigation, implications of this setting and what it does are not 100% clear to me.