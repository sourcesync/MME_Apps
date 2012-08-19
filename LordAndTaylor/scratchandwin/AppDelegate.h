//
//  AppDelegate.h
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ViewController;

@class ScanViewViewController;
@class DownloadController;
@class TicketController;
@class MyCouponsController;
@class CouponController;

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) ViewController *viewController;
@property (strong, nonatomic) UIViewController *backButtonController;

@property (strong, nonatomic) ScanViewViewController *scanController;
@property (strong, nonatomic) DownloadController *downloadController;
@property (strong, nonatomic) TicketController *ticketController;
@property (strong, nonatomic) MyCouponsController *mycouponsController;
@property (strong, nonatomic) CouponController *couponController;

//  PUBLIC FUNCS...

-(void) GoToScan;

-(void) Download: (NSString *)strurl:(BOOL)winner;

-(void) ShowTicket: (UIImage *)img: (BOOL)winner;

-(void) ShowCoupon:(UIViewController *)back;

-(void) ShowMyCoupons;

-(void) GoBack;

-(void) Home;

@end
