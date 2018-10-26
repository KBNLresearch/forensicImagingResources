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
bSize=4096
#bSize=512
# Flag that indicates block size was found
bSizeFound=false
# Output file prefix
prefix=$1
# File index
index=1
logFile=$dirOut/$prefix.log

# Remove log file if it already exists
if [ -f $logFile ] ; then
    rm $logFile
fi

# Write some general info to log file
echo "*** Tape extraction log ***" >> $logFile
dateStart=$(date)
echo "*** Start date/time "$dateStart" ***" >> $logFile

# Forward tape to EOM (this way we can use mt status
# to determine the number of files/sessions)
sudo mt -f $TAPEnr eom

# Get tape status, output to array (split at newline)
IFS=$'\n' tapeStatus=$(mt -f $TAPEnr status)
echo "*** Tape status ***" >> $logFile

# Parse status output (actualy we only need fileNumber)
for item in ${tapeStatus[*]}
do
    echo $item >> $logFile
    if [[ $item == *"drive type"* ]]; then
        # Split at equal sign, 2nd item is value
        tmp=$(echo $item | cut -f2 -d=)
        # Strip whitespace
        driveType="$(echo -e "${tmp}" | tr -d '[:space:]')"
    fi

    if [[ $item == *"drive status"* ]]; then
        tmp=$(echo $item | cut -f2 -d=)
        driveStatus="$(echo -e "${tmp}" | tr -d '[:space:]')"
    fi

    if [[ $item == *"sense key error"* ]]; then
        tmp=$(echo $item | cut -f2 -d=)
        senseKeyError="$(echo -e "${tmp}" | tr -d '[:space:]')"
    fi

    if [[ $item == *"residue count"* ]]; then
        tmp=$(echo $item | cut -f2 -d=)
        residueCount="$(echo -e "${tmp}" | tr -d '[:space:]')"
    fi

    if [[ $item == *"file number"* ]]; then
        tmp=$(echo $item | cut -f2 -d=)
        fileNumber="$(echo -e "${tmp}" | tr -d '[:space:]')"
    fi

    if [[ $item == *"block number"* ]]; then
        tmp=$(echo $item | cut -f2 -d=)
        blockNumber="$(echo -e "${tmp}" | tr -d '[:space:]')"
    fi
done

# Rewind the tape
mt -f $TAPEnr rewind

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
for i in $(seq 1 $fileNumber)
do
    ofName=$dirOut/"session"`printf "%06g" $index`.dd
    echo "*** Processing file # "$index" ("$ofName") ***" >> $logFile
    # Note 1: conv=sync flag can result in padding bytes if block size is too
    # large, so disabled for now
    # Note 2: conv=noerror flag causes infinite loop when reading beyond last
    # session on tape, so disabled that as well!
    #dd if=$TAPEnr of=$ofName bs=$bSize conv=noerror,sync >> $logFile 2>&1
    #dd if=$TAPEnr of=$ofName bs=$bSize conv=noerror >> $logFile 2>&1
    #dd if=$TAPEnr of=$ofName bs=$bSize >> $logFile 2>&1
    dd if=$TAPEnr of=$ofName bs=$bSize >> $logFile 2>&1
    ddStatus=$?
    echo "*** dd exit code = " $ddStatus" ***" >> $logFile
    # Increase index 
    let index=$index+1
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