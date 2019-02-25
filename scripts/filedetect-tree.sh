#!/bin/bash

# Identify format of each file in directory tree with file(1)
# Check command line args
if [ "$#" -ne 2 ] ; then
  echo "Usage: filedetect-tree.sh rootDirectory outputFile" >&2
  exit 1
fi

if ! [ -d "$1" ] ; then
  echo "rootDirectory must be a directory" >&2
  exit 1
fi

# Root directory
rootDir="$1"

# Output file
outFile="$2"

# Delete output file if it exists already
if [ -f $outFile ] ; then
  rm $outFile
fi

echo "Processing directory tree ..."

# Write header fields to output file 
echo fileName,mimeTypeFile,matchFile > $outFile

# Record start time
start=`date +%s`

# This works for filenames that contain whitespace using code adapted from:
# http://stackoverflow.com/questions/7039130/bash-iterate-over-list-of-files-with-spaces/7039579#7039579

while IFS= read -d $'\0' -r file ; do
    # File basename (used as filename hint by Tika in -H option)
    # In production workflow bName could be read from metadata, in case actual file doesn't have original name/extension 
    bName=$(basename "$file")
    #mimeTypeFile=$(file --mime-type "$file" | cut -d':' -f2 | cut -d' ' -f2)
    mimeTypeFile=$(file "$file")
    
    if [ "$mimeTypeFile" == "application/octet-stream" ]
    then
        matchFile=0
    else
        matchFile=1
    fi

    echo $file,$mimeTypeFile,$matchFile >> $outFile
done < <(find $rootDir -type f -name '*.dd' -print0)
 
# Record end time
end=`date +%s`

runtime=$((end-start))

echo "Running time for processing directory tree:" $runtime "seconds"
