#!/bin/bash
#
# Extract contents of a tape. Each file on the tape is extracted as a separate file.
#
# Script must be executed as root (sudo)
#

# **************
# USER I/O
# **************

# Check command line args
if [ "$#" -ne 2 ] ; then
  echo "Usage: readtape.sh prefix dirOut" >&2
  exit 1
fi

if ! [ -d "$2" ] ; then
  echo "dirOut must be a directory" >&2
  exit 1
fi

prefix=$1
# Normalise dirOut to absolute path
dirOut=$(readlink -f $2)

# Create checksum file
workDir=$PWD
cd $dirOut
checksumFile=$prefix.sha512
sha512sum * >> $checksumFile
cd $workDir
echo "*** Created checksum file ***" >> $logFile
