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
### Preferences Controller implementation
####################################################
*/

/* PreferencesController implementation */

#import <AppKit/AppKit.h>
#import "PreferencesController.h"

@implementation PreferencesController

- (instancetype) init 
{
    if ((self = [super init])) 
      {
        // Preferences Panel to set the favorite path default
        [NSBundle loadGSMarkupNamed: @"PreferencesPanel" owner:self];
        NSLog(@"PreferencesPanel has been loaded. Not yet visible.");
        
        // Localized Favorites Name
      	 localizedFavoriteName = [self getLocalizedFavoriteName];
        // Load saved value (or default)
        NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
        NSString *favoriteDef = [defs stringForKey:@"FavoriteFolder"];
        if (! favoriteDef || [favoriteDef length] == 0) {
        	[favoriteFolder setStringValue: localizedFavoriteName];
        	}
		else {
           [favoriteFolder setStringValue: favoriteDef];
           }
    }
return self;
}

- (NSString *) getLocalizedFavoriteName
{
  // LANG prefix?
  NSArray *languages = [[NSUserDefaults standardUserDefaults]   
              stringArrayForKey:@"NSLanguages"];  
  NSString *firstLanguage = [languages firstObject];  
  NSString *languagePrefix = [[firstLanguage substringToIndex: 2] lowercaseString];
  
  // Favorites Folder Name?
  NSString *favFolder = [[NSString alloc] init];
  NSArray *items;
  items = [NSArray arrayWithObjects: @"fr", @"en", nil];
  NSInteger item = [items indexOfObject: languagePrefix];
  switch (item) {
    case 0:
       favFolder = @"Favoris";
       break;
    case 1:
       favFolder = @"Favorites";
       break;
    default:
       favFolder = @"Favorites";
   }
	return favFolder;
}

- (IBAction) showPreferences:(id)sender
{
    // Display the Panel
    [preferencesPanel makeKeyAndOrderFront:nil];
    [NSApp activateIgnoringOtherApps:YES]; // bring app to front so window is visible
    NSLog(@"PreferencesPanel is now visible.");
}

- (IBAction) savePreferences:(id)sender
{
    NSString *favoriteDef = [[favoriteFolder stringValue] copy];
    if (! favoriteDef || [favoriteDef length] == 0) {
    	NSAlert *alert = [[[NSAlert alloc] init] autorelease];
    	[alert setMessageText: @"Bad Preference setting"];
    	[alert setInformativeText: @"You must set a non empty string."];
    	[alert runModal];
    	}
	else {
		
		NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
    	[defs setObject: favoriteDef forKey:@"FavoriteFolder"];
       [defs synchronize];
    	[preferencesPanel orderOut:nil];
    	NSLog(@"Preferences updated.");
		}    	    	
}

- (IBAction) cancelPreferences:(id)sender 
{
    [preferencesPanel orderOut:nil];
}

@end
