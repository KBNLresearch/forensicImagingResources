# Notes on xxLINK tape contents 

## DLT-IV tapes

File type (Unix File):

    /media/bcadmin/Elements/Echt/tapes-DLT/29-dec-1998/file000001.dd: new-fs dump file (big endian), Previous dump Sun Apr 11 18:00:56 1999, This dump Thu Jan  1 00:00:00 1970, Volume 1, Level zero, type: tape header, Label none, Filesystem /, Device hourly.0, Host netapp0, Flags 1

Created with Linux *dump* command:

<https://linux.die.net/man/8/dump>

### Block size

Block size of first and second tapes: 64512 bytes. The *dump(8)* documentation says:

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

### Restoring a tar file to empty directory

    sudo tar -xvf /path/to/file0001.dd > /dev/null

Extracts contents to working directory. Verbose output, stdout to /dev/null to suppress messages for individual files (only errors are shown).

### Restoring a dump file to empty directory

Use *restore* command to restore the contents of a dump file:

<https://linux.die.net/man/8/restore>

First install *restore* using:

    sudo apt install dump

1. Create empty directory and go to that directory in the command terminal. Then run `restore` in interactive mode on the dump file you want to extract[^1]:

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

## Notes on extraction of individual archive files

While extracting dump file `images/tapes-DDS/6/file000003.dd`, restore reported the following messages;

    restore: ./Answerbook/SS2INSTALL/Conformit�_aux__Normes_de_S�curit�: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./Answerbook/IPCINSTALL/Conformit�_aux_Normes_de_S�curit�: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./Answerbook/IPCINSTALL/Sicherheitsbeh�rdliche_Vorschriften: cannot create file: Invalid or incomplete multibyte or wide character

Affected directories contain software documentation, and no data that are of interest to the web archaeology project, so no problem. Same problem with `images/tapes-DDS/13/file000003.dd`, `images/tapes-DDS/15/file000003.dd`.

**UPDATE**: extracting again to an Ext4-formatted disk fixes this issue. However in this case it is necessary to update the file permissions on the extractions files/directories.  

While extracting `./images/tapes-DDS/8/file000001.dd`: 

    tar: Exiting with failure status due to previous errors

Extracted 727 MB of data; size of TAR file is 755,2 MB (755200000 bytes)

More info on this error: <http://ask.xmodulo.com/tar-exiting-with-failure-status-due-to-previous-errors.html>

Re-running with stdout redirected to dev/null reveals numerous message such as:

    tar: dev/ttypu: Cannot mknod: Operation not permitted
    tar: dev/ptypu: Cannot mknod: Operation not permitted
    tar: dev/ttypv: Cannot mknod: Operation not permitted
    tar: dev/ptypv: Cannot mknod: Operation not permitted

Explained here: <https://stackoverflow.com/questions/7418303/untar-a-unix-based-operating-system>

These file are of no interest to us, so just left it like that (running tar as root might get rid of these errors).

**UPDATE**: extracting again as root to an Ext4-formatted disk + updating permissions afterwards fixes this issue.

While extracting `images/tapes-DDS/17/file000002.dd` (TAR archive): extraction results in numerous errors like:

    tar: ./xxlink/xxlinfo/Universiteit/Enqu\210teICTbedrijvigheid.doc: Cannot open: Invalid or incomplete multibyte or wide character
    tar: ./xxlink/xxlinfo/Lam\202: Cannot mkdir: Invalid or incomplete multibyte or wide character
    tar: ./xxlink/xxlinfo/Lam\202/offertelame.doc: Cannot open: Invalid or incomplete multibyte or wide character

Most likely cause: external drive to which data are extracted has some Microsoft (probably NTFS) file system. See also:

<https://www.linuxquestions.org/questions/linux-general-1/tar-fails-to-extract-archive-containing-special-characters-884672/>

Perhaps try again on ext3 or ext4 formatted disk (BUT these cannot be read on Windows).

