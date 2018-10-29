#!/bin/sh
# POSIX

show_help() {
cat << EOF
Usage: ${0##*/} [-hv] [dirOut] [prefix]...
Read contents of tape. Each session is stored as a separate file. 

    -h            display this help and exit
    -b blockSize  initial block size (must be multiple of 512)
    -s sessions   comma-separated list of sessions to extract
    dirOut        output directory
    prefix        file prefix
EOF
}

# Initialize variables
blockSize=512

OPTIND=1

while getopts ":h:b:s:" opt; do
    case $opt in
        h)
            show_help
            exit 0
            ;;
        b)  blockSize=$OPTARG
            ;;
        s)  sessions=$OPTARG
            ;;
        *)
            show_help >&2
            exit 1
            ;;
    esac
done
shift "$((OPTIND-1))"   # Discard the options and sentinel --

# Check command line args
if [ "$#" -ne 2 ] ; then
show_help
exit 1
fi

# Positional arguments
dirOut=$1
prefix=$2

if [ -z $prefix ] ; then
  echo "Prefix is undefined" >&2
  exit 1
fi

if ! [ -d $dirOut ] ; then
echo "dirOut must be a directory" >&2
exit 1
fi

echo "prefix = "$prefix
echo "dirOut = "$dirOut

echo "blockSize = "$blockSize
echo "sessions = "$sessions

# Rest of the program here.
# If there are input files (for example) that follow the options, they
# will remain in the "$@" positional parameters.