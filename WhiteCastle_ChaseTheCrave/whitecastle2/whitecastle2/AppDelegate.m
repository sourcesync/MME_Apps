//
//  AppDelegate.m
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "HomeView.h"
#import "RewardsView.h"
#import "SignupView.h"
#import "TruckFinderView.h"
#import "MyAccountHomeView.h"
#import "MyAccountStartView.h"
#import "TruckSettingsView.h"
#import "RestaurantSettingsView.h"
#import "DealsView.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;

static HomeView* _dealsview = nil;
static HomeView* _homeview = nil;
static RewardsView* _rewardsview = nil;
static SignupView* _signupview = nil; 
static TruckFinderView *_truckfinderview = nil;
static MyAccountHomeView *_myaccounthomeview = nil;
static MyAccountStartView *_myaccountstartview = nil;
static TruckSettingsView *_truckersettings = nil;
static RestaurantSettingsView *_restaurantsettings = nil;


static UINavigationController *nav = nil;


-(IBAction) goto_trucksettingsview:(id)sender
{
    if ( !_truckersettings )
    {
        _truckersettings = \
            [ [ TruckSettingsView alloc ] initWithNibName:@"TruckSettingsView" bundle:nil ];
    }
    
    /*
    if ( [ nav topViewController] == _truckersettings ) return;
    
    [ nav popToRootViewControllerAnimated:NO ];
    
    [ nav pushViewController:_truckersettings animated:YES];
     */
    
    self.window.rootViewController = _truckersettings;
}

-(IBAction) goto_restaurantsettingsview:(id)sender
{
    if ( !_restaurantsettings )
    {
        _restaurantsettings = [ [ RestaurantSettingsView alloc ] initWithNibName:@"RestaurantSettingsView" bundle:nil ];
    }
    
    /*
    
    if ( [ nav topViewController] == _restaurantsettings ) return;
    
    [ nav popToRootViewControllerAnimated:NO ];
    
    [ nav pushViewController:_restaurantsettings animated:YES];
     */
    
    self.window.rootViewController = _restaurantsettings;
}

-(IBAction) goto_truckfinder:(id)sender;
{
    
    if ( !_truckfinderview )
    {
        _truckfinderview = [ [ TruckFinderView alloc ] initWithNibName:@"TruckFinderView" bundle:nil ];
    }
    
    
    /*
    if ( [ nav topViewController] == _truckfinderview ) return;
    
    [ nav popToRootViewControllerAnimated:NO ];
    
    [ nav pushViewController:_truckfinderview animated:YES];
     */
    
self.window.rootViewController = _truckfinderview;
}

-(IBAction) goto_home:(id)sender
{
    if ( !_homeview )
    {
        _homeview = [ [ HomeView alloc ] initWithNibName:@"HomeView" bundle:nil ];
    }
    
    /*
    if ( !nav)
    {
        
        nav = [[UINavigationController alloc] initWithRootViewController:_homeview ];
        nav.navigationBarHidden = YES;
        nav.navigationBar.hidden = YES;
        
        //self.window.rootViewController = _homeview;
        self.window.rootViewController = nav;
        //nav.navigationController
    }
    
    
    if ( [ nav topViewController] == _homeview ) return;
    
    //[ nav popToRootViewControllerAnimated:YES ];
    
    NSArray * newViewControllers = [NSArray arrayWithObjects:_homeview , nil];
    
    [ nav setViewControllers: newViewControllers ];
     
     */
    
    self.window.rootViewController = _homeview;
    

}


-(IBAction) goto_deals:(id)sender
{
    if ( !_dealsview )
    {
        _dealsview = [ [ DealsView alloc ] initWithNibName:@"DealsView" bundle:nil ];
    }
    
    /*
     if ( !nav)
     {
     
     nav = [[UINavigationController alloc] initWithRootViewController:_homeview ];
     nav.navigationBarHidden = YES;
     nav.navigationBar.hidden = YES;
     
     //self.window.rootViewController = _homeview;
     self.window.rootViewController = nav;
     //nav.navigationController
     }
     
     
     if ( [ nav topViewController] == _homeview ) return;
     
     //[ nav popToRootViewControllerAnimated:YES ];
     
     NSArray * newViewControllers = [NSArray arrayWithObjects:_homeview , nil];
     
     [ nav setViewControllers: newViewControllers ];
     
     */
    
    self.window.rootViewController = _dealsview;
    
    
}



-(IBAction) goto_rewards:(id)sender
{
    if ( !_rewardsview )
    {
        _rewardsview = [ [ RewardsView alloc ] initWithNibName:@"RewardsView" bundle:nil ];
    }
    
    /*
    if ( [ nav topViewController] == _rewardsview ) return;
    
    //self.window.rootViewController = _rewardsview;
    
    
    
    //NSArray *viewControllers = nav.viewControllers;
    
    NSArray * newViewControllers = [NSArray arrayWithObjects: _rewardsview , nil];
    
    [ nav setViewControllers: newViewControllers ];
    
    //[ nav pushViewController:_rewardsview animated:YES];
     */
    
    
    self.window.rootViewController = _rewardsview;
}


-(IBAction) goto_signup:(id)sender
{
    if ( !_signupview )
    {
        _signupview = [ [ SignupView alloc ] initWithNibName:@"SignupView" bundle:nil ];
    }
    
    /*
    if ( [ nav topViewController] == _signupview ) return;
    
    //self.window.rootViewController = _signupview;
    
    [ nav popToRootViewControllerAnimated:NO ];
    
    [ nav pushViewController:_signupview animated:YES];
     */
    
    
    self.window.rootViewController = _signupview;
}


-(IBAction) goto_myaccounthome:(id)sender
{
    if ( !_myaccounthomeview )
    {
        _myaccounthomeview = [ [ MyAccountHomeView alloc ] initWithNibName:@"MyAccountHomeView" bundle:nil ];
    }
    
    
    /*
    if ( [ nav topViewController] == _myaccounthomeview ) return;
    
    
    
    //self.window.rootViewController = _signupview;
    
    //NSArray *viewControllers = nav.viewControllers;
    
    NSArray * newViewControllers = [NSArray arrayWithObjects:_myaccounthomeview , nil];
    
    [ nav setViewControllers: newViewControllers ];
    
    //[ nav pushViewController:_myaccounthomeview animated:YES];
     */
    
    
    self.window.rootViewController = _myaccounthomeview;
}


-(IBAction) goto_myaccountstart:(id)sender
{
    if ( !_myaccountstartview )
    {
        _myaccountstartview = 
            [ [ MyAccountStartView alloc ] initWithNibName:@"MyAccountStartView" bundle:nil ];
    }
    
    /*
    if ( [ nav topViewController] == _myaccountstartview ) return;
    
    //self.window.rootViewController = _signupview;
    
    [ nav popToRootViewControllerAnimated:NO ];
    
    [ nav pushViewController:_myaccountstartview animated:YES];
     */
    
    self.window.rootViewController = _myaccountstartview;   
}


-(void) pop
{
    [ nav popViewControllerAnimated:YES ];
}


- (void)dealloc
{
    [_window release];
    [_viewController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    // Override point for customization after application launch.
    self.viewController = [[[ViewController alloc] initWithNibName:@"ViewController" bundle:nil] autorelease];
    
    [[UIApplication sharedApplication] setApplicationIconBadgeNumber: 0];
    [ [UIApplication sharedApplication] cancelAllLocalNotifications];
    
    self.window.rootViewController = self.viewController;
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

@end
