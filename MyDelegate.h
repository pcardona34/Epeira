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
### A Web Browser for GNUstep
### Application Controller interface: MyDelegate.h
####################################################
*/
   
#import <AppKit/AppKit.h>
#import <Renaissance/Renaissance.h>
#include <stdio.h>
#include <stdlib.h>
#include <unistd.h>
#include <sys/stat.h>
#import "PreferencesController.h"

@interface MyDelegate : NSObject <NSTextFieldDelegate>
{
  IBOutlet NSWindow *searchWindow;
  IBOutlet NSWindow *targetWindow;
  IBOutlet NSWindow *saveLinkWindow;
  IBOutlet NSTextField *motif;
  NSString *parentXID;
  // Previously in SaveLink
  IBOutlet id name;
  IBOutlet id link;
  IBOutlet id saveButton;
  IBOutlet id openLinkButton;
  IBOutlet id resetButton;
	
  NSFileManager *manager;
  PreferencesController *preferences;
}

- (IBAction) searchMotif: (id)sender;
- (void)applicationDidFinishLaunching: (NSNotification *) aNotification;
- (void) openSearch: (id) sender;
- (void) openHomePage: (id) sender;
- (NSString *) getHomePage;
- (void) setHomePage: (id) sender;
- (NSString *) getSearchPage;
- (void) setSearchPage: (id) sender;
- (NSString *) getUrlFromFile: (NSString *) pathFile;
- (void) openWithUrl: (NSString *) url;
- (void) saveAndOpenLink: (id) sender;
- (void)applicationWillTerminate: (NSNotification *)notification;
- (void) openSelectedUrl: (NSPasteboard*)pb 
	userData: (NSString*)ud
	   error: (NSString**)err;
- (void) keySim: (NSString *) key;
- (IBAction) zoomIn: (id)sender;
- (IBAction) zoomOut: (id)sender;
- (IBAction) goBack: (id)sender;
- (IBAction) goForward: (id)sender;
- (IBAction) searchIn: (id)sender;
- (IBAction) toggleDarkMode: (id)sender;
- (IBAction) openPreferences:(id)sender;
- (void) bookmark: (id) sender;

// Previously in SaveLink
- (void) textDidChange: (NSNotification *)notification;
- (void) openWithPath: (NSString *)pathFile;
- (IBAction) save: (id)sender;
- (IBAction) reset: (id)sender;
- (IBAction) open: (id)sender;
- (IBAction) newLink: (id)sender;
- (IBAction) showLink: (id)sender;
- (BOOL) checkDirectory: (NSString *) dir;
- (NSString*) favPath;

@end


