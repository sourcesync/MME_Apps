//
//  AppDelegate.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "SignupLoginViewController.h"

#import "LoginViewController.h"

#import "SignupViewController.h"

@implementation AppDelegate

- (void)dealloc
{
    [_window release];
    [_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //  Create signup login choose view...
    self.signup_login_view =
        [[[SignupLoginViewController alloc] initWithNibName:@"SignupLoginViewController" bundle:nil] autorelease];
    
    //  Create the login view...
    self.login_view =
        [[[LoginViewController alloc] initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    
    //  Create the signup view...
    self.signup_view =
        [[[SignupViewController alloc] initWithNibName:@"SignupViewController" bundle:nil] autorelease];
    
    //  Create the navigation controller...
    self.navController =
        [[[UINavigationController alloc] initWithRootViewController:self.signup_login_view ] autorelease ];
    
    //  Initialize app with the nav controller and signup/login choice as root view...
    self.window.rootViewController = self.navController;
    
    //self.tabBarController = [[[UITabBarController alloc] init] autorelease];
    //self.tabBarController.viewControllers = @[viewController1, viewController2];
    //self.window.rootViewController = self.tabBarController;
    
    
    
    [self.window makeKeyAndVisible];
    return YES;
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

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

- (void) goto_login
{
    [ self.navController pushViewController:self.login_view animated:YES ];
}


- (void) goto_signup
{
    [ self.navController pushViewController:self.signup_view animated:YES ];
}

@end
