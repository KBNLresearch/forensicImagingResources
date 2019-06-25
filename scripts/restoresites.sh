#!/bin/bash
#
# Generate CSV of url and root dir pairs from httpd.conf config file
#
confFile="/home/johan/ownCloud/xxLINK/httpd-cleaned.conf"

foundurl=false
founddirectory=false
prefix="/htbin/htimage"

while IFS= read -r line
    do

    if [[ $line == "ServerRoot"* ]]; then
        serverrroot="$(awk -F '[[:blank:]]+' '{print $2}' <<< $line )"
        #echo $serverrroot
    fi

    if [[ $line == "MultiHost"* ]]; then
        # Indicates start of new site definition
        foundurl=true
        url="$(awk -F '[[:blank:]]+' '{print $2}' <<< $line )"
        #echo $url
    fi

    if [[ $line == "Map"* ]]; then
        mapPath="$(awk -F '[[:blank:]]+' '{print $3}' <<< $line )"
        if [[ $mapPath != "/noproxy.htm" ]]; then
            directory=$mapPath
            founddirectory=true
            #echo $directory
        fi
    fi

    if [[ $foundurl == "true" && $founddirectory == "true" ]]; then
        echo $url,$directory
        foundurl=false
        founddirectory=false
    fi


done < "$confFile"

