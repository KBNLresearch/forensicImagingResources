# Scripts

This directory contains various scripts for extracting data from a variety of carriers, and for the subsequent processing of these data.

## readtape.sh

This script extracts data from a tape using the [dd](http://pubs.opengroup.org/onlinepubs/9699919799/utilities/dd.html) command. It is format-agnostic, and only extracts raw bytestreams. By default the script tries to extract all "sessions" (i.e. sequential files) up to the end of the tape. Each session is stored as a separate file. After the extraction is done it also generates a checksum file with SHA-512 hashes of the extracted files. Note that the script must be run as superuser.

### Usage

    Usage: readtape.sh [-h] [-d device] [-b blockSize] [-s sessions] [-p prefix]
                    [-e extension] dirOut

### Positional arguments

|Argument|Description|
|:-|:-|
|`dirOut`|output directory|

### Optional arguments

|Argument|Description|
|:-|:-|
|`-h`|display help message and exit|
|`-d device`|non-rewind tape device (default: `/dev/nst0`)|
|`-b blockSize`|initial block size (must be a multiple of 512)|
|`-s sessions`|comma-separated list of sessions to extract (default: extract all sessions)|
|`-p prefix`|output prefix (default: `session`)|
|`-e extension`|output file extension (default: `.dd`)|
|`-f`|fill blocks that give read errors with null bytes|

### Example

The following command extracts the contents of a tape to the current working directory:

`sudo readtape.sh .`

The following output is generated:

- For each session on the tape, a file with the extracted data (`session000001.dd`, `session000002.dd`, etcetera)
- A checksum file with the SHA-512 hashes of the extracted files
- A log file (`readtape.log`)