**UPDATE**: extracting again as root to an Ext4-formatted disk + updating permissions afterwards fixes this issue.

Also interesting:

    tar: ./xxlink/vormgeving/Fonts/Oktober/GROENING.TTF: time stamp 2032-02-10 17:55:18 is 399096030.712148596 s in the future
    tar: ./xxlink/vormgeving/Fonts/Wabbit/GROENING.TTF: time stamp 2032-02-10 17:55:18 is 399096030.470655055 s in the future

While extracting `images/tapes-DDS/18/file000002.dd` (TAR archive): again `Cannot open: Invalid or incomplete multibyte or wide character` errors.

**UPDATE**: extracting again as root to an Ext4-formatted disk + updating permissions afterwards fixes this issue.

While extracting `images/tapes-DLT/1/file000001.dd` (dump archive) this happens:

    restore > add .
    restore: ./www/samsom/root/adverteren/logo�s: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/logo�s: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/_old_sams/adverteren/logo�s: Invalid or incomplete multibyte or wide character
    restore > extract
    You have not read any volumes yet.
    Unless you know which volume your file(s) are on you should start
    with the last volume and work towards the first.
    Specify next volume # (none if no more volumes): 1
    restore: ./www/wwwendy/dev/tcp: lsetflags called on a special file: Invalid argument
    restore: ./www/wwwendy/dev/zero: lsetflags called on a special file: Operation not supported
    restore: ./www/gitc/dev/tcp: lsetflags called on a special file: Invalid argument
    restore: ./www/gitc/dev/zero: lsetflags called on a special file: Operation not supported
    restore: ./www/fortis/nl/virtualvsb/dev/tcp: lsetflags called on a special file: Invalid argument
    restore: ./www/fortis/nl/virtualvsb/dev/zero: lsetflags called on a special file: Operation not supported
    restore: ./www/oltronix/dev/tcp: lsetflags called on a special file: Invalid argument

So again there are characters that cannot be restored (at least not on the used NTFS-formatted disk). The `lsetflags called on a special file` is repeated for numerous `/dev/tcp` and `/dev/zero` files. Meaning not clear (google search returns exactly 1 hit which is not very helpful). More info on these devices here:

<https://www.tldp.org/LDP/abs/html/devref1.html>

And also:

<https://unix.stackexchange.com/questions/494389/which-unix-like-system-really-provides-the-dev-tcp-special-file>


Also, for same archive (again!):

    restore: ./www/samsom/root/_old_sams/adverteren/logo�s/Veiligheid.jpg: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/_old_sams/adverteren/logo�s/Vervoerswetenschap.jpg: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/_old_sams/adverteren/logo�s/Assurantie magazine.gif: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/_old_sams/adverteren/logo�s/arbo-&-milieu.gif: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/_old_sams/adverteren/logo�s/Bedrijfsopleidingen.gif: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/_old_sams/adverteren/logo�s/Facto.gif: cannot create file: Invalid or incomplete multibyte or wide character
    restore: ./www/samsom/root/_old_sams/adverteren/logo�s/Management Support.gif: cannot create file: Invalid or incomplete multibyte or wide character

This *does* affect data that are part of a website (although from the name it is old/outdated).

