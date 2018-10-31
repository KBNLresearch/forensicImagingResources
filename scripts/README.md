# Scripts

This directory contains various scripts for extracting data from a variety of carriers, and for the subsequent processing of these data.

## readtape.sh

This script extracts data from a tape using the [dd](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/dd.html) command. It is format-agnostic, and only extracts raw bytestreams. By default the script tries to extract all "sessions" (i.e. sequential files) up to the end of the tape. Each session is stored as a separate file. After the extraction is done it also generates a checksum file with SHA-512 hashes of the extracted files. Note that the script must be run as superuser.

|**WARNING**|
|:-|
|At this stage this script has had only limited testing with a small number of DDS-1 tapes. Use at your own risk!|

### Usage

    Usage: readtape.sh [-h] [-d device] [-b blockSize] [-s sessions] [-p prefix]
                    [-e extension] dirOut

### Positional arguments

|Argument|Description|
|:-|:-|
|`dirOut`|Output directory|

### Optional arguments

|Argument|Description|
|:-|:-|
|`-h`|Display help message and exit|
|`-d device`|Non-rewind tape device (default: `/dev/nst0`)|
|`-b blockSize`|Initial block size in bytes (must be a multiple of 512). This is used as a starting value for the script's built-in block size estimation procedure. Block sizes smaller than 4096 are reported to give poor performance (source: [*forensicswiki*](https://www.forensicswiki.org/wiki/Dd)), and this option can be useful to speed up the extraction process in such cases. Note that `-b` is ignored if the `-f` (fill) option is also used.|
|`-s sessions`|Comma-separated list of sessions to extract (default: extract all sessions)|
|`-p prefix`|Output prefix (default: `session`)|
|`-e extension`|Output file extension (default: `.dd`)|
|`-f`|Fill blocks that give read errors with null bytes. When this option is activated, the script calls *dd* with the flags `conv=noerror,sync`. The use of these flags is often recomended to ensure a forensic image with no missing/offset bytes in case of read errors (source: [*forensicswiki*](https://www.forensicswiki.org/wiki/Dd)), but when used with a block size that is larger than the actual block size it will generate padding bytes that make the extracted data unreadable. Because of this, any user-specified value of `-b` (blockSize) is ignored when this option is used. **WARNING: using this option will most likely result in malformed output if the actual block size of a session is either smaller than 512 bytes, and/or if the block size is not a multiple of 512 bytes! (I have no idea if this is even possible?)**|

### Block size estimation

The script uses an iterative process to establish the block size for each session. It first tries to read one record using a block size of 512 bytes. If this results in an error, another 512 bytes are added to the initial block size estimate, and another attempt is made. This is repeated until the record can be read without errors. The smallest block size estimate that does not result in an error is used for extracting the session as a whole.

### Examples

The following example extracts the contents of a tape to the current working directory:

`sudo readtape.sh .`

The following output is generated:

- For each session on the tape, a file with the extracted data (`session000001.dd`, `session000002.dd`, etcetera)
- A checksum file with the SHA-512 hashes of the extracted files
- A log file (`readtape.log`)

The example below extracts only the 2nd and 3rd session of a tape:

`sudo readtape.sh -s 2,3 .`
