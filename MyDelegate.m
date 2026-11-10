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
### Application Controller implementation: MyDelegate.m
####################################################
*/

#import "MyDelegate.h"

@implementation MyDelegate: NSObject

/* Some code was previously within SaveLink application */

- (instancetype) init
{

if (( self = [super init] )){
  manager = [NSFileManager defaultManager];
  preferences = [[PreferencesController alloc] init];
  }
return self;
}

- (BOOL) checkDirectory: (NSString *) dir
{
  BOOL isDirectory;
  BOOL exists = [manager fileExistsAtPath: dir
                         isDirectory: &isDirectory];
  if (exists && isDirectory) {
    return YES;
  }else{
    return NO;
  }
}

- (NSString *) favPath
{
 // Retrieving UserName of the current User and then his homeDirectory
  NSString *userName = NSUserName();
  NSString *homeDir = NSHomeDirectoryForUser(userName);
  NSUserDefaults *defs = [NSUserDefaults standardUserDefaults];
  NSString *favoriteDef = [defs stringForKey:@"FavoriteFolder"];
  if ( ! favoriteDef || [favoriteDef length] == 0 ){
  		NSLog(@"Favorite Folder must be set. Abandon.");
  		[NSApp terminate:nil];
  		return nil; // this will never be executed 
  	}
  		
  NSString *favPath = [[homeDir stringByAppendingString: @"/"] 
	stringByAppendingString: favoriteDef];
   return favPath;
}

- (IBAction) save: (id)sender
{
  NSLog(@"We enter in Save Link method...");
  // We retrieve values from textFileds outlets
  // Also We trim spaces in the nameLink:
  NSString *nameLink = [[name stringValue] stringByReplacingOccurrencesOfString:@" " withString:@""];
  NSString *urlLink = [link stringValue];
  
  // Setting filePath
  NSString *ext = @".url";
  NSString *favPath = [[self favPath] stringByAppendingString: @"/"];
  NSLog(@"FavPath is: %@", favPath);
   
  // We check Favorites path
  if ([self checkDirectory: favPath]) {
            NSString *filePath = [[favPath 
            stringByAppendingString: nameLink] stringByAppendingString: ext];
      
  // Preparing the content to write
  NSString *content = [NSString stringWithFormat: @"[InternetShortcut]\nURL=%@\n", urlLink];
  // Writing to File Name.url
  NSError *error;
  BOOL success;

  success = [content writeToFile:filePath
                         atomically:YES
                           encoding:NSUTF8StringEncoding
                              error:&error];

  if (!success) {
    NSLog(@"Failed to write file: %@", [error localizedDescription]);
    [NSApp terminate: self];                   
   }

 NSLog(@"End of save action");
 [saveLinkWindow close];
 }
 else
 {
   NSLog(@"Path of Favorites not found!");
   NSAlert *alert = [[[NSAlert alloc] init] autorelease];
   [alert setMessageText: _(@"Path of Favorites not found!")];
   [alert setInformativeText: _(@"You should have a Favorites folder in your Home Directory.")];
   [alert runModal];
   [NSApp terminate:nil];
 }
}

- (IBAction) reset: (id)sender
{
  [link setStringValue:@""];
  [name setStringValue:@""];
  [saveButton setEnabled:NO];
  [openLinkButton setEnabled:NO];
  [name becomeFirstResponder];
}

- (IBAction) showLink: (id)sender
{
  [NSBundle loadGSMarkupNamed: @"SaveLinkWindow" owner: self];
	NSLog (@"SaveLink Window loaded.");
	// Register for notifications
  [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:NSControlTextDidChangeNotification
                                               object:name];
                                               
   [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(textDidChange:)
                                                 name:NSControlTextDidChangeNotification
                                               object:link];
		
}

- (IBAction) newLink: (id)sender
{
  [self showLink:nil];
  [self reset:nil];
}

- (IBAction) open:  (id)sender
{
  // Filter: we want only .url files to open
  //NSArray *fileType;
  //fileType = [NSArray arrayWithObjects: @"url", nil];
  // Open Panel
  NSOpenPanel *openPanel;
  openPanel = [[[NSOpenPanel alloc] init] autorelease];
  [openPanel setDirectory: [self favPath]];
  [openPanel setRequiredFileType: @"url"];
  if ([openPanel runModal] == NSOKButton) {
  		NSArray *selection;
  		selection = [openPanel filenames];
  		NSString *openPath = [selection firstObject];
  		if ([openPath length] > 0) {
    		[self showLink: nil];
  
    		// Getting the Name of the Link
    		NSString *nameLink = [[openPath lastPathComponent] 			
    			stringByDeletingPathExtension];
    		[name setStringValue: nameLink];
  
    		// Getting the Link value
    		NSString *content;
    		content = [NSString stringWithContentsOfFile: openPath];
           NSString *url =  [content substringFromIndex: 23];
           [link setStringValue: url];
           [saveButton setEnabled:YES];
           [openLinkButton setEnabled:YES];
        }
	     else {
			NSLog(@"Selection was aborted by User.");	
		}
  	}
}

