# Digital forensics and web archaeology resources

## Tapes

- [How to use the DAT-tape with Linux](http://www.cs.inf.ethz.ch/stricker/lab/linux_tape.html)
- [HP Surestore and StorageWorks DAT - HP DAT Accessories and Part Numbers](https://web.archive.org/web/20181101135618/https://support.hpe.com/hpsc/doc/public/display?docId=emr_na-lpg50205)
-[HP StorageWorks DDS/DAT Media - DDS/DAT Media Compatibility Matrix](https://support.hpe.com/hpsc/doc/public/display?docId=emr_na-lpg50457)
- [15 Useful Linux and Unix Tape Managements Commands For Sysadmins](https://www.cyberciti.biz/hardware/unix-linux-basic-tape-management-commands/)
- [Linux Set the Block Size for a SCSI Tape Device](https://www.cyberciti.biz/faq/rhel-centos-debian-set-tape-blocksize/)
- [Reading VMS tapes from Linux](https://www.tldp.org/HOWTO/VMS-to-Linux-HOWTO/x838.html)
- [Reading Tapes Written on Other Systems](http://www.astro.sunysb.edu/sysman/fits.html)
- [reading 'unknown' data from a tape](https://www.linuxquestions.org/questions/linux-general-1/reading-%27unknown%27-data-from-a-tape-4175500596/)
- [Copying Files and File Systems to Tape (Oracle documentation)](https://docs.oracle.com/cd/E19455-01/805-7228/6j6q7uf24/index.html) - explains pax, tar and cpio
- [How to copy data from DDS tape to UNIX station](https://community.hpe.com/t5/System-Administration/How-to-copy-data-from-DDS-tape-to-UNIX-station/td-p/4780851#.W9MEpxCxU3E)
- [Purpose of ibs/obs/bs in dd](https://stackoverflow.com/questions/1354938/purpose-of-ibs-obs-bs-in-dd) - one of the answers explains particular importance of block size in case of tapes
- [Duplicating a tape drive using dd ](https://www.linuxquestions.org/questions/linux-newbie-8/duplicating-a-tape-drive-using-dd-4175592839/) - more info on block size.
- [What does dd conv=sync,noerror do?](https://superuser.com/questions/622541/what-does-dd-conv-sync-noerror-do) - confirms that using these flags is generally a bad idea
- [Write protect in DLT IV Data cartridge](https://web.archive.org/web/20181031154114/https://community.hpe.com/t5/StoreEver-Tape-Storage/Write-protect-in-DLT-IV-Data-cartridge/td-p/129718https://community.hpe.com/t5/StoreEver-Tape-Storage/Write-protect-in-DLT-IV-Data-cartridge/td-p/129718)
- [mhVTL Virtual Tape Library](https://www.mhvtl.com/); source code [here](https://github.com/markh794/mhvtl)
- [mhVTL install script for Ubuntu](https://gist.github.com/hrchu/3eb1c0aa9994df0328037fff04cd889d)
- [The Source of All Tape Knowledge](http://www.subspacefield.org/~vax/unix_tape.html)
- [Tapeimgr](https://github.com/KBNLresearch/tapeimgr) - simple format-agnostic tape imaging / extraction software (GUI application, wraps around dd/mt)
- [Experiences of an LTO/LTFS beginner](https://digitensions.home.blog/2019/01/15/technologic/)

## SCSI

- [What kind of SCSI do I have? Single-ended or differential SCSI interface?](http://www.paralan.com/sediff.html) -*really* helpful for identifying SCSI connector types!
- [LVD, SE, HVD, SCSI Compatibility - Or Not](http://www.paralan.com/scsiexpert.html)
- [SCSI articles on Paralan (AKA the SCSI Bible)](http://www.paralan.com/aboutscsi.html)
- [SCSI Connector Guide](https://www.cablestogo.com/learning/connector-guides/scsi)
- [Adaptec SCSI controller specifications](https://storage.microsemi.com/en-us/support/scsi/)
- [SCSI Termination](https://support.hpe.com/hpsc/doc/public/display?docId=tis14318)

## Tape archive formats (and how to read / extract them)

- [Unix dump format](http://fileformats.archiveteam.org/wiki/Unix_dump)
- [dump(8)](https://linux.die.net/man/8/dump)
- [restore(8)](https://linux.die.net/man/8/restore)
- [restore Linux Commands](https://www.hscripts.com/tutorials/linux-commands/restore.html)
- [How to Restore UFS Files Interactively](https://docs.oracle.com/cd/E19253-01/817-5093/bkuprestoretasks-63510/index.html) (excellent resource for restoring dump files)
- [Microsoft™ Tape Format Specification Version 1.00a](http://laytongraphics.com/mtf/MTF_100a.PDF)
- [mtftar](https://github.com/sjmurdoch/mtftar) - mtftar is a tool for translating a Microsoft NTBackup (MTF) stream to a TAR stream
- [Recovering NTBackup Tapes](https://www.108.bz/posts/it/recovering-ntbackup-tapes/)

## Floppy disks

- [Rescuing Floppy Disks (ArchiveTeam)](https://www.archiveteam.org/index.php/Rescuing_Floppy_Disks)
- [The Archivist’s Guide to KryoFlux](https://github.com/archivistsguidetokryoflux/archivists-guide-to-kryoflux)
- [KryoFlux floppy case](https://www.thingiverse.com/thing:3089895)
- [Accessing Mac Formatted Floppy Disks without a Kryoflux](https://porterolsen.wordpress.com/2016/06/15/accessing-mac-formatted-floppy-disks-without-the-kryoflux/)
- [Getting Data Out Of Its Floppy Cage](http://www.wcsarchivesblog.org/getting-data-out-of-its-floppy-cage/) - provides some details on how to get the FC5025 floppy controller working with BitCurator
- [Use Guide for the FC5025 Floppy Disk Controller](https://web.archive.org/web/20180507194729/https://mith.umd.edu/vintage-computers/fc5025-operation-instructions)
- [Bodging a case for a 5.25″ floppy drive](https://radd.dsalo.info/2017/01/bodging-a-case-for-a-5-25-floppy-drive/)
- [Digital Archaeology and/or Forensics: Working with Floppy Disks from the 1980s](https://journal.code4lib.org/articles/11986)

## Cables

- [The Cable Bible](https://amiaopensource.github.io/cable-bible/)

## PCI Cards

- [PCI card types](https://upload.wikimedia.org/wikipedia/commons/1/15/PCI_Keying.svg)
- [Startech PCI Express to PCI Adapter Card](https://www.startech.com/nl/en/Cards-Adapters/Slot-Extension/PCI-Express-to-PCI-Adapter-Card~PEX1PCI1)
- [Sintech PCI-E Express X1 to Dual PCI Riser Extender Card](https://www.amazon.com/gp/product/B00KZHDSLQ?psc=1&redirect=true&ref_=oh_aui_detailpage_o07_s00)

## Web archaeology

- [DIY Handboek voor Webarcheologie](https://hart.amsterdam/image/2017/11/17/20171116_freeze_diy_handboek.pdf)
- [Project "The Digital City Revives" A Case Study of Web Archaeology](https://hart.amsterdam/image/2016/11/28/20160730_redds_tjardadehaan.pdf)
- [Server-side Preservation of Dynamic Websites](http://publications.beeldengeluid.nl/pub/633/)

## Data rescue and digital forensics (general)

- [Getting to Know FRED: Introducing Workflows for Born-Digital Content](https://practicaltechnologyforarchives.org/issue4_prael_wickner/)
- [Digital Forensics and Preservation (DPC Report)](http://dx.doi.org/10.7207/twr12-03)
- [Digital Archives Workstation Update: KryoFlux, FRED, and BitCurator Walk into a Bar…](https://blogs.princeton.edu/techsvs/2017/10/03/digital-archives-workstation-update-kryoflux-fred-and-bitcurator-walk-into-a-bar/)
- [NYPL’s New Digital Archives Lab](https://www.nypl.org/blog/2017/01/11/nypls-new-digital-archives-lab)
- [Michigan University Digital Preservation Lab 2.0](https://www.lib.umich.edu/blogs/bits-and-pieces/digital-preservation-lab-20)
- [Building Audio, Video, And Data-Rescue Kits](https://radd.dsalo.info/wp-content/uploads/2017/10/BuildDocumentation.pdf)
- [Disk Image Formats](https://wiki.harvard.edu/confluence/display/digitalpreservation/Disk+Image+Formats)
- [Automated Processing of Disk Images and Directories in BitCurator (Tim Walsh)](https://www.bitarchivist.net/blog/2017-05-01-buf2017/)
- [Challenges of Dumping/Imaging old IDE Disks](https://openpreservation.org/blog/2013/03/20/challenges-dumpingimaging-old-ide-disks/)
- [BitCurator Workflows](https://bitcuratorconsortium.org/workflows)
- [Museum of Obsolete Media](https://obsoletemedia.org/)