Similar for ``images/tapes-DLT/2/file000001.dd` (dump archive):

    restore > add .
    restore: ./www/samsom/root/sams/adverteren/logo�s: Invalid or incomplete multibyte or wide character
    restore: ./www/hemmel/root/priv�: Invalid or incomplete multibyte or wide character

Which also results in thing like this:

    restore: ./www/hospitorg/root/b/�noindex: cannot create file: Invalid or incomplete multibyte or wide character

So might be better to extract everything to ext4-formatted disk instead.

**UPDATE**: extracting again as root to an Ext4-formatted disk + updating permissions afterwards fixes the encoding issues (but not the `lsetflags` issue!).


While extracting `images/tapes-DLT/4/file000001.dd`: after finishing extracting 1st volume, restore asks `Specify next volume`. Tried 2, doesn't work, so entered none. After this it displays a huge list of errors like this one:

    ./www/nrc/www/root/W2/Lab/Profiel/Anno-00/dood.html: (inode 2196155) not found on tape
    ./www/nrc/www/root/W2/Lab/Profiel/Anno-00/geloof.html: (inode 2196156) not found on tape
    ./www/nrc/www/root/W2/Lab/Profiel/Anno-00/gemengdhuwelijk190.gif: (inode 2196157) not found on tape
    ./www/nrc/www/root/W2/Lab/Profiel/Anno-00/gezinsleven.html: (inode 2196158) not found on tape
    ./www/nrc/www/root/W2/Lab/Profiel/Anno-00/inhoud.html: (inode 2196159) not found on tape
    ./www/nrc/www/root/W2/Lab/Profiel/Elfsteden/elfsteden.gif: (inode 2196160) not found on tape
    ./www/nrc/www/root/W2/Lab/Profiel/Elfsteden/inhoud.html: (inode 2196161) not found on tape
    ./www/nrc/www/root/W2/Nieuws/1998/12/30/Vp/kort.html: (inode 2196162) not found on tape
    ./www/nrc/www/root/W2/Nieuws/1998/12/30/Vp/01.html: (inode 2196163) not found on tape
    ./www/nrc/www/shadow/W2/Nieuws/1998/07/10/Spo/01.html: (inode 2196164) not found on tape
    ./www/nrc/www/shadow/W2/Nieuws/1997/01/13/Med/01.html: (inode 2196192) not found on tape
    ./www/nrc/www/shadow/W2/Nieuws/1997/01/13/Med/02.html: (inode 2196193) not found on tape
    ./www/nrc/www/shadow/W2/Nieuws/1997/01/13/Med/03.html: (inode 2196194) not found on tape
    ./www/nrc/www/shadow/W2/Nieuws/1999/05/03/Rtv/01.html: (inode 2196195) not found on tape

The corresponding directories do exist in the extract folder, but the listed files are indeed missing.

This looks like the same issue:

<https://www.linuxquestions.org/questions/linux-general-1/file-not-found-on-tape-during-interactive-restore-on-fedora-core-9-a-4175465723/>

But looking at this:

<https://www.linuxquestions.org/questions/linux-newbie-8/dump-restore-not-found-on-tape-539280/>

This suggests that the dump is spread across 2 tapes (=files)! NOTE: this also happened with one of the DDS tapes (1st round), but which one?!


[^1]: If you don't run `restore` as sudo, extraction results in a flood of `chown: Operation not permitted` messages (the files *are* extracted though).

[^2]: Needs further investigation, implications of this setting and what it does are not 100% clear to me.


## Notes on contents of extracted archive files

### DDS tapes

#### Tape 1

- file000001: 10 MB, nothing interesting.
- file000002: 200 MB, application files
- file000003: 1.1 GB, user dirs

Apparently no web site data.

#### Tape 2

- file000001: 1.5 GB
- dir `/home/www.xxlink.nl` contains logs (1994/95)
- dir `/home/local/www` contains 26 folders that each hold a web site!
- dir `/home/local/etc` contains [httpd configuration file](https://httpd.apache.org/docs/2.4/configuring.html) `httpd.conf` which defines the configuration for all sites. Example:

        #-----------------------------------------------------------------------
        # NV Luchthaven Schiphol (193.79.208.32)
        #
        MultiHost	www.schiphol.nl

        Map		/*.map		/htbin/htimage/home/local/www/schiphol/root/*.map
        Exec		/htbin/*	/home/local/www/cgi-bin/*

        Exec		/cgi-bin/*	/home/local/www/schiphol/cgi-bin/*

        #
        # URL translation rules
        #

        Welcome		home.htm
        DirAccess	selective
        NoLog		193.79.208.*
        NoLog		193.79.209.*
        NoLog		193.78.242.34

        Redirect	/schiphol*		*

        Redirect	*/home.htm/		*/home.htm
        Redirect	*/home.html		*/home.htm
        Redirect	*/Welcome.html		*/home.htm

        Map		*://*			/noproxy.htm

        Pass		/*			/home/local/www/schiphol/root/*

        Pass		http:*
        Pass		gopher:*
        Pass		wais:*
        Pass		ftp:*

        #
        # 	Caching parameters.
        #

        Caching		Off
        Gc		O

According the [info here](https://askubuntu.com/questions/652095/cant-find-httpd-conf) `httpd.conf` Apache under Ubuntu does not use this file by default, but it can be imported by adding an include to the global config file, as explained there. [This article](https://opensource.com/article/18/3/configuring-multiple-web-sites-apache) explains how to configure multiple web sites with Apache.


#### Tape 3

#### Tape 4

#### Tape 5

#### Tape 6

#### Tape 7

#### Tape 8

#### Tape 9

#### Tape 10

#### Tape 11

#### Tape 12

#### Tape 13

#### Tape 14

#### Tape 15

#### Tape 16

#### Tape 17

#### Tape 18

#### Tape 19



### DLT tapes


## Notes on reconstruction of sites

For convenience we combine all Apache site config entries into one file (`etc/apache2/sites-enabled/xxlink.conf`).

1. Copy directory with site contents to `/var/www`, and adjust the permissions using:

        sudo find schiphol -type d -exec chmod 755 {} \;
        sudo find schiphol -type f -exec chmod 666 {} \;

2. Add new *VirtualHost* entry to Apache config file:

        <VirtualHost *:80>
            ServerName schiphol.nl:80

            ServerAdmin webmaster@localhost
            ServerName schiphol.nl
            ServerAlias www.schiphol.nl
            DocumentRoot /var/www/schiphol/root

            # Below line redirects DocumentRoot to home.htm
            RedirectMatch ^/$ "/home.htm"

            ErrorLog ${APACHE_LOG_DIR}/error.log
            CustomLog ${APACHE_LOG_DIR}/access.log combined

        </VirtualHost>

    We get the values for *ServerName* and *ServerAlias* from the [httpd configuration file](https://httpd.apache.org/docs/2.4/configuring.html) `httpd.conf`. The *RedirectMatch* redirects the *DocumentRoot* to the landing page (here: home.htm)

3. Activate the configuration file. First disable the current configuration (in this case 8000-default.conf*):

        sudo a2dissite 000-default.conf

    Now enable the new one:

        sudo a2ensite xxlink.conf

4. Add original domain to hosts file. Open (with sudo priviliges) file `/etc/hosts` in a text editor, and add a line that associates the IP address at which the site is locally available to its original URL. For example:

        127.0.0.1	www.schiphol.nl

    Then save the file.

5. Restart the server:

        sudo systemctl restart apache2

All done! The newly installed site is now available at the original URL in your web browser.

For some reason, copying the site data to an external disk and then referencing that location in the config file doesn't work.


## Automation

Needs improvement. Current steps are:

1. Make copy of httpd configuration file and remove all test entries

2. Run [this script](./scripts/readsiteinfo.sh), taking httpd configuration file as input. Then manually edit away  `/htbin/htimage` prefixes and `/*.map` /suffixes (using search/replace). Result:

        domain,rootDir
        www.obragas.nl,/home/local/www/obragas/root
        www.iksx.nl,/home/local/www/iksx/root
        www.dataman.nl,/home/local/www/dataman/root

3. 

## Resources

- [dump(8)](https://linux.die.net/man/8/dump)

- [restore(8)](https://linux.die.net/man/8/restore)

- [restore Linux Commands](https://www.hscripts.com/tutorials/linux-commands/restore.html)

- [How to Restore UFS Files Interactively](https://docs.oracle.com/cd/E19253-01/817-5093/bkuprestoretasks-63510/index.html) (best description I've seen so far)