// We handle the case of URLshortcut file: *.url or *.html
- (void) openWithPath: (NSString *)pathFile;
{
  NSLog(@"We enter in openWithPath method...");
  if ([pathFile hasSuffix: @".html"]) {
  	[self openWithUrl: pathFile];
  	}
  else{
    [self showLink: nil];
    [self reset: nil]; 
	
    // Get Name of the Link
    NSString *fileName = [[pathFile lastPathComponent] stringByDeletingPathExtension];
    [name setStringValue: fileName];
  
    // Get Link value
    NSString *content;
    content = [NSString stringWithContentsOfFile: pathFile];
    NSString *url =  [content substringFromIndex: 23];
    [link setStringValue: url];
  
    [saveButton setEnabled:YES];
    [self openWithUrl: url];
  }
}

- (void)textDidChange:(NSNotification *)notification
{
  // We retrieve values from textFileds outlets
  // NSLog(@"textDidChange called.");
  NSString *nameLink = [name stringValue];
  NSString *urlLink = [link stringValue];
  [saveButton setEnabled:([nameLink length] && [urlLink hasPrefix: @"http"])];
  [openLinkButton setEnabled:([nameLink length] && [urlLink hasPrefix: @"http"])];
}

- (IBAction) searchMotif: (id)sender
{
  if ( [[motif stringValue] length] > 0 ) {
    NSString *searchPage = [self getSearchPage];
    NSString *webSearch = [searchPage stringByAppendingString: @"/?q="];
    
    NSString *url = [webSearch stringByAppendingString: [[motif stringValue] lowercaseString]];
    
    [self openWithUrl: url];
    } 
}


- (void) openSearch: (id) sender
{
  [NSBundle loadGSMarkupNamed: @"SearchWindow" owner: self];
  [motif setTarget: self];
  [motif setAction: @selector(searchMotif:)];
  [motif becomeFirstResponder];
}

- (void) openHomePage: (id) sender
{
		NSString *url = [self getHomePage];
		[self openWithUrl: url]; 
}

- (NSString *) getHomePage
{
	BOOL homePageExists = NO;
	NSLog (@"Home page...");
	NSString *myFavoritesFolder = [self favPath];
	NSString *homePageShortLink = [myFavoritesFolder stringByAppendingString: @"MyHomePage.url"];
	homePageExists = [manager fileExistsAtPath: homePageShortLink];
	if (homePageExists){
		NSLog(@"You have got a homePage: %@", homePageShortLink);
		NSString *url = [self getUrlFromFile: homePageShortLink];
		return url;
	}else{
		NSLog(@"You have not set a Home Page: fall back to default: GNUstep dot Org.");
		return @"https://www.gnustep.org";
	}
}

- (NSString *) getSearchPage
{
	BOOL searchPageExists = NO;
	NSLog (@"Search page...");
	NSString *myFavoritesFolder = [self favPath];
	NSString *searchPageShortLink = [myFavoritesFolder stringByAppendingString: @"MySearchPage.url"];
	searchPageExists = [manager fileExistsAtPath: searchPageShortLink];
	if (searchPageExists){
		NSLog(@"You have got a searchPage: %@", searchPageShortLink);
		NSString *url = [self getUrlFromFile: searchPageShortLink];
		return url;
	}else{
		NSLog(@"You have not set a Search Page: fall back to default: DuckDuckGo.");
		return @"https://duckduckgo.com";
	}
}

- (void) openWithUrl: (NSString *) url
{
	NSLog(@"We enter in openWithUrl method...");
	NSLog(@"URL: %@", url); 
	[NSBundle loadGSMarkupNamed: @"TargetWindow" owner: self];
       void *ref = [targetWindow windowRef];
    	parentXID = [NSString stringWithFormat:@"%p", ref];

    	NSTask *bridge = [[NSTask alloc] init];
       [bridge setLaunchPath:@"/usr/local/bin/epeira_socket"];
       [bridge setArguments:[NSArray arrayWithObjects:
                                      parentXID, @"0", @"0", @"1200", @"900", url, nil]];
       [bridge launch];
}

- (void) openSelectedUrl: (NSPasteboard*)pb
	userData: (NSString*)ud
	   error: (NSString**)err
{
  NSLog(@"We enter in openSelectedUrl method...");
  NSString	*url;
  NSArray	*types;
  
  if (err != NULL)
    *err = nil;
  
  types = [pb types];
  if (![types containsObject: NSStringPboardType])
    {
      *err = @"No URL type supplied on pasteboard";
      return;
    }

  url = [pb stringForType: NSStringPboardType];
  if (url == nil)
    {
      *err = @"No URL supplied on pasteboard";
      return;
    }

  [self openWithUrl: url];
}



- (NSString *) getUrlFromFile: (NSString *) pathFile 
{
  NSString *content;
  content = [NSString stringWithContentsOfFile: pathFile];
  NSString *url =  [content substringFromIndex: 23];
  return url;	
}

