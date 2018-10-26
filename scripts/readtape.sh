#!/bin/bash
#
# Extract contents of a tape. Each session on the tape is extracted as a separate file.
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

# Normalise dirOut to absolute path
dirOut=$(readlink -f $2)

# Non-rewind tape device
TAPEnr=/dev/nst0

# Initial block size
bSize=512
bSize=4096
# Flag that indicates block size was found
bSizeFound=false
# Output file prefix
prefix=$1
# File index
index=1
# Flag that indicates end of tape was reached
endOfTape=false
logFile=$dirOut/$prefix.log

# Remove log file if it already exists
if [ -f $logFile ] ; then
    rm $logFile
fi

# Write some general info to log file
echo "*** Tape extraction log ***" >> $logFile
dateStart=$(date)
echo "*** Start date/time "$dateStart" ***" >> $logFile

# Get tape status, append output to log file
echo "*** Tape status ***" >> $logFile
mt -f $TAPEnr status >> $logFile 2>&1

# Determine the block size by trial and error
while [ $bSizeFound == "false" ]
do
    # Try reading 1 block from tape
    echo "*** Guessing block size, trial value "$bSize" ***" >> $logFile
    dd if=$TAPEnr of=/dev/null bs=$bSize count=1 >> $logFile 2>&1
    ddStatus=$?
    if [[ $ddStatus -eq 0 ]]; then
        # dd exit status 0: block size found
        echo "*** Block size found! ***" >> $logFile
        bSizeFound=true
    else
        # dd exit status not 0, try again with larger block size
        let bSize=$bSize+512
    fi
done
# Rewind the tape
mt -f $TAPEnr rewind

echo "*** Block size = "$bSize" ***" >> $logFile

# Create images of files on tape
while [ $endOfTape == "false" ]
do
    # Read subsequent files until dd exit status not 0
    ofName=$dirOut/"session"$prefix`printf "%06g" $index`.dd
    echo "*** Processing file # "$index" ("$ofName") ***" >> $logFile
    # Note: conv=sync flag can result in padding bytes if block size is too
    # large, so disabled for now
    #dd if=$TAPEnr of=$ofName bs=$bSize conv=noerror,sync >> $logFile 2>&1
    dd if=$TAPEnr of=$ofName bs=$bSize conv=noerror >> $logFile 2>&1
    ddStatus=$?
    if [[ $ddStatus -eq 0 ]]; then
        # Increase index 
        let index=$index+1
    else
        # dd exit status not 0, reached end of tape
        # TODO: we also end up here if anything else goes wrong with dd,
        # might need further refinement
        # Remove output file as it will be empty
        rm $ofName
        echo "*** Deleted "$ofName" (found end of tape) ***" >> $logFile
        endOfTape=true
    fi
done

# Create checksum file
workDir=$PWD
cd $dirOut
checksumFile=$prefix.sha512
sha512sum * > $checksumFile
cd $workDir
echo "*** Created checksum file ***" >> $logFile

dateEnd=$(date)
echo "*** End date/time "$dateEnd" ***" >> $logFile

# Rewind and eject the tape
mt -f $TAPEnr rewind
mt -f $TAPEnr eject