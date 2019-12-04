#!/bin/bash

# Extract contents of dump and tar containers
# for dump files this requires some user input,
# and permissions are fixed on output afterwards
# Script must be run with sudo privilege

if [ "$#" -ne 2 ] ; then
  echo "Usage: extractcontainer.sh fileIn dirOut" >&2
  exit 1
fi

if ! [ -f "$1" ] ; then
  echo "fileIn must be a file" >&2
  exit 1
fi

if ! [ -d "$2" ] ; then
  echo "dirOut must be a directory" >&2
  exit 1
fi

# Input file
fileIn="$1"

# Establish file type
fTypeString=$(file $fileIn)

if [[ $fTypeString == *"new-fs dump file"* ]]; then
  fileType="dump"
fi

if [[ $fTypeString == *"tar archive"* ]]; then
  fileType="tar"
fi

echo $fileType

# Output directory (absolute path)
dirOut=$(realpath "$2")

# User directory (absolute path)
dirUser=$(pwd)

# Go to output directory
cd $dirOut

if [[ $fileType == "dump" ]]; then
  echo "Extracting dump file ..."
  # Source: https://docs.oracle.com/cd/E19253-01/817-5093/bkuprestoretasks-72504/index.html
  restore -xvf $fileIn .
  extractStatus=$?
  # Go back to user directory
  cd $dirUser

  echo "Fixing permissions on extracted files and directories ..."
  find $dirOut -type f -exec chmod 644 {} \;
  find $dirOut -type d -exec chmod 755 {} \;

fi

if [[ $fileType == "tar" ]]; then
  echo "Extracting TAR archive ..."
  # Run tar
  tar -xf $fileIn
  extractStatus=$?
  # Go back to user directory
  cd $dirUser

  # Transfer ownership of dirOut to default user
  # (only affects top-level directory)
  echo "Set owner of top-level directory ..."
  chown johan $dirOut

  #echo "Fixing permissions on extracted files and directories ..."
  #find $dirOut -type f -exec chmod 644 {} \;
  #find $dirOut -type d -exec chmod 755 {} \;
fi

# Notify user
echo "Done, exit status of extract command was "$extractStatus