- (void) setHomePage: (id) sender
{
	[self newLink: nil];
	[name setStringValue: @"MyHomePage"];
	[name setEditable: NO];
	NSString *homePageLink = [self getHomePage];
	[link setStringValue: homePageLink];
	[saveButton setEnabled: YES];
	[openLinkButton setEnabled: YES];
	[resetButton setEnabled: NO];
	[link becomeFirstResponder];
}

- (void) setSearchPage: (id) sender
{
	[self newLink: nil];
	[name setStringValue: @"MySearchPage"];
	[name setEditable: NO];
	NSString *searchPageLink = [self getSearchPage];
	[link setStringValue: searchPageLink];
	[saveButton setEnabled: YES];
	[openLinkButton setEnabled: YES];
	[resetButton setEnabled: NO];
	[link becomeFirstResponder];
}

- (void) saveAndOpenLink: (id) sender
{
	NSString *url = [link stringValue];
	[self openWithUrl: url];
	[self save: nil];
}

- (IBAction) openPreferences:(id)sender 
{    
  [preferences showPreferences: sender];
}

- (void) bookmark: (id) sender
{
	NSTask *task = [[NSTask alloc] init];
	[task setLaunchPath: @"/usr/bin/bash"];
	[task setArguments: [NSArray arrayWithObjects: @"/usr/local/bin/epeira_bookmark.sh",
	                             nil]];
	[task launch];
	//We prevent to load an old bookmarked URL
	[task waitUntilExit];
	
	NSString *userName = NSUserName();
	NSString *homeDirectory = NSHomeDirectoryForUser(userName);
	NSString *bookmarkPath = [homeDirectory stringByAppendingString: @"/.surf/bookmarks"];
	BOOL exists = [manager fileExistsAtPath: bookmarkPath];
	if (exists) {
	    NSString *thisUrl = [NSString stringWithContentsOfFile: bookmarkPath];
	    if ( [thisUrl length] > 0 ) {
	    	[self newLink: nil];
	    	[link setStringValue: thisUrl];
	    	NSLog(@"Bookmarked url was found and set.");	
	    	}
    	else {
    		NSLog(@"Bookmarked url was empty.");
    		}
	}
	else {
		NSLog(@"Bookmarks file: %@ was not found.", bookmarkPath);
	}
}


- (void) keySim: (NSString *) key
{
	NSLog(@"We simulate a Key: ctrl+%@", key);
	                         
	NSTask *sendKey = [[NSTask alloc] init];
       [sendKey setLaunchPath:@"/usr/local/bin/epeira_xdo.sh"];
       [sendKey setArguments:[NSArray arrayWithObjects:
                                      key,
										  nil]];
	    [sendKey launch];
}


- (IBAction) zoomIn: (id)sender
{ 
	[self keySim: @"K"];
}

- (IBAction) zoomOut: (id)sender
{
	[self keySim: @"J"];
}

- (IBAction) goBack: (id)sender
{
	[self keySim: @"h"];
}

- (IBAction) goForward: (id)sender
{
	[self keySim: @"l"];
}

- (IBAction) searchIn: (id)sender
{
	[self keySim: @"f"];
}

- (IBAction) toggleDarkMode: (id)sender
{
	[self keySim: @"D"];
}



- (void) applicationDidFinishLaunching: (NSNotification *) aNotification
{
  
  NSArray *arguments = [[NSProcessInfo processInfo] arguments];
  
  /* Check if there are any arguments passed: */
    if ([arguments count] > 1) { // if (1) begins
    	
        // Is the argument a key word, an URL or a favorite i.e. shortcut *.url?
      	 NSString *lastArgument = [arguments lastObject];
      	 if ([lastArgument hasSuffix: @".url"] || [lastArgument hasSuffix: @".html"]) { 
      	 	// if (2) begins
      	    	NSLog(@"We handle a favorite case: Internet Shortcut");
      	       	NSString *filePath = [arguments lastObject];
        		[self openWithPath: filePath];
      	 }
		else{
      	 		if ([lastArgument hasPrefix: @"http"]) { 
      	 			// if (3) begins
      	 			NSLog(@"We handle an URL");
      	 			NSString *url = [arguments lastObject];
      	 			[self openWithUrl: url];
      	 		}
				else{
      	 				NSLog(@"We handle a Key Word  search");
        				NSString *mot = [arguments lastObject]; 
        				// The last argument is the motif
        				[motif setStringValue: mot];
                   		[self searchMotif: nil];
      	 		} // closes if (3)
        } // closes if (2)
	} // closes if(1)
}

- (void)applicationWillTerminate: (NSNotification *) notification
{
	// Code to execute before the app quits to prevent a X/Gtk error
    NSLog(@"Application is about to terminate.");
    NSTask *ending = [[NSTask alloc] init];
       [ending setLaunchPath:@"/usr/bin/pkill"];
       [ending setArguments:[NSArray arrayWithObjects:
                                      @"epeira_socket", nil]];
	    [ending launch];
	    NSLog(@"Ending: epeira_socket was terminated.");
}
    

@end
