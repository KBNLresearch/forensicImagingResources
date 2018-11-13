#!/bin/bash
#
# Extract contents of a tape. Each session on the tape is extracted as a separate file.
#
# Script must be executed as root (sudo)
#

# **************
# Functions
# **************

show_help ()
{ # Show help message
cat << EOF
Usage: ${0##*/} [-h] [-f] [-d device] [-b blockSize] [-s sessions]
                [-p prefix] [-e extension] dirOut

Read contents of tape. Each session is stored as a separate file. 

positional arguments:

    dirOut          output directory

optional arguments:

    -h              display this help message and exit
    -f              fill blocks that give read errors with null bytes
    -d device       non-rewind tape device (default: /dev/nst0)
    -b blockSize    initial block size (must be a multiple of 512)
    -s sessions     comma-separated list of sessions to extract
    -p prefix       output prefix
    -e extension    output file extension

EOF
}

getUserInput ()
{   # Get user input through GUI dialog
    userInput=$(yad --width=400 --title="Read tape" \
    --form \
    --field="Output Directory":DIR "$DIR" \
    --field="Tape Device" "$tapeDevice" \
    --field="Initial Block Size":NUM "$blockSize"[!"$blockSize"..10485760[!512![!0]]] \
    --field="Sessions" "$sessions" \
    --field="Prefix" "$prefix" \
    --field="Extension" "$extension" \
    --field="Fill failed blocks":CHK $fill \
    )
}

findBlocksize ()
{   # Find block size for this session

    # Initial block size
    bSize="$blockSize"
    # Flag that indicates block size was found
    bSizeFound="false"

    while [ "$bSizeFound" == "false" ]
    do
        # Try reading 1 block from tape
        echo "*** Guessing block size for session # ""$session"", trial value ""$bSize"" ***" >> "$logFile"
        dd if="$tapeDevice" of=/dev/null bs="$bSize" count=1 >> "$logFile" 2>&1
        ddStatus="$?"
        # Position tape 1 record backward (i.e. to the start of this session)
        mt -f "$tapeDevice" bsr 1 >> "$logFile" 2>&1
        if [[ "$ddStatus" -eq 0 ]]; then
            # dd exit status 0: block size found
            bSizeFound="true"
        else
            # dd exit status not 0, try again with larger block size
            let bSize="$bSize"+512
        fi
    done
}

processSession ()
{   # Process one session

    if [ "$extractSession" = "true" ] ; then
        # Determine block size for this session
        #findBlocksize
        echo "*** Block size = ""$bSize"" ***" | tee -a "$logFile"

        # Name of output file for this session
        ofName="$dirOut"/""$prefix""`printf "%06g" "$session"`."$extension"

        echo "*** Extracting session # ""$session"" to file ""$ofName"" ***" | tee -a "$logFile"

        if [ "$fill" = "true" ] ; then
            # Invoke dd with conv=noerror,sync options
            echo "bullsh, fill" | tee -a "$logFile"
            #dd if="$tapeDevice" of="$ofName" bs="$bSize" conv=noerror,sync 2>&1 | tee -a "$logFile"
        else
            echo "bullsh, nofill" | tee -a "$logFile"
            #dd if="$tapeDevice" of="$ofName" bs="$bSize" 2>&1 | tee -a "$logFile"
        fi

        ddStatus="$?"
        echo "*** dd exit code = " "$ddStatus"" ***" | tee -a "$logFile"
    else
        # Fast-forward tape to next session
        echo "*** Skipping session # ""$session"", fast-forward to next session ***" | tee -a "$logFile"
        echo "ffwd" | tee -a "$logFile"
        #mt -f "$tapeDevice" fsf 1 2>&1 | tee -a "$logFile"
    fi

    # Try to position tape 1 record forward; if this fails this means
    # the end of the tape was reached
    #mt -f "$tapeDevice" fsr 1 2>&1 | tee -a "$logFile"
    #mtStatus="$?"
    mtStatus=1
    # echo "*** mt exit code = " "$mtStatus"" ***" | tee -a "$logFile"

    if [[ "session" -eq 10 ]]; then
        # Another session exists. Position tape one record backward
        #mt -f "$tapeDevice" bsr 1 2>&1 | tee -a "$logFile"
        endOfTape="true"
    fi
}
processSessions ()
{
# Iterate over all sessions on tape until end is detected
while [ "$endOfTape" == "false" ]
do
    # Set initial value of extractSessionFlag depending on sessions parameter
    if [ -z "$sessions" ] ; then
        extractSession="true"
    else
        extractSession="false"
    fi

    # Only extract sessions defined by sessions parameter
    # (if session parameter is empty all sessions are extracted)
    for i in ${sessions//,/ }
        do
            if [ "$i" == "$session" ] ; then
                extractSession="true"
            fi
    done

    # Call session processing function 
    processSession

    # Increase session number
    let session="$session"+1
done
}

# **************
# Main code
# **************

# Initialize command line variables

# Non-rewind tape device
tapeDevice="/dev/nst0"
# Initial block size
blockSize="512"
sessions=""
# Output prefix
prefix="session"
# Output extension
extension="dd"
fill="FALSE"

# Get user input through GUI
getUserInput

# Parse yad output into variables
dirOut="$(cut -d'|' -f1 <<<$userInput)"
tapeDevice="$(cut -d'|' -f2 <<<$userInput)"
blockSize="$(cut -d'|' -f3 <<<$userInput)"
# Needed because yad adds ",0000" to numerical value, apparently this 
# fix is not needed with mthe most recent version of yad
blockSize="$(cut -d',' -f1 <<<"$blockSize")"
sessions="$(cut -d'|' -f4 <<<$userInput)"
prefix="$(cut -d'|' -f5 <<<$userInput)"
extension="$(cut -d'|' -f6 <<<$userInput)"
fill="$(cut -d'|' -f7 <<<$userInput)"

echo $dirOut
echo $blockSize

# Normalise dirOut to absolute path
dirOut="$(readlink -f "$dirOut")"

if ! [ -d "$dirOut" ] ; then
    echo "ERROR: dirOut must be a directory" >&2
    exit 1
fi

# Log file
logFile="$dirOut""/readtape.log"

# Remove log file if it already exists
if [ -f "$logFile" ] ; then
    rm "$logFile"
fi

endOfTape="false"

processSessions | yad --text-info \
    --width=400 --height=600 \
    --title="Progress" \
    --scroll


#while [ $stop == "false" ]
#do
#    # Process one session
#   find $dirOut -name '*.jpg' 2>&1 | tee -a $logFile | yad --text-info \
#   --width=400 --height=300 \
#    --title="Progress" \
#    --scroll
#
#    let counter=$counter+1
#
#    if [ $counter == 2 ] ; then
#        stop="true"
#    fi
#done


# Below adapted from https://unix.stackexchange.com/questions/188383/pipe-command-output-to-yad-and-also-log-the-output-to-a-logfile/188387#188387

#find $dirOut -name '*.jpg' 2>&1 | tee -a ${logFile} | yad --text-info --width=400 --height=300 \
#    --title="Doing stuff ..." --progress \
#    --pulsate --text="Doing stuff ..." \
#    --auto-kill \
#    --percentage=10

#     --auto-kill --auto-close \