#!/bin/bash
#
# Restore sites from CSV file of domains and root dirs
#
inFile="/home/johan/ownCloud/xxLINK/sites.csv"
#configFile="/home/johan/ownCloud/xxLINK/xxlink.conf"
configFile="/home/johan/ownCloud/xxLINK/test.conf"
hostsFile="/home/johan/ownCloud/xxLINK/hosts"
prefix="www."
containerDir="/media/johan/WEBARCH/webarcheologie/xxLINK/extracted/tapes-DDS/2/file000001"
publishDir="/var/www"
#publishDir="/home/johan/ownCloud/xxLINK/www"

while IFS= read -r line
    do

    if [[ $line == "domain,rootDir"* ]]; then
        echo "skipping header line"
    else
        url="$(cut -d',' -f1 <<<"$line")"
        rootDir="$(cut -d',' -f2 <<<"$line")"
        # SiteDir is 1 level above root (this is what needs to be copied over)
        siteDir=${rootDir%"root"}
        # Name (without path) of siteDir
        siteDirName=$(rev <<<"$siteDir" | cut -d'/' -f2 | rev)
        if [[ $url == "www."* ]]; then
            # Remove www. prefix
            serverName=${url#$prefix}
        else
            serverName=$url
        fi

        echo $url
        echo $serverName
        echo $rootDir

        # Add VirtualHost entry to Apache config file
        echo >> $configFile
        echo "<VirtualHost *:80>" >> $configFile
        echo -e "\t"ServerName $serverName:80  >> $configFile
        echo -e "\t"ServerAdmin webmaster@localhost >> $configFile
        echo -e "\t"ServerName $serverName  >> $configFile
        echo -e "\t"ServerAlias $url  >> $configFile
        echo -e "\t"DocumentRoot $publishDir/$siteDirName/root >> $configFile
        echo -e "\t""# Below line redirects DocumentRoot to home.htm" >> $configFile
        echo -e "\t"RedirectMatch ^/$ '"/home.htm"'  >> $configFile
        echo -e "\t"ErrorLog \${APACHE_LOG_DIR}/error.log  >> $configFile
        echo -e "\t"CustomLog \${APACHE_LOG_DIR}/access.log combined  >> $configFile
        echo "</VirtualHost>" >> $configFile
        echo >> $configFile

        # Add entry to hosts file
        echo -e 127.0.0.1	"\t"$url >> $hostsFile

        # Copy site data to publish dir TODO: verify if this works!!!
        echo $containerDir$siteDir
        cp -r $containerDir/$siteDir $publishDir/

        # Update permissions
        # TODO: siteDirName = $siteDir name (so strip path!), test if this works!
        echo $publishDir/$siteDirName
        find $publishDir/$siteDirName -type d -exec chmod 755 {} \;
        find $publishDir/$siteDirName -type f -exec chmod 666 {} \;

    fi

done < "$inFile"
