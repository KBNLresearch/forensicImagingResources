# Digital forensics and web archaeology resources

## Tapes

- [Recovering '90s Data Tapes - Experiences From the KB Web Archaeology project (iPres 2019 paper)](https://www.bitsgalore.org/2019/09/09/recovering-90s-data-tapes-experiences-kb-web-archaeology)
- [Tape Driver Semantics](https://wiki.zmanda.com/index.php/Tape_Driver_Semantics) - Excellent summary of the behavior of tapes on UNIX systems.
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
- [Duplicating a tape drive using dd](https://www.linuxquestions.org/questions/linux-newbie-8/duplicating-a-tape-drive-using-dd-4175592839/) - more info on block size.
- [What does dd conv=sync,noerror do?](https://superuser.com/questions/622541/what-does-dd-conv-sync-noerror-do) - confirms that using these flags is generally a bad idea
- [Write protect in DLT IV Data cartridge](https://web.archive.org/web/20181031154114/https://community.hpe.com/t5/StoreEver-Tape-Storage/Write-protect-in-DLT-IV-Data-cartridge/td-p/129718https://community.hpe.com/t5/StoreEver-Tape-Storage/Write-protect-in-DLT-IV-Data-cartridge/td-p/129718)
- [mhVTL Virtual Tape Library](https://www.mhvtl.com/); source code [here](https://github.com/markh794/mhvtl)
- [mhVTL install script for Ubuntu](https://gist.github.com/hrchu/3eb1c0aa9994df0328037fff04cd889d)
- [The Source of All Tape Knowledge](http://www.subspacefield.org/~vax/unix_tape.html)
- [Tapeimgr](https://github.com/KBNLresearch/tapeimgr) - simple format-agnostic tape imaging / extraction software (GUI application, wraps around dd/mt)
- [Experiences of an LTO/LTFS beginner](https://digitensions.home.blog/2019/01/15/technologic/)
- [Data by the Foot](https://campuspress.yale.edu/borndigital/2019/08/30/data-by-the-foot/) - blog about tape data recovery at Yale University Library

## SCSI

- [What kind of SCSI do I have? Single-ended or differential SCSI interface?](http://www.paralan.com/sediff.html) -*really* helpful for identifying SCSI connector types!
- [LVD, SE, HVD, SCSI Compatibility - Or Not](http://www.paralan.com/scsiexpert.html)
- [SCSI articles on Paralan (AKA the SCSI Bible)](http://www.paralan.com/aboutscsi.html)
- [SCSI Connector Guide](https://www.cablestogo.com/learning/connector-guides/scsi)
- [Adaptec SCSI controller specifications](https://storage.microsemi.com/en-us/support/scsi/)
- [SCSI Termination](https://support.hpe.com/hpsc/doc/public/display?docId=tis14318)
- Here's a good series of articles on pctechguide.com:
    - [SCSI Adapters](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-adapters)
    - [SCSI Internal Intro](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-internal-intro)
    - [SCSI Internal Configuration](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-internal-configuration)
    - [SCSI Internal Mounting](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-internal-mounting)
    - [SCSI Internal Connections](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-internal-connections)
    - [SCSI Internal Software](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-internal-software)
    - [SCSI External](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-external)
    - [Installing a SCSI device – making the connections](https://www.pctechguide.com/how-to-install-a-scsi-device/installing-a-scsi-device-making-the-connections)
    - [SCSI External Config](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-external-config)
    - [SCSI External Software](https://www.pctechguide.com/how-to-install-a-scsi-device/scsi-external-software)
- [Squishy: a platform for working with old SCSI devices with modern systems in a flexible manner](https://github.com/lethalbit/squishy)

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
- [Adafruit Floppy](https://github.com/adafruit/Adafruit_Floppy) - a helper library to abstract away interfacing with floppy disk drives in a cross-platform and open source library.
- [A Dogged Pursuit: Capturing Forensic Images of 3.5” Floppy Disks](https://practicaltechnologyforarchives.org/issue2_waugh/)


## Optical media

- [An Introduction to Optical Media Preservation (Alexander Duryee)](https://journal.code4lib.org/articles/9581)
- [Developing a Robust Migration Workflow for Preserving and Curating Hand-held Media](https://arxiv.org/abs/1309.4932)
- [Preserving Write-Once DVDs (Blood Report for LoC)](http://www.digitizationguidelines.gov/audio-visual/documents/Preserve_DVDs_BloodReport_20140901.pdf)
- [Assessing High-volume Transfers from Optical Media at NYPL](https://journal.code4lib.org/articles/15908)
- [CD Formats and Their Longevity - FAQ (Canadian Conservation Institute)](https://web.archive.org/web/20170825093105if_/http://canada.pch.gc.ca/eng/1456339921100)
- [Andy McFadden's CD-Recordable FAQ](https://www.cdrfaq.org/)
- [Preserving optical media from the command-line](https://www.bitsgalore.org/2015/11/13/preserving-optical-media-from-the-command-line)
- [A simple workflow tool for imaging optical media using readom and ddrescue](https://www.bitsgalore.org/2019/03/22/a-simple-workflow-tool-for-imaging-optical-media-using-readom-and-ddrescue)
- [Imaging CD-Extra / Blue Book discs](https://www.bitsgalore.org/2017/04/25/imaging-cd-extra-blue-book-discs)
- [Image and Rip Optical Media Like A Boss!](https://www.bitsgalore.org/2017/06/19/image-and-rip-optical-media-like-a-boss)
- [Isolyzer](https://github.com/KBNLresearch/isolyzer) - tool that verifies if the file size of a CD / DVD image ("ISO image") is consistent with the information in its filesystem-level headers.
- [Acronova Nimbie Drive Replacement Instruction](https://web.archive.org/web/20210915163606/http://www.usarcades.com/wp-content/uploads/Drive-Replacement-Instruction-v1.2.pdf)
- [To Everything There Is a Session: A Time to Listen, a Time to Read Multi-session CDs (Dietrich, Nelson)](https://journal.code4lib.org/articles/17208)

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
-[Archaeology of the Amsterdam digital city; why digital data are dynamic and should be treated accordingly](https://www.tandfonline.com/doi/full/10.1080/24701475.2017.1309852)

## Data rescue and digital forensics (general)

- [Digital Forensics and Preservation](http://dx.doi.org/10.7207/twr12-03)
- [Digital Archaeology: Rescuing Neglected and Damaged Data Resources](http://www.ukoln.ac.uk/services/elib/papers/supporting/pdf/p2.pdf)
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
- [Born Digital Workflows, UNC at Chapel Hill Libraries, Wilson Special Collections Library](http://wilsonborndigital.web.unc.edu/)
- [CCA Digital Archives Processing Manual](https://github.com/CCA-Public/digital-archives-manual) - includes LOTS of detailed workflow descriptions
- [Guide to identifying obsolete digital media](https://www.projectcest.be/wiki/Publicatie:Handleiding_Verouderde_Dragers_Herkennen) (in Dutch)
- [Digital Repair Cafe](https://automatic-ingest-digital-archives.github.io/Digital-Repair-Cafe/) - links to various capture workflows.
- [How to Read a Floppy Disk on a Modern PC or Mac](https://www.howtogeek.com/669331/how-to-read-a-floppy-disk-on-a-modern-pc-or-mac/)
- [Disk Imaging Decision Factors](https://dannng.github.io/disk-imaging-decision-factors.html)
- [Imaging Digital Media for Preservation with LAMMP](https://resources.culturalheritage.org/emg-review/volume-three-2013-2014/mckinley/)
- [Towards Best Practices In Disk Imaging: A Cross-Institutional Approach](https://resources.culturalheritage.org/emg-review/volume-6-2019-2020/colloton/)
- [NMAAHC Disk Imaging Workshop](http://eddycolloton.com/blog/2022/4/6/nmaahc-disk-imaging-workshop)
- [National Institute of Standards and Technology (NIST) Computer Forensic Tool Testing (CFTT) Reports](https://www.dhs.gov/science-and-technology/nist-cftt-reports)
- [Cambridge University Library Transfer Service](https://digitalpreservation-blog.lib.cam.ac.uk/the-transfer-service-40bddeff0d32)