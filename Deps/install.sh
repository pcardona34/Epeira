#!/bin/bash

####################################################
### AGNoStep Apps
### (c) 2026 Patrick Cardona
###
### Thanks for the GNUstep Developers Community
### This is Free and Open Source software.
### Read License in the root directory.
####################################################

####################################################
### Install Dependencies
####################################################

#############################################
### Functions

function install_deps
{
### Use: LIST="name" && install_deps

### ARGS
##################################
REF="${LIST}"
OPTIONS="--no-show-upgraded --no-upgrade --yes"
STR="Installing Dependencies"
prefix="#"
local STATUS=0
STRING=""
###################################
	
if [ -z ${REF} ];then
	echo -e "\nSyntax: LIST=\"name\" && install_deps\n"
	echo -e "Where 'name' should be the related app name (lowercase).\n"
	exit 1
fi
	   
which -s apt
if [ $? -ne 0 ];then
	echo -e "\nSorry. A Debian System was expected.\n"
	exit 1
fi

. /etc/os-release

FILE="./dep_${REF}_debian_${VERSION_ID}.txt"	
if ! [ -f $FILE ];then
	echo -e "\nALERT! The dependency file ${FILE} was not found. Aborting.\n"
	exit 1
fi

while read DEP
do
if [ -z "$DEP" ];then
	# This line is empty...
	continue
fi
echo "$DEP" | grep -e "$prefix" &>/dev/null
if [ $? -eq 0 ];then
	# This line is commented out...
	continue
else
	STRING="${DEP} ${STRING}"
fi
done < $FILE

if [ ! -z "STRING" ];then
	sudo apt-get ${OPTIONS} install ${STRING}
	if [ $? -ne 0 ];then
		echo -e "\nERROR: a dependency was not resolved.\nAborting!!!\n"
		echo -e "\nYou must resolve this dependency trap.\nSee and fix ${FILE}. Then execute again:\n\n\t ${0}\n\n"
		exit 1
	else
		echo -e "\nDone.\n"
	fi
else
	echo -e "\nALERT: The dependency list was empty.\n"
	echo -e "You must check ${FILE}.\n"
	exit 1
fi

}

####################################################
### Dep with Renaissance
function check_renaissance
{
STR="Dependencies: Renaissance"
	
clear
echo -e "\n=== ${STR} ===\n"

### Framework Renaissance
LIBS=$(gnustep-config --variable=GNUSTEP_LOCAL_LIBRARIES)
APPREN=GSMarkupBrowser
STR="Checking Renaissance Framework"

echo -e "\n=== ${STR} ===\n"	

openapp --find "${APPREN}"
if [ $? -eq 0 ];then
    echo -e "\n(i) ${APPREN} was found.\n";sleep 1
else
    echo -e "\nALERT:  Framework Renaissance must be installed first!\n";sleep 4
    exit 1
fi

if [ -f ${LIBS}/libRenaissance.so ];then
    echo -e "\n(i) Framework Renaissance  was found: ok\n";sleep 2
else
    echo -e "\nALERT: Framework Renaissance must be installed first!\n";sleep 4
    exit 1
fi
}
### End of functions
################################################

clear
check_renaissance || exit 1
LIST="epeira" && install_deps || exit 1
