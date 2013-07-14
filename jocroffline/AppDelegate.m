//
//  AppDelegate.m
//  jocroffline
//
//  Created by reuben on 15/6/13.
//  Copyright (c) 2013 space.works. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate



- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
     
    databaseName = @"jocr2.sqlite";
    
	// Get the path to the documents directory and append the databaseName
//	NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
//	NSString *documentsDir = [documentPaths objectAtIndex:0];
//	databasePath = [documentsDir stringByAppendingPathComponent:databaseName];
    
        NSArray *arrayPathComponent=[NSArray arrayWithObjects:NSHomeDirectory(),@"Library/Caches",@"jocr2.sqlite",nil];
        databasePath=[NSString pathWithComponents:arrayPathComponent];

	[self checkAndCreateDatabase];
    
	// Query the database for all animal records and construct the "animals" array
	//[self readAnimalsFromDatabase];
    
	// Configure and show the window
	//[window addSubview:[navigationController view]];
	//[window makeKeyAndVisible];
    
    
    return YES;
}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    
    
    NSArray *arrayPathComponent=[NSArray arrayWithObjects:NSHomeDirectory(),@"Library/Caches",@"jocr2.sqlite",nil];
    databasePath=[NSString pathWithComponents:arrayPathComponent];

    assert([[NSFileManager defaultManager] fileExistsAtPath: databasePath]);
    
    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

-(void) checkAndCreateDatabase{
	// Check if the SQL database has already been saved to the users phone, if not then copy it over
	BOOL success;
    
	// Create a FileManager object, we will use this to check the status
	// of the database and to copy it over if required
	NSFileManager *fileManager = [NSFileManager defaultManager];
    
	// Check if the database has already been created in the users filesystem
	success = [fileManager fileExistsAtPath:databasePath];
    
    NSLog(success ? @"DB exists":@"DB doesn't exist");
	// If the database already exists then return without doing anything
	if(success) return;
    
	// If not then proceed to copy the database from the application to the users filesystem
    
	// Get the path to the database in the application package
	NSString *databasePathFromApp = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:databaseName];
    
	// Copy the database from the package to the users filesystem
	[fileManager copyItemAtPath:databasePathFromApp toPath:databasePath error:nil];
    
	//[fileManager release];
}


@end
