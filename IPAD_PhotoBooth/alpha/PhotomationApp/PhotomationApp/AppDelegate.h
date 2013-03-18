//
//  AppDelegate.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>

@interface AppDelegate : UIResponder
    <UIApplicationDelegate, UITabBarControllerDelegate,
    UINavigationControllerDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) UIWindow *window;

//@property (strong, nonatomic) UITabBarController *tabBarController;

//  The primary nav controller...
@property (strong, nonatomic) UINavigationController *navController;

//  The signup/login choose view...
@property (strong, nonatomic) UIViewController *signup_login_view;

//  The signup view...
@property (strong, nonatomic) UIViewController *signup_view;

//  The login view...
@property (strong, nonatomic) UIViewController *login_view;

//  The takephoto view...
@property (strong, nonatomic) UIViewController *takephoto_view;

//  The select favorite view...
@property (strong, nonatomic) UIViewController *selectfavorite_view;

//  The selected photo view...
@property (strong, nonatomic) UIViewController *selectedphoto_view;

//  The gallery selected photo view...
@property (strong, nonatomic) UIViewController *galleryselectedphoto_view;

//  The gallery view...
@property (strong, nonatomic) UIViewController *gallery_view;

//  The share photo view...
@property (strong, nonatomic) UIViewController *sharephoto_view;

//  audio stuff...
@property (nonatomic, retain) AVAudioPlayer *audio;

//  alert view
@property (nonatomic, retain) UIAlertView *alert;

//  Goto the login view...
-(void) goto_login;

//  Goto the signup view...
-(void) goto_signup;

//  Goto the takephoto view...
-(void) goto_takephoto;

//  Goto the select favorite view...
-(void) goto_selectfavorite:(int)count;

//  Goto the selected photo view...
-(void) goto_selectedphoto:(int)which count:(int)count;

//  Goto the gallery selected photo view...
-(void) goto_galleryselectedphoto:(NSString *)fname;

//  Goto the gallery...
-(void) goto_gallery;

//  Goto the share photo view...
-(void) goto_sharephoto:(NSString *)fname;

//  Play a sound...
- (void) playSound:(NSString *)sound delegate:(id<AVAudioPlayerDelegate>) del;

//  Get gallery photos...
+(NSArray *) getGalleryPhotos;

//  Get gallery directory...
+(NSString *)getGalleryDir;

//  Commit a taken photo to gallery...
+ (NSString *)addPhotoToGallery:(int)which;

//  Delete a gallery photo...
+ (BOOL)deletePhotoFromGallery:(NSString *)fname;

//  Error message display...
+(void)ErrorMessage:(NSString *)message;

//  Not implemented warning...
+(void)NotImplemented:(NSString *)message;

@end
