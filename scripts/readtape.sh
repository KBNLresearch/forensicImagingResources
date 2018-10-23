#!/bin/bash
#
# Extract contents of a tape. Each file on the tape is extracted as a separate file.
#
# Dependencies:
#
# - mt
#
# Script must be executed as root (sudo)
#

# Tape device
TAPE=/dev/st0
# Non-rewind tape device
TAPEnr=/dev/nst0

# Get tape status, output to array (split at newline)
IFS=$'\n' tapeStatus=$(mt -f $TAPEnr status)

# Parse file number and block number from status output 
for item in ${tapeStatus[*]}
do
    if [[ $item == *"file number"* ]]; then
        # Split at equal sign, 2nd item is value
        tmp=$(echo $item | cut -f2 -d=)
        # Strip whitespace
        fileNumber="$(echo -e "${tmp}" | tr -d '[:space:]')"
        #echo $fileNumber
    fi

    if [[ $item == *"block number"* ]]; then
        # Split at equal sign, 2nd item is value
        tmp=$(echo $item | cut -f2 -d=)
        # Strip whitespace
        blockNumber="$(echo -e "${tmp}" | tr -d '[:space:]')"
        #echo $blockNumber
    fi

done

# TODO: status output probably not needed in the end,
# investigate later.

# Determine the block size by trial and error

# Initial block size
bSize=128

# Flag that indicates if block size was found
bSizeFound=false

while [ $bSizeFound == "false" ]
do
    # Try reading from tape
    dd if=$TAPEnr of=tmp.dd ibs=$bSize count=1
    ddStatus=$?
    if [[ $ddStatus -eq 0 ]]; then
        # dd exit status 0: block size found
        bSizeFound=true
    else
        # dd exit status not 0, try again with larger block size
        let bSize=$bSize*2
    fi
done

echo $bSize
echo $bSizeFound
echo $?

# Rewind the tape
mt -f $TAPEnr rewind

# Output file prefix
prefix=test
endOfTape=false
index=1

while [ $endOfTape == "false" ]
do
    # Read subsequent files until dd exit status not 0
    ofName=$prefix`printf "%06g" $index`.dd
    dd if=$TAPEnr of=$ofName ibs=$bSize
    ddStatus=$?
    if [[ $ddStatus -eq 0 ]]; then
        # Increase index 
        let index=$index+1
    else
        # dd exit status not 0, reached end of tape
        # TODO: we also end up here if anything else goes wrong with dd,
        # might need further refinement
        endOfTape=true
    fi
done