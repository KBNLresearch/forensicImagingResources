#!/bin/bash
#
# Extract contents of a tape. Each session on the tape is extracted as a separate file.
#
# Script must be executed as root (sudo)
#

findblocksize ()
{ # A somewhat more complex function.
  # Initial block size
  bSize=512
  # Flag that indicates block size was found
  bSizeFound=false
  while [ $bSizeFound == "false" ]
  do
      # Try reading 1 block from tape
      echo "*** Guessing block size for session # "$index", trial value "$bSize" ***" >> $logFile
      #dd if=$TAPEnr of=/dev/null bs=$bSize count=1 >> $logFile 2>&1
      ddStatus=$?
      # Position tape 1 record backward (i.e. to the start of this session)
      #mt -f $TAPEnr bsr 1 >> $logFile 2>&1
      if [[ $ddStatus -eq 0 ]]; then
          # dd exit status 0: block size found
          bSizeFound=true
      else
          # dd exit status not 0, try again with larger block size
          let bSize=$bSize+512
      fi
  done
}


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

# Flag that indicates end of tape was reached
endOfTape=false
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

# Get tape status, output to log file
echo "*** Tape status ***" >> $logFile
#mt -f $TAPEnr status >> $logFile

# Process one session
while [ $endOfTape == "false" ]
do
    # Determine block size for this session
    findblocksize
    
    echo "*** Block size = "$bSize" ***" >> $logFile

    # Name of output file for this session
    ofName=$dirOut/"session"`printf "%06g" $index`.dd

    echo "*** Processing session # "$index" ("$ofName") ***" >> $logFile
    ddStatus=$?
    echo "*** dd exit code = " $ddStatus" ***" >> $logFile
 
    # Increase index
    let index=$index+1

    # Try to position tape 1 record forward; if this fails this means
    # the end of the tape was reached
    #mt -f $TAPEnr fsr 1 >> $logFile 2>&1
    mtStatus=$?

    if [[ $mtStatus -eq 0 ]]; then
        # Another session exists. Position tape one record backward
        #mt -f $TAPEnr bsr 1 >> $logFile 2>&1
        echo "*** Bogus ***" >> $logFile
    else
        # No further sessions, end of tape reached
        echo "*** Reached end of tape ***" >> $logFile
        endOfTape=true
    fi
done

