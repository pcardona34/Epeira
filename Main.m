/* 
####################################################
### A G N o S t e p  -  Apps
### (c) 2026 - Patrick Cardona
### Author: Patrick Cardona
###
### Thanks for the GNUstep Developers Community.
### This application is free software.
### Read complete License in the root directory.
####################################################

####################################################
### Epeira.app
### A GNUstep Web Browser
### Main.m
####################################################
*/

#include <Foundation/Foundation.h>
#include <AppKit/AppKit.h>
#include "MyDelegate.h"

int main ( int argc, const char **argv )
{ 
  
CREATE_AUTORELEASE_POOL (pool);
MyDelegate *delegate;
[NSApplication sharedApplication];

delegate = [MyDelegate new];
[NSApp setDelegate: delegate];

#ifdef GNUSTEP
  [NSBundle loadGSMarkupNamed: @"Menu-GNUstep"  owner:delegate];
#else
  [NSBundle loadGSMarkupNamed: @"Menu-OSX"  owner:delegate];
#endif

RELEASE (pool);
return NSApplicationMain (argc, argv);

}

