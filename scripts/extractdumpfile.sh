#!/bin/bash

# Extract contents of dump file (starts interactive session)
# and fixes permissions on output
# Script must be run with sudo privilege

if [ "$#" -ne 2 ] ; then
  echo "Usage: extractdumpfile.sh dumpIn dirOut" >&2
  exit 1
fi

if ! [ -f "$1" ] ; then
  echo "dumpIn must be a file" >&2
  exit 1
fi

if ! [ -d "$2" ] ; then
  echo "dirOut must be a directory" >&2
  exit 1
fi

# Input dump file
dumpIn="$1"

# Output directory (absolute path)
dirOut=$(realpath "$2")

# User directory (absolute path)
dirUser=$(pwd)

# Go to output directory
cd $dirOut

# Run restore (this starts an interactive session)
restore -if $dumpIn

# Go back to user directory
cd $dirUser

# Set permissions on extracted files and directories
find $dirOut -type f -exec chmod 644 {} \;
find $dirOut -type d -exec chmod 755 {} \;

# Notify user
echo "Done!"