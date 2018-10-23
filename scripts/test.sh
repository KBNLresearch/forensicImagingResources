#!/bin/bash

endOfTape=false
index=1
ddStatus=0
prefix=test

while [ $endOfTape == "false" ]
do
    # Read subsequent files until dd exit status not 0
    ofName=$prefix`printf "%06g" $index`.dd
    echo $ofName
    #dd if=$TAPEnr of=$ofName ibs=$bSize
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

echo $bSizeFound