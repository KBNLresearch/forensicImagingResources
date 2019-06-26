#!/bin/bash
#
# Restore sites from CSV file of domains and root dirs
#
inFile="/home/johan/ownCloud/xxLINK/sites-test.csv"
#configFile="/home/johan/ownCloud/xxLINK/xxlink.conf"
configFile="/home/johan/ownCloud/xxLINK/test.conf"
hostsFile="/home/johan/ownCloud/xxLINK/hosts"
prefix="www."
publishDir="/var/www"

while IFS= read -r line
    do

    if [[ $line == "domain,rootDir"* ]]; then
        echo "skipping header line"
    else
        url="$(cut -d',' -f1 <<<"$line")"
        rootDir="$(cut -d',' -f2 <<<"$line")"
        # SiteDir is 1 level above root (this is what needs to be copied over)
        siteDir=${rootDir%"root"}
        echo $siteDir
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
        echo -e "\t"DocumentRoot $rootDir  >> $configFile
        echo -e "\t""# Below line redirects DocumentRoot to home.htm" >> $configFile
        echo -e "\t"RedirectMatch ^/$ '"/home.htm"'  >> $configFile
        echo -e "\t"ErrorLog ${APACHE_LOG_DIR}/error.log  >> $configFile
        echo -e "\t"CustomLog ${APACHE_LOG_DIR}/access.log combined  >> $configFile
        echo "</VirtualHost>" >> $configFile
        echo >> $configFile

        # Add entry to hosts file
        echo -e 127.0.0.1	"\t"$url >> $hostsFile

        # Copy site data to publish dir TODO: verify if this works!!!
        cp -r $SiteDir $publishDir

        # Update permissions
        # TODO: siteDirName = $siteDir name (so strip path!)  
        find $publishDir/$siteDirName -type d -exec chmod 755 {} \;
        find $publishDir/$siteDirName -type f -exec chmod 666 {} \;

    fi

done < "$inFile"
