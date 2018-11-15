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

getUserInputGUI ()
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

    # Fill flag to lowercase (yad/getopts compatibility)
    fill=$(echo "$fill" | tr '[:upper:]' '[:lower:]')
}

getUserInputCLI ()
{   # Get user input through command-line interface
    OPTIND="1"
    echo "--- CLI function ---"
    # Optional arguments
    while getopts ":h:fd:b:s:p:e:" opt; do
        case "$opt" in
            h)
                show_help
                exit 0
                ;;
            f)  fill="true"
                ;;
            d)  tapeDevice="$OPTARG"
                ;;
            b)  blockSize="$OPTARG"
                ;;
            s)  sessions="$OPTARG"
                ;;
            p)  prefix="$OPTARG"
                ;;
            e)  extension="$OPTARG"
                ;;
            *)
                show_help >&2
                exit 1
                ;;
        esac
    done
    shift "$((OPTIND-1))"

    # Positional arguments
    # dirOut, normalise to absolute path
    dirOut="$(readlink -f $1)"

    echo $dirOut
    
    # Check command line args
    if [ "$#" -ne 1 ] ; then
        show_help
        exit 1
    fi
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
        echo "# Guessing block size for session # ""$session"", trial value ""$bSize" | tee -a "$logFile"
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
        echo "# Block size = ""$bSize" | tee -a "$logFile"

        # Name of output file for this session
        ofName="$dirOut"/""$prefix""`printf "%06g" "$session"`."$extension"

        echo "# Extracting session # ""$session"" to file ""$ofName" | tee -a "$logFile"

        if [ "$fill" = "true" ] ; then
            # Invoke dd with conv=noerror,sync options
            dd if="$tapeDevice" of="$ofName" bs="$bSize" conv=noerror,sync >> "$logFile" 2>&1
        else
            dd if="$tapeDevice" of="$ofName" bs="$bSize" >> "$logFile" 2>&1
        fi

        ddStatus="$?"
        echo "# dd exit code = " "$ddStatus" | tee -a "$logFile"
    else
        # Fast-forward tape to next session
        echo "# Skipping session # ""$session"", fast-forward to next session" | tee -a "$logFile"
        mt -f "$tapeDevice" fsf 1 >> "$logFile" 2>&1
    fi

    # Try to position tape 1 record forward; if this fails this means
    # the end of the tape was reached
    mt -f "$tapeDevice" fsr 1 >> "$logFile" 2>&1
    mtStatus="$?"
    echo "# mt exit code = " "$mtStatus" | tee -a "$logFile"

    if [[ "$mtStatus" -eq 0 ]]; then
        # Another session exists. Position tape one record backward
        mt -f "$tapeDevice" bsr 1 >> "$logFile" 2>&1
    else
        # No further sessions, end of tape reached
        echo "# Reached end of tape" | tee -a "$logFile"
        endOfTape="true"
    fi
}

processTape ()
{
    # Process a tape

    # Write some general info to log file
    echo "# Tape extraction log" | tee -a "$logFile"
    dateStart="$(date)"
    echo "# Start date/time ""$dateStart" | tee -a "$logFile"
    echo "# User input" | tee -a "$logFile"
    echo "# dirOut = ""$dirOut" | tee -a "$logFile"
    echo "# fill = ""$fill" | tee -a "$logFile"
    echo "# tapeDevice = ""$tapeDevice" | tee -a "$logFile" 
    echo "# blockSize = ""$blockSize" | tee -a "$logFile"
    echo "# sessions = ""$sessions" | tee -a "$logFile"
    echo "# prefix = ""$prefix" | tee -a "$logFile"
    echo "# extension = ""$extension" | tee -a "$logFile"

    # Check if block size is valid (i.e. a multiple of 512) by comparing integer
    # division of blockSize by 512 against floating-point division
    blocksInt=$(($blockSize / 512))
    blocksFloat=$(echo "$blockSize/512" | bc -l )
    # This yields 1 if block size is valid, and 0 otherwise 
    blocksizeValid=$(echo "$blocksInt == $blocksFloat" |bc -l)

    if ! [ "$blocksizeValid" -eq 1 ] ; then
        echo "# ERROR: invalid blockSize, must be a multiple of 512!" | tee -a "$logFile"
    f
        exit 1
    fi

    if [ "$fill" = "TRUE" ] ; then
        # dd's conv=sync flag results in padding bytes for each block if block 
        # size is too large, so override user-defined value with default
        # if -f flag was used
        blockSize=512
        echo "# Reset blockSize to 512 because -f flag is used " | tee -a "$logFile"
    fi

    # Flag that indicates end of tape was reached
    endOfTape="false"
    # Session index
    session="1"

    # Get tape status, output to log file
    echo "# Tape status" | tee -a "$logFile"
    mt -f "$tapeDevice" status | tee -a "$logFile"

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

    # Create checksum file
    workDir="$PWD"
    cd "$dirOut"
    checksumFile="$prefix"".sha512"
    sha512sum *."$extension" > "$checksumFile"
    cd "$workDir"
    echo "# Created checksum file" | tee -a "$logFile"

    # Rewind and eject the tape
    echo "# Rewinding tape" | tee -a "$logFile"
    mt -f "$tapeDevice" rewind 2>&1 | tee -a "$logFile"
    echo "# Ejecting tape" | tee -a "$logFile"
    mt -f "$tapeDevice" eject 2>&1 | tee -a "$logFile"

    # Write end date/time to log
    dateEnd="$(date)"
    echo "# End date/time ""$dateEnd" | tee -a "$logFile"
}

