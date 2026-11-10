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
### Preferences Controller interface
####################################################
*/

/* PreferencesController.h */

#import <AppKit/AppKit.h>
#import <Renaissance/Renaissance.h>

@interface PreferencesController : NSObject

{    
  NSPanel *preferencesPanel;    
  IBOutlet NSTextField *favoriteFolder;
  IBOutlet NSButton *saveButton;
  IBOutlet NSButton *cancelButton;
  NSString *localizedFavoriteName;
}

- (instancetype) init;
- (IBAction) showPreferences: (id)sender;
- (IBAction) savePreferences: (id)sender;
- (IBAction) cancelPreferences: (id)sender;
- (NSString *) getLocalizedFavoriteName;

@end