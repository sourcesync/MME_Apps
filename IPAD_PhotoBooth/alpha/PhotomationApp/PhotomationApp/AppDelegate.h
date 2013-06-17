//
//  AppDelegate.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVAnimation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVMetadataFormat.h>
#import <AVFoundation/AVVideoSettings.h>
#import <FacebookSDK/FacebookSDK.h>

#import "ChromaVideo.h"
#import "Configuration.h"

#import "ObjectiveFlickr.h"

@interface AppDelegate : UIResponder
    <UIApplicationDelegate, UITabBarControllerDelegate,
    UINavigationControllerDelegate, UIAlertViewDelegate,
    OFFlickrAPIRequestDelegate>
{
    OFFlickrAPIContext *flickrContext;
	OFFlickrAPIRequest *flickrRequest;
    
}

//  Various state...
@property (nonatomic, assign) int selected_id;
@property (nonatomic, assign) int take_count;
@property (strong, nonatomic) NSString *fpath;
@property (strong, nonatomic) NSString *gname;

@property (nonatomic, assign) bool is_portrait;

@property (nonatomic, assign) bool lock_orientation;
@property (nonatomic, assign) UIInterfaceOrientation taken_pic_orientation;
@property (nonatomic, assign) NSUInteger take_pic_supported_orientations;

@property (nonatomic, assign) bool have_start_orientation;
@property (nonatomic, assign) UIInterfaceOrientation start_orientation;
@property (nonatomic, assign) NSUInteger start_orientation_mask;

//  Configuration...
@property (nonatomic, retain) Configuration *config;

//  Chroma Video...
@property (strong, nonatomic) ChromaVideo  *chroma_video;

//  The one and only window...
@property (strong, nonatomic) UIWindow *window;

//  Facebook stuff...
@property (strong, nonatomic) FBSession *session;

//  The primary nav controller...
@property (strong, nonatomic) UINavigationController *navController;

//  The signup/login choose view...
@property (strong, nonatomic) UIViewController *signup_login_view;

//  The signup view...
@property (strong, nonatomic) UIViewController *signup_view;

//  The login view...
@property (strong, nonatomic) UIViewController *login_view;

//  The takephoto view(s)...
@property (strong, nonatomic) UIViewController *takephoto_view;
@property (strong, nonatomic) UIViewController *takephoto_auto_view;
@property (strong, nonatomic) UIViewController *takephoto_manual_view;

//  The select favorite view...
@property (strong, nonatomic) UIViewController *selectfavorite_view;

//  The select favorite view...
@property (strong, nonatomic) UIViewController *yourphoto_view;

//  The efx view...
@property (strong, nonatomic) UIViewController *efx_view;
@property (strong, nonatomic) UIViewController *efxBack;

//  The selected photo view...
@property (strong, nonatomic) UIViewController *selectedphoto_view;

//  The gallery selected photo view...
@property (strong, nonatomic) UIViewController *galleryselectedphoto_view;

//  The gallery view...
@property (strong, nonatomic) UIViewController *gallery_view;

//  The share photo view...
@property (strong, nonatomic) UIViewController *sharephoto_view;
@property (strong, nonatomic) UIViewController *shareBack;

//  The chroma view...
@property (strong, nonatomic) UIViewController *chroma_view;

//  The email view...
@property (strong, nonatomic) UIViewController *email_view;
@property (strong, nonatomic) UIViewController *emailBack;

//  The flickr view...
@property (strong, nonatomic) UIViewController *flickr_view;
@property (strong, nonatomic) UIViewController *flickrBack;

//  The print view...
@property (strong, nonatomic) UIViewController *print_view;
@property (strong, nonatomic) UIViewController *printBack;

//  The facebook view...
@property (strong, nonatomic) UIViewController *facebook_view;

//  The twitter view...
@property (strong, nonatomic) UIViewController *twitter_view;

//  The settings ui split view...
@property (strong, nonatomic) UIPopoverController *settings_popover;
@property (strong, nonatomic) UISplitViewController *settings_split_view;

//  audio stuff...
@property (nonatomic, retain) AVAudioPlayer *audio;
//  alert view
@property (nonatomic, retain) UIAlertView *alert;

//  back controller from settings...
@property (strong, nonatomic) UIViewController *settingsBack;

//  oauth/flickr/twitter stuff...
@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain) NSString *flickrUserName;
extern NSString *SRCallbackURLBaseString;
extern NSString *SnapAndRunShouldUpdateAuthInfoNotification;
@property (nonatomic, assign) bool is_twitter;

//  Goto the login view...
-(void) goto_login;

//  Goto the signup view...
-(void) goto_signup;

//  Goto the takephoto view...
-(void) goto_takephoto;

//  Goto the yourphoto view...
-(void) goto_yourphoto;

//  Goto the efx view...
-(void) goto_efx:(UIViewController *)back;
-(void) efx_go_back;

//  Goto the select favorite view...
-(void) goto_selectfavorite;

//  Goto the selected photo view...
-(void) goto_selectedphoto;

//  Goto the gallery selected photo view...
-(void) goto_galleryselectedphoto;

//  Goto the gallery...
-(void) goto_gallery;

//  Goto the settings...
-(void) goto_settings:(UIViewController *)back;
-(void) settings_go_back;

//  Goto the share photo view...
-(void) goto_sharephoto:(UIViewController *)back;
-(void) share_go_back;

//  Goto the print view...
-(void) goto_printview:(UIViewController *)back;
-(void) print_go_back;

//  Goto the email view...
-(void) goto_emailview:(UIViewController *)back;
-(void) email_go_back;

//  Goto the facebook view...
-(void) goto_facebookview:(UIViewController *)back;

//  Goto the twitter view...
-(void) goto_twitterview:(UIViewController *)back;

//  Goto the flickr view...
-(void) goto_flickrview:(UIViewController *)back;

//  Select chroma settings...
//+ (void) show_popover;
+ (void) set_popover: (UIPopoverController *)popover;
+ (void) show_popover: (UIBarButtonItem *)b;
+ (void) select_settings_chroma;
+ (void) show_settings_chroma;


//  Play a sound...
- (void) playSound:(NSURL *)sound delegate:(id<AVAudioPlayerDelegate>) del;

//  Get gallery photos...
+(NSArray *) getGalleryPhotos;

//  Get gallery directory...
+(NSString *)getGalleryDir;

//  Commit a taken photo to gallery...
+ (NSString *)addPhotoToGallery:(int)which is_portrait:(bool)is_portrait;

//  Delete a gallery photo...
+ (BOOL)deletePhotoFromGallery:(NSString *)fname;

//  Error message display...
+(void)ErrorMessage:(NSString *)message;

//  Info message display...
+(void)InfoMessage:(NSString *)message;

//  Not implemented warning...
+(void)NotImplemented:(NSString *)message;


-(UIImage *) processTemplate:(UIImage *)insert;
-(UIImage *) processTemplateWatermark:(UIImage *)insert
                                 raw1:(UIImageView *)raw1
                                 raw2:(UIImageView *)raw2
                             vertical:(BOOL)vertical;
-(UIImage *) watermarkImage:(UIImage *)original watermark:(NSString *)path;
-(UIImage *) sanitize:(UIImage *)insert;

-(void) saveTakenPhoto:(NSData *)data orientation:(UIInterfaceOrientation)orientation;

+ (NSString *)GetUUID;

//  OAUTH / Flickr / Twitter stuff

+ (AppDelegate *)sharedDelegate;
- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret;
+ (bool) is_context_twitter;
-(void) clearRequest;

@end
