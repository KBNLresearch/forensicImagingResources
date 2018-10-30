#!/bin/bash


show_help() {
cat << EOF
Usage: ${0##*/} [-h] [-d device] [-b blockSize] [-s sessions] [-p prefix]
                [-e extension] dirOut

Read contents of tape. Each session is stored as a separate file. 

positional arguments:

    dirOut          output directory

optional arguments:

    -h              display this help and exit
    -d device       non-rewind tape device (default: /dev/nst0)
    -b blockSize    initial block size (must be multiple of 512)
    -s sessions     comma-separated list of sessions to extract
    -p prefix       output prefix
    -e extension    output file extension
    -f              in case of a read errors, null fill remainder
                    of current block

EOF
}

# Initialize variables

# Non-rewind tape device
tapeDevice=/dev/nst0
# Initial block size
blockSize=512
sessions=""
# Output prefix
prefix="session"
# Output extension
extension="dd"
fill=false

OPTIND=1

while getopts ":h:fd:b:s:p:e:" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        f)  fill=true
            echo "-f was triggered"
            ;;
        d)  tapeDevice=$OPTARG
            ;;
        b)  blockSize=$OPTARG
            ;;
        s)  sessions=$OPTARG
            ;;
        p)  prefix=$OPTARG
            ;;
        e)  extension=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --

# Check command line args
if [ "$#" -ne 1 ] ; then
    show_help
    exit 1
fi

# Positional arguments
dirOut=$1

if ! [ -d $dirOut ] ; then
    echo "ERROR: dirOut must be a directory" >&2
    exit 1
fi

# Check if block size is valid (i.e. a multiple of 512) by comparing integer
# division of blockSize by 512 against floating-point division
blocksInt=$(($blockSize / 512))
blocksFloat=$(echo "$blockSize/512" | bc -l )
# This yields 1 if block size is valid, and 0 otherwise 
blocksizeValid=$(echo "$blocksInt == $blocksFloat" |bc -l)

if ! [ $blocksizeValid -eq 1 ] ; then
    echo "ERROR: invalid blockSize, must be a multiple of 512!" >&2
    exit 1
fi

# Rest of the program here.
# If there are input files (for example) that follow the options, they
# will remain in the "$@" positional parameters.

echo "prefix = "$prefix
echo "dirOut = "$dirOut
echo "blockSize = "$blockSize
echo "sessions = "$sessions
echo "extension = "$extension
echo "fill = "$fill

if [ "$fill" = "true" ] ; then
    # dd's conv=sync flag results in padding bytes for each block if block 
    # size is too large, so override user-defined value with default
    # if -f flag was used
    blockSize=512
    echo "*** Reset blockSize to 512 because -f flag is used  ***"
fi

endOfTape=false

session=1

# Iterate over all sessions on tape until end is detected
while [ $endOfTape == "false" ]
do
    # Process one session

    # Set initial value of extractSessionFlag depending on sessions parameter
    if [ -z $sessions ] ; then
        extractSession=true
    else
        extractSession=false
    fi

    # Only extract sessions defined by sessions parameter
    # (if session parameter is empty all sessions are extracted)
    for i in ${sessions//,/ }
        do
        if [ $i == $session ] ; then
            extractSession=true
        fi
    done

    # TODO in extraction script:
    # - Extract session if extractSession = true
    # - Forward to next session if extractSession = false

    if [ $session -gt 10 ] ; then
        endOfTape=true
    fi

    echo $session, " process = "$processSession

    # Increase session
    let session=$session+1
done