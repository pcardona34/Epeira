#!/bin/bash

####################################################
### AGNoStep Apps
### (c) 2026 - Patrick Cardona
### Author: Patrick Cardona
###
### Thanks for the GNUstep Developers Community.
### This application is free software.
### Read complete License in the root directory.
####################################################

####################################################
### Install Epeira Helper
### A socket to embed Surf Web Browse
####################################################

### VARS
####################################################
STR="Epeira Socket Helper"
####################################################

clear
echo -e "\n=== ${STR} ===\n"

printf "Building...\n"
make clean &>/dev/null
make || exit 1
echo -e "Done.\n"

printf "Installing...\n"
sudo -E make install
echo -e "Done.\n"

make clean &>/dev/null

echo -e "\nAll was done for ${STR}.\n"

