####################################################
### A G N o S t e p  -  Desktop
### (c) 2026 - Patrick Cardona
### Author: Patrick Cardona
###
### Thanks for the GNUstep Developers Community.
### This application is free software.
### Read complete License in the root directory.
####################################################

####################################################
### Epeira 
### A GNUstep Web Browser
####################################################

#
# GNUmakefile
#

include $(GNUSTEP_MAKEFILES)/common.make

#
# Application
#
VERSION = 0.1
PACKAGE_NAME = Epeira
APP_NAME = Epeira
Epeira_APPLICATION_ICON = Epeira.png

#
# Resource files
#
Epeira_RESOURCE_FILES = \
Resources/Info-gnustep.plist \
Resources/Epeira.png \
Resources/Search.tiff \
Resources/FileIcon_url.tiff \
Resources/FileIcon_.html.tiff \
Resources/Menu-GNUstep.gsmarkup \
Resources/Menu-OSX.gsmarkup \
Resources/SearchWindow.gsmarkup \
Resources/TargetWindow.gsmarkup \
Resources/SaveLinkWindow.gsmarkup \
Resources/PreferencesPanel.gsmarkup

#
# Header files
#
Epeira_HEADER_FILES = \
MyDelegate.h \
PreferencesController.h

#
# Objective-C Class files
#
Epeira_OBJC_FILES = \
MyDelegate.m \
PreferencesController.m

#
# Other sources
#
Epeira_OBJC_FILES += \
Main.m

# Localization
Epeira_LANGUAGES = English French
Epeira_LOCALIZED_RESOURCE_FILES= \
InfoPlist.strings \
SearchWindow.strings \
Menu-GNUstep.strings \
Menu-OSX.strings \
SaveLinkWindow.strings \
PreferencesPanel.strings \
Localizable.strings \
Epeira.help

#
#  Lib Renaissance
#
ifeq ($(FOUNDATION_LIB), apple)
  ADDITIONAL_INCLUDE_DIRS += -framework Renaissance
  ADDITIONAL_GUI_LIBS += -framework Renaissance
else
  ADDITIONAL_GUI_LIBS += -lRenaissance
endif

#
# Makefiles
#
include $(GNUSTEP_MAKEFILES)/application.make
