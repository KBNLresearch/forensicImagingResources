#!/bin/bash
#
# Extract contents of a tape. Each session on the tape is extracted as a separate file.
#
# Script must be executed as root (sudo)
#

# **************
# Functions
# **************

findBlocksize ()
{   # Find block size for this session

    # Initial block size
    bSize=512
    # Flag that indicates block size was found
    bSizeFound=false

    while [ $bSizeFound == "false" ]
    do
        # Try reading 1 block from tape
        echo "*** Guessing block size for session # "$index", trial value "$bSize" ***" >> $logFile
        dd if=$TAPEnr of=/dev/null bs=$bSize count=1 >> $logFile 2>&1
        ddStatus=$?
        # Position tape 1 record backward (i.e. to the start of this session)
        mt -f $TAPEnr bsr 1 >> $logFile 2>&1
        if [[ $ddStatus -eq 0 ]]; then
            # dd exit status 0: block size found
            bSizeFound=true
        else
            # dd exit status not 0, try again with larger block size
            let bSize=$bSize+512
        fi
    done
}

processSession ()
{   # Process one session

    # Determine block size for this session
    findBlocksize
    echo "*** Block size = "$bSize" ***" >> $logFile

    # Name of output file for this session
    ofName=$dirOut/"session"`printf "%06g" $index`.dd

    echo "*** Processing session # "$index" ("$ofName") ***" >> $logFile
    # Note 1: conv=sync flag can result in padding bytes if block size is too
    # large, so disabled for now
    # Note 2: conv=noerror flag causes infinite loop when reading beyond last
    # session on tape, so disabled that as well!
    #dd if=$TAPEnr of=$ofName bs=$bSize conv=noerror,sync >> $logFile 2>&1
    dd if=$TAPEnr of=$ofName bs=$bSize >> $logFile 2>&1
    ddStatus=$?
    echo "*** dd exit code = " $ddStatus" ***" >> $logFile
 
    # Increase index
    let index=$index+1

    # Try to position tape 1 record forward; if this fails this means
    # the end of the tape was reached
    mt -f $TAPEnr fsr 1 >> $logFile 2>&1
    mtStatus=$?

    if [[ $mtStatus -eq 0 ]]; then
        # Another session exists. Position tape one record backward
        mt -f $TAPEnr bsr 1 >> $logFile 2>&1
    else
        # No further sessions, end of tape reached
        echo "*** Reached end of tape ***" >> $logFile
        endOfTape=true
    fi
}

main ()
{   # Main function

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
    mt -f $TAPEnr status >> $logFile

    # Iterate over all sessions on tape until end is detected
    while [ $endOfTape == "false" ]
    do
        # Process one session
        processSession
    done

    # Create checksum file
    workDir=$PWD
    cd $dirOut
    checksumFile=$prefix.sha512
    sha512sum *.dd > $checksumFile
    cd $workDir
    echo "*** Created checksum file ***" >> $logFile

    # Rewind and eject the tape
    echo "*** Rewinding tape ***" >> $logFile
    mt -f $TAPEnr rewind >> $logFile 2>&1
    echo "*** Ejecting tape ***" >> $logFile
    mt -f $TAPEnr eject >> $logFile 2>&1

    # Write end date/time to log
    dateEnd=$(date)
    echo "*** End date/time "$dateEnd" ***" >> $logFile
}

main
