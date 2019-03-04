#!/bin/sh

show_help ()
{ # Show help message
cat << EOF
Usage: ${0##*/} [-h] [-d device] [-c command] [-n baseName]
                [-s suffix] [-t tries] [-e description] [-o notes]

Create ISO image from CD or DVD.

positional arguments:

    dirOut          output directory

optional arguments:

    -h              display this help message and exit
    -d device       optical drive (default: /dev/sr0)
    -c command      command used to read the disc. Allowed values:
                    readom / ddrescue (default: readom) 
    -n baseName     base name for image file (default: image)
    -s suffix       suffix for image file (default: iso)
    -t tries        number of tries (default: 4)
    -e description  descriptive string or title (default: empty string)
    -o notes        notes (default: empty string)
EOF
}

# Initialize command line variables

# Optical drive
deviceName="/dev/sr0"
command="readom"
# Base name
baseName="image"
description=""
notes=""
sectorSize="2048"
suffix="iso"
tries="4"

OPTIND="1"
# Read variable from command line
while getopts ":h:d:c:n:e:o:s:t:" opt; do
    case "$opt" in
        h)
            show_help
            exit 0
            ;;
        d)  deviceName="$OPTARG"
            ;;
        c)  command="$OPTARG"
            ;;
        n)  baseName="$OPTARG"
            ;;
        e)  description="$OPTARG"
            ;;
        o)  notes="$OPTARG"
            ;;
        s)  suffix="$OPTARG"
            ;;
        t)  tries="$OPTARG"
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"

# Check command line args
if [ "$#" -ne 1 ] ; then
    show_help
    exit 1
fi

# Positional arguments
# dirOut, normalise to absolute path
dirOut="$(readlink -f $1)"

if ! [ -d "$dirOut" ] ; then
    echo "ERROR: dirOut must be a directory" >&2
    exit 1
fi

# Unmount disk (probably not really needed, but just making sure)
umount $deviceName

# Construct command line
if [ $command = "readom" ] ; then
    cdReadCommand="readom retries=$tries dev=$deviceName f=$dirOut/$baseName.$suffix" > $dirOut/$baseName."stdout" 2> $dirOut/$baseName."stderr"
fi

if [ $command = "ddrescue" ] ; then
    cdReadCommand="ddrescue -d -n -b $sectorSize -r$tries -v $deviceName $dirOut/$baseName.$suffix $dirOut/$baseName.log" > $dirOut/$baseName."stdout" 2> $dirOut/$baseName."stderr"
fi

# Start datetime
dtStart=$(date --iso-8601=seconds)

# Run command line
$cdReadCommand

# Exit code
readExitCode="$?"

if [ $readExitCode = 0 ] ; then
    exitOK=true
else
    exitOK=false
    echo "Error: read process exited with error!" >&2
fi

# Compute checksum on image, store to file
checksum=$(sha512sum $dirOut/$baseName.$suffix)
echo $checksum > $dirOut/$baseName.$suffix."sha512"

# End datetime
dtEnd=$(date --iso-8601=seconds)

# Write log file (JSON format)

logFile=$dirOut/"metadata.json"

echo "{" > $logFile
echo \""acquisitionStart"\": \"$dtStart\", >> $logFile
echo \""acquisitionEnd"\": \"$dtEnd\", >> $logFile
echo \""fileName"\": \"$baseName.$suffix\", >> $logFile
echo \""readCommand"\": \"$cdReadCommand\", >> $logFile
echo \""readExitCode"\": $readExitCode, >> $logFile
echo \""description"\": \"$description\", >> $logFile
echo \""notes"\": \"$notes\", >> $logFile
echo \""checksumType"\": \""SHA-512"\", >> $logFile
echo \""checksum"\": \"$(echo $checksum | cut -d ' ' -f 1)\" >> $logFile
echo "}" >> $logFile

# Fix access permissions

#chmod 777 $baseName.$suffix
#chmod 777 $baseName.json
#chmod 777  $baseName.$suffix."md5"
#chmod 777 $baseName."stdout"
#chmod 777 $baseName."stderr"
