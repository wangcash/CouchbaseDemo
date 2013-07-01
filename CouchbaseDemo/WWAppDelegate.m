//
//  WWAppDelegate.m
//  CouchbaseDemo
//
//  Created by Cash on 13-6-30.
//  Copyright (c) 2013年 imwangwei.cn. All rights reserved.
//

#import "WWAppDelegate.h"
#import <CouchbaseLite/CouchbaseLite.h>

#import "WWMasterViewController.h"

// The name of the database the app will use.
#define kDatabaseName @"my-database"

@implementation WWAppDelegate

@synthesize database;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
  NSLog(@"===== %s =====", __FUNCTION__);
  
#ifdef kDefaultSyncDbURL
  // Register the default value of the pref for the remote database URL to sync with:
  NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
  NSDictionary *appdefaults = [NSDictionary dictionaryWithObject:kDefaultSyncDbURL
                                                          forKey:@"syncpoint"];
  [defaults registerDefaults:appdefaults];
  [defaults synchronize];
#endif
  
  self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
  // Override point for customization after application launch.

  WWMasterViewController *masterViewController = [[WWMasterViewController alloc] initWithNibName:@"WWMasterViewController" bundle:nil];
  self.navigationController = [[UINavigationController alloc] initWithRootViewController:masterViewController];
  self.window.rootViewController = self.navigationController;
  

  // Start the Couchbase Mobile server:
  NSError *error;
  self.database = [[CBLManager sharedInstance] createDatabaseNamed:kDatabaseName
                                                             error:&error];
  if (!self.database)
    NSLog(@"%@\n%@", @"Couldn't open database", error.localizedDescription);
  
  [masterViewController useDatabase:self.database];
  
  [self.window makeKeyAndVisible];
  return YES;
}

- (void)alertView:(UIAlertView *)alertView didDismissWithButtonIndex:(NSInteger)buttonIndex {
  exit(0);
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


@end
