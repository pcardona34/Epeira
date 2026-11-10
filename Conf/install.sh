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
### Install Epeira Conf
### CSS default style
################################

################################
### VARS
STR="=== Default Style Sheet ==="
SRC_CSS=CONF/surf_default.css
DIR_DEST=$HOME/.surf/styles
#################################

clear
echo -e "\n${STR}\n"

if  [ ! -d $DIR_DEST ];then
     mkdir -p $DIR_DEST
fi

if [ -f ${DIR_DEST}/default.css ];then
    echo "Already done."
else 
	cp --verbose --update ${SRC_CSS} ${DIR_DEST}/default.css
	echo "Done."
fi
echo -e "\n"

