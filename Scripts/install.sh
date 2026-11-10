#!/bin/bash

####################################################
### AGNoStep Apps
### (c) 2026 Patrick Cardona
###
### Thanks for the GNUstep Developers Community
### This is Free and Open Source software.
### Read License in the root directory.
####################################################

################################
### Install Epeira Scripts
################################

################################
### VARS
PREFIX=epeira
STR="\n=== Dependencies: Scripts ===\n"
TARGET=/usr/local/bin

################################

clear
echo -e "${STR}"

### You must be superuser to install
sudo -v

for SCRIPT in xdo bookmark
do

if [ -f ${PREFIX}_${SCRIPT}.sh ];then
	echo -e "\n=== ${SCRIPT} ===\n"	
	chmod +x ${PREFIX}_${SCRIPT}.sh
	sudo cp --verbose --update ${PREFIX}_${SCRIPT}.sh ${TARGET}/${PREFIX}_${SCRIPT}.sh
	echo -e "Done.\n"
else 
	echo -e "ALERT! Script ${PREFIX}_${SCRIPT}.sh was not found!"
	exit 1
fi
done
