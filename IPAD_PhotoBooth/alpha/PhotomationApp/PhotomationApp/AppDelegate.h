//
//  AppDelegate.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate, UITabBarControllerDelegate, UINavigationControllerDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (strong, nonatomic) UITabBarController *tabBarController;

//  The primary nav controller...
@property (strong, nonatomic) UINavigationController *navController;

//  The signup/login choose view...
@property (strong, nonatomic) UIViewController *signup_login_view;

//  The signup view...
@property (strong, nonatomic) UIViewController *signup_view;

//  The login view...
@property (strong, nonatomic) UIViewController *login_view;

//  Goto the login view...
-(void) goto_login;

//  Goto the signup view...
- (void) goto_signup;

@end
