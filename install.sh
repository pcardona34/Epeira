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
### Install Epeira
### A GNUstep Web Browser
################################

################################
### VARS
if [ -z "$DEBUG" ];then
     DEBUG="no" # values: "yes" to debug | "no" to use clean output
     # Should be set in the parent script
fi
STR="${PWD##*/}"
APP="${STR}"
SPIN='/-\|'
FIND="YES"

################################
### Functions

### Standard build
function _build
{
make clean &>/dev/null

if [ "$DEBUG" == "yes" ];then
     make && echo -e "Build done.\n"
     sudo LD_LIBRARY_PATH="$LD_LIBRARY_PATH" PATH="$PATH" -E make messages=yes ${INSTALL_ARGS} install && echo -e "Install done.\n"
else
     make &> $LOG &
     PID=$!
     spinner
     echo -e "\r- Build done"
     sleep 2
     sudo LD_LIBRARY_PATH="$LD_LIBRARY_PATH" PATH="$PATH" -E make messages=yes ${INSTALL_ARGS} install &>> $LOG &
     PID=$!
     spinner
     echo -e "\r- Install done"
fi

check "${APP}";sleep 2
make clean &>/dev/null
}

### Spinner
function spinner()
{
i=1
echo -n ' '
while [ -d /proc/$PID ]
do
	sleep 0.2
	printf "\b${SPIN:i++%${#SPIN}:1}"
done
}

### Remove App
function remove_ifx_app
{
APPNAME="$1"
if [ -z "$1" ];then
	exit 1
fi

DIR_APP=$(gnustep-config --variable=GNUSTEP_LOCAL_APPS)

if [ -d ${DIR_APP} ];then
    cd $DIR_APP || exit 1
    find . -name "${APPNAME}.app" -print | xargs sudo rm -r -f
    if [ $? -eq 0 ];then
    	printf "\t $APPNAME Bundle was removed.\n"
    fi
fi

DIR_TOOLS=$(gnustep-config --variable=GNUSTEP_LOCAL_TOOLS)

if [ -d ${DIR_TOOLS} ];then
    cd ${DIR_TOOLS} || exit 1
    find . -name "${APPNAME}*" -print | xargs sudo rm -f
    if [ $? -eq 0 ];then
	    printf "\t $APPNAME link was also removed.\n"
    fi
fi

echo -e "- (i) Purge was done.\n"
cd $_PWD
}

### Check App
function check
{
### VARS ENV
__PWD=`pwd`

if [ -z "$INSTALL_DIR" ];then
	INSTALL_DIR=$(gnustep-config --variable=GNUSTEP_LOCAL_APPS)
fi
ISSUES="https://github.com/pcardona34/agnostep-desktop/issues"

if ! [ -d $INSTALL_DIR ];then
	echo -e "\nALERT: $INSTALL_DIR was not found!\n"
	exit 1
fi

if [ -n "$1" ];then
	APP="$1"
else
	echo -e "\nALERT: The APP name is empty.\n"
	printf "Use:"
	echo -e "\n\t$0 <APP_NAME>\n"
	exit 1
fi

CHEMAPP=""
findapp ${APP}
if [ $? -eq 0 ] && [ -n "$CHEMAPP" ];then
	echo -e "\n(i) The application ${APP} has been found: ok.\n"
else
	echo -e "\nERROR! The application ${APP} was not found in ${INSTALL_DIR}.\nPlease, report this issue at:\n${ISSUES}\n"
	exit 1
fi

cd $__PWD
}


### Find app
function findapp
{
### VAR: APP is the exact APP_NAME without .app ext.
APP="$1"
if [ -n "$APP" ];then
	REP=$(openapp --find ${APP} | grep -e "Using")
	if [ $? -eq 0 ];then
		CHEM=$(echo ${REP} | awk '{print $3}')
		CHEMAPP=${CHEM%/${APP}}
	else
		CHEMAPP=""
	fi
else
	CHEMAPP=""
fi
}

################################
### You must be superuser to install
sudo -v

### Log
##################################
LOG=/var/log/agnostep-apps.log
if [ ! -f $LOG ];then
	sudo touch $LOG
	sudo chown ${USER}:${USER} $LOG
fi

date >> $LOG

### Misc
###################################
for MISC in Deps Scripts Helper Conf
do
	pushd .
	if [ -d ${MISC} ];then
		cd ${MISC}
		bash ./install.sh || exit 1
		sleep 2
	fi
	popd
done
		
### Build and Install the GNUstep app
clear

echo -e "\nDebug status: $DEBUG"
sleep 1

STR="Purge old release";
echo -e "\n=== ${STR} ===\n" 
pushd .
remove_ifx_app ${APP}
popd

sleep 2
clear
STR="Building and installing ${APP}"
echo -e "\n=== ${STR} ===\n" 
_build || exit 1

#################################################
### Service
clear
SERVICE="openURL"
STR="Service: $SERVICE"
echo -e "\n=== ${STR} ===\n" 

printf "Updating Services. Wait...\n"
make_services
echo -e "Done.\n"

echo -e "\n(i) All was done for ${APP} app and its service.\n"
sleep 2
