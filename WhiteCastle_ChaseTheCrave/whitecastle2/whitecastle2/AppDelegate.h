//
//  AppDelegate.h
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) ViewController *viewController;

 
-(IBAction) goto_home:(id)sender;
-(IBAction) goto_rewards:(id)sender;
-(IBAction) goto_signup:(id)sender;
-(IBAction) goto_myaccounthome:(id)sender;
-(IBAction) goto_myaccountstart:(id)sender;
-(IBAction) goto_trucksettingsview:(id)sender;
-(IBAction) goto_restaurantsettingsview:(id)sender;
-(IBAction) goto_truckfinder:(id)sender;

-(IBAction) goto_deals:(id)sender;

-(void) pop;

@end
