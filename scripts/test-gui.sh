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
        findBlocksize
        echo "*** Block size = ""$bSize"" ***" >> "$logFile"

        # Name of output file for this session
        ofName="$dirOut"/""$prefix""`printf "%06g" "$session"`."$extension"

        echo "*** Extracting session # ""$session"" to file ""$ofName"" ***" >> "$logFile"

        if [ "$fill" = "true" ] ; then
            # Invoke dd with conv=noerror,sync options
            dd if="$tapeDevice" of="$ofName" bs="$bSize" conv=noerror,sync >> "$logFile" 2>&1
        else
            dd if="$tapeDevice" of="$ofName" bs="$bSize" >> "$logFile" 2>&1
        fi

        ddStatus="$?"
        echo "*** dd exit code = " "$ddStatus"" ***" >> "$logFile"
    else
        # Fast-forward tape to next session
        echo "*** Skipping session # ""$session"", fast-forward to next session ***" >> "$logFile"
        mt -f "$tapeDevice" fsf 1 >> "$logFile" 2>&1
    fi

    # Try to position tape 1 record forward; if this fails this means
    # the end of the tape was reached
    mt -f "$tapeDevice" fsr 1 >> "$logFile" 2>&1
    mtStatus="$?"
    echo "*** mt exit code = " "$mtStatus"" ***" >> "$logFile"

    if [[ "$mtStatus" -eq 0 ]]; then
        # Another session exists. Position tape one record backward
        mt -f "$tapeDevice" bsr 1 >> "$logFile" 2>&1
    else
        # No further sessions, end of tape reached
        echo "*** Reached end of tape ***" >> "$logFile"
        endOfTape="true"
    fi
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

find $dirOut -name '*.jpg' 2>&1 | tee -a ${logFile} | yad --width=400 --height=300 \
    --title="Progress" \
    --form \
    --scroll
    --field="Progress":TXT \


#find $dirOut -name '*.jpg' 2>&1 | tee -a ${logFile} | yad --width=400 --height=300 \
#    --title="Doing stuff ..." --progress \
#    --pulsate --text="Doing stuff ..." \
#    --auto-kill \
#    --percentage=10

#     --auto-kill --auto-close \