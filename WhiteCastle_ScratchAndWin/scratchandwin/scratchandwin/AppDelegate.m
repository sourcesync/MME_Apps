//
//  AppDelegate.m
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

#import "ViewController.h"

#import "ScanViewViewController.h"
#import "DownloadController.h"
#import "TicketController.h"
#import "MyCouponsController.h"
#import "CouponController.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize viewController = _viewController;
@synthesize backButtonController=_backButtonController;

@synthesize scanController = _scanController;
@synthesize downloadController = _downloadController; 
@synthesize ticketController = _ticketController;
@synthesize mycouponsController = _mycouponsController;
@synthesize couponController = _couponController;

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

-(void) GoToScan
{
    if ( _scanController == nil )
    {
        _scanController = [ [ ScanViewViewController alloc ] 
                           initWithNibName:@"ScanViewViewController" bundle:nil ];
    }
    else 
    {
        
    }
    
    self.window.rootViewController = _scanController;
}
 

-(void) Download: (NSString *)strurl: (BOOL)winner
{ 
    if ( _downloadController == nil )
    {
        _downloadController = [ [ DownloadController alloc ] 
                           initWithNibName:@"DownloadController" bundle:nil ];
    }
    else 
    {
        
    }
    
    _downloadController.strurl = strurl;
    _downloadController.winner = winner;
    self.window.rootViewController = _downloadController;
}

-(void) ShowTicket: (UIImage *)img: (BOOL)winner
{
    if ( _ticketController == nil )
    {
        _ticketController = [ [ TicketController alloc ] 
                               initWithNibName:@"TicketController" bundle:nil ];
    }
    else 
    {
        
    }
    
    _ticketController.winner = winner;
    _ticketController.img = img;
    _ticketController.state = 0;
    self.window.rootViewController = _ticketController;
}


-(void) ShowCoupon:(UIViewController *)back
{
    if ( _couponController == nil )
    {
        _couponController = [ [ CouponController alloc ] 
                                initWithNibName:@"CouponController" bundle:nil ];
    }
    else 
    {
        
    }
    
    self.backButtonController = back;
    self.window.rootViewController = _couponController;
}

-(void) ShowMyCoupons
{
    if ( _mycouponsController == nil )
    {
        _mycouponsController = [ [ MyCouponsController alloc ] 
                             initWithNibName:@"MyCouponsController" bundle:nil ];
    }
    else 
    {
        
    }
    
    self.window.rootViewController = _mycouponsController;
}

-(void) GoBack
{
    if (self.backButtonController != nil )
    {
        self.window.rootViewController = self.backButtonController;
        self.backButtonController = nil;
    }
}

-(void) Home
{
    self.window.rootViewController = self.viewController;
}

@end
