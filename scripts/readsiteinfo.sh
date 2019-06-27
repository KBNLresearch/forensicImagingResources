#!/bin/bash
#
# Generate CSV of url and root dir pairs from httpd.conf config file
#
confFile="/home/johan/ownCloud/xxLINK/httpd-cleaned.conf"

foundurl=false
founddirectory=false
prefix="/htbin/htimage"
suffix="\/*.map"

echo "domain","rootDir"

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
            # Remove prefix, suffix
            directory=${mapPath#$prefix}
            directory=${directory%$suffix}
            founddirectory=true
            echo $url,$directory
            foundurl=false
            founddirectory=false
            #echo $directory
        fi
    fi

done < "$confFile"