processTest ()
{
    # Test function

    # Write some general info to log file
    echo "# Tape extraction log" | tee -a "$logFile"
    dateStart="$(date)"
    echo "# Start date/time ""$dateStart" | tee -a "$logFile"
    echo "# Command-line arguments" | tee -a "$logFile"
    echo "dirOut = ""$dirOut" | tee -a "$logFile"
    echo "fill = ""$fill" | tee -a "$logFile"
    echo "tapeDevice = ""$tapeDevice" | tee -a "$logFile" 
    echo "blockSize = ""$blockSize" | tee -a "$logFile"
    echo "sessions = ""$sessions" | tee -a "$logFile"
    echo "prefix = ""$prefix" | tee -a "$logFile"
    echo "extension = ""$extension" | tee -a "$logFile"

    counter=1
    stop="false"
    while [ $stop == "false" ]
    do
        echo "# Loop number ""$counter" | tee -a "$logFile"
        sleep 0.5
        let counter=$counter+1
        if [ $counter == 10 ] ; then
            stop="true"
        fi
    done
}

# **************
# Main code
# **************

# Gui mode flag
GUIMode="false"

# Initialize user-defined variables
# Non-rewind tape device
tapeDevice="/dev/nst0"
# Initial block size
blockSize="512"
sessions=""
# Output prefix
prefix="session"
# Output extension
extension="dd"
fill="false"

# Set GUIMode switch to " true" if no command line args were given
if [ "$#" -ne 1 ] ; then
    GUIMode="true"
fi

echo "GUIMode = ""$GUIMode"

if [ "$GUIMode" = "true" ] ; then
    # Get user input through GUI
    getUserInputGUI
fi

if [ "$GUIMode" = "false" ] ; then
    # Get user input through CLI
    getUserInputCLI

    # Check if dirOut exists
    if ! [ -d "$dirOut" ] ; then
        echo "ERROR: dirOut must be a directory" >&2
        exit 1
    fi

    # Check if block size is valid (i.e. a multiple of 512) by comparing integer
    # division of blockSize by 512 against floating-point division
    blocksInt=$(("$blockSize" / 512))
    blocksFloat=$(echo "$blockSize/512" | bc -l )
    # This yields 1 if block size is valid, and 0 otherwise 
    blocksizeValid=$(echo "$blocksInt == $blocksFloat" |bc -l)

    if ! [ "$blocksizeValid" -eq 1 ] ; then
        echo "ERROR: invalid blockSize, must be a multiple of 512!" >&2
        exit 1
    fi
fi

# Log file
logFile="$dirOut""/readtape.log"

# Remove log file if it already exists
if [ -f "$logFile" ] ; then
    rm "$logFile"
fi

# Call main processing function. In GUI mode all logging output
# is redirected to a yad --progress window. Note that height of
# logging widget is limited due to bug in yad 0.38.2 (GTK+ 3.22.30),
# see https://bugzilla.redhat.com/show_bug.cgi?id=1479070

#if [ "$GUIMode" = "true" ] ; then
#    processTest | yad --progress \
#    --width=400 --height=300 \
#    --title="Tape extraction" \
#    --pulsate \
#    --enable-log \
#    --log-expanded \
#    --log-height=500 \
#    --scroll \
#    --auto-close \
#    --auto-kill \
#    --no-buttons

if [ "$GUIMode" = "true" ] ; then
    processTest | yad --text-info \
    --width=400 --height=300 \
    --title="Tape extraction" \
    --tail
    
    # Display notification when script has finished
    yad --text "Finished! \n\nLog written to file:\n\n""$logFile" \
    --button=gtk-ok:1
fi

if [ "$GUIMode" = "false" ] ; then
    # CLI mode
    processTest
    echo "Finished! Log written to file: ""$logFile"
fi
