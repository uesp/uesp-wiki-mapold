#!/bin/sh
#
# Install script for the UESP map wiki extension. 
# 	Dave Humphrey (dave@uesp.net)
#	Created on 3 Jan 2014
#
# Run Format:
#
#	install.sh [path]
#
# ex:
#	install.sh /home/uesp/www/w/extensions/UespMap/
#
# When run it will copy the map source files from the install directory to the
# specified path, overwriting all existing files. 
#

NOW=$(date +"%Y%m%d%H%M%S")
BACKUPPATH="/tmp/backup-uespwikimap-$NOW"
SCRIPT=`readlink -e $0`
SCRIPTPATH=`dirname $SCRIPT`
INSTALLPATH=`readlink -f $1`

# Change the below to '-v' to display the files that rsync copies
VERBOSEOPT='-v'

if [ -z $INSTALLPATH ]; then
	echo "Error: Missing install path!"
	exit
fi

if [ $SCRIPTPATH == $INSTALLPATH ]; then
	echo "Error: Cannot install source onto itself!"
	exit
fi

if [ ! -d $INSTALLPATH ]; then
	echo "Error: Installation path does not exist!"
	exit
fi

echo "Installing UESP map wiki extension from $SCRIPTPATH to $INSTALLPATH."

while true; do
    read -p "Do you wish to continue (Y/N)?" input
    case $input in
        [Yy]* ) break;;
        [Nn]* ) exit;;
        * ) echo "    Please answer (Y)es or (N)o.";;
    esac
done

mkdir $BACKUPPATH

if [ -z $? ]; then
        echo "Error: Failed to create the backup path $BACKUPPATH!"
        exit
fi

rsync -acmI $VERBOSEOPT --compare-dest=$SCRIPTPATH/ --exclude='.hg*' $INSTALLPATH/ $BACKUPPATH/

if [ -z $? ]; then
        echo "Error: Failed to backup the existing map source to $BACKUPPATH!"
        exit
fi

echo "Backed up any old map source in the installation path to $BACKUPPATH."

rsync -acI $VERBOSEOPT --exclude='.hg*' --exclude='*.sh' $SCRIPTPATH/ $INSTALLPATH/

if [ -z $? ]; then
	echo "Error: There were one or more errors installing the UESP map source to $INSTALLPATH!"
	exit
fi

# Delete old files manually until I find a better way without risking
# removing something by accident.
rm -f $INSTALLPATH/dbmap_getmaplocs.php
rm -f $INSTALLPATH/dbmap_setmaplocs.php
rm -f $INSTALLPATH/simap_getmaplocs.php
rm -f $INSTALLPATH/simap_setmaplocs.php
rm -f $INSTALLPATH/obmap_getmaplocs.php
rm -f $INSTALLPATH/obmap_setmaplocs.php
rm -f $INSTALLPATH/srmap_getmaplocs.php
rm -f $INSTALLPATH/srmap_setmaplocs.php
rm -f $INSTALLPATH/mwmap_getmaplocs.php
rm -f $INSTALLPATH/mwmap_setmaplocs.php

echo "Finished installing the UESP map wiki extension to $INSTALLPATH."

