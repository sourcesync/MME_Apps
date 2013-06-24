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
@property (strong, nonatomic) NSString *current_photo_path;
@property (strong, nonatomic) NSString *current_filtered_path;
@property (nonatomic, assign) bool active_photo_is_original;
@property (strong, nonatomic) NSString *file_name;
@property (nonatomic, assign) bool is_portrait;
@property (nonatomic, assign) bool lock_orientation;
@property (nonatomic, assign) UIInterfaceOrientation taken_pic_orientation;
@property (nonatomic, assign) NSUInteger take_pic_supported_orientations;
@property (nonatomic, assign) bool have_start_orientation;
@property (nonatomic, assign) UIInterfaceOrientation start_orientation;
@property (nonatomic, assign) NSUInteger start_orientation_mask;
@property (nonatomic, retain) Configuration *config;
@property (strong, nonatomic) ChromaVideo  *chroma_video;
@property (nonatomic, retain) AVAudioPlayer *audio;
@property (nonatomic, assign) bool is_simulator;
@property (nonatomic, assign) bool is_twitter;
extern NSString *SRCallbackURLBaseString;
extern NSString *SnapAndRunShouldUpdateAuthInfoNotification;
@property (nonatomic, retain) NSString *current_email;


//  Windows and Views...
@property (strong, nonatomic) UIWindow *window;
@property (strong, nonatomic) UINavigationController *navController;
@property (strong, nonatomic) UIViewController *signup_login_view;
@property (strong, nonatomic) UIViewController *signup_view;
@property (strong, nonatomic) UIViewController *login_view;
@property (strong, nonatomic) UIViewController *takephoto_view;
@property (strong, nonatomic) UIViewController *takephoto_auto_view;
@property (strong, nonatomic) UIViewController *takephoto_manual_view;
@property (strong, nonatomic) UIViewController *selectfavorite_view;
@property (strong, nonatomic) UIViewController *yourphoto_view;
@property (strong, nonatomic) UIViewController *efx_view;
@property (strong, nonatomic) UIViewController *efxBack;
@property (strong, nonatomic) UIViewController *selectedphoto_view;
@property (strong, nonatomic) UIViewController *galleryselectedphoto_view;
@property (strong, nonatomic) UIViewController *gallery_view;
@property (strong, nonatomic) UIViewController *sharephoto_view;
@property (strong, nonatomic) UIViewController *shareBack;
@property (strong, nonatomic) UIViewController *chroma_view;
@property (strong, nonatomic) UIViewController *email_view;
@property (strong, nonatomic) UIViewController *emailBack;
@property (strong, nonatomic) UIViewController *flickr_view;
@property (strong, nonatomic) UIViewController *flickrBack;
@property (strong, nonatomic) UIViewController *print_view;
@property (strong, nonatomic) UIViewController *printBack;
@property (strong, nonatomic) UIViewController *facebook_view;
@property (strong, nonatomic) UIViewController *twitter_view;
@property (strong, nonatomic) UIPopoverController *settings_popover;
@property (strong, nonatomic) UISplitViewController *settings_split_view;
@property (strong, nonatomic) UIViewController *settingsBack;
@property (nonatomic, retain) UIAlertView *alert;
@property (strong, nonatomic) UIViewController *thanks_view;
@property (strong, nonatomic) UIViewController *start_view;

//  oauth/flickr/twitter stuff...
@property (nonatomic, readonly) OFFlickrAPIContext *flickrContext;
@property (nonatomic, retain) NSString *flickrUserName;
+(AppDelegate *)sharedDelegate;
-(void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken
                            secret:(NSString *)inSecret;
+(bool) is_context_twitter;
-(void) clearRequest;

//  View funcs....
-(void) goto_login;
-(void) goto_signup;
-(void) goto_takephoto;
-(void) goto_yourphoto;
-(void) goto_efx:(UIViewController *)back;
-(void) efx_go_back;
-(void) goto_selectfavorite;
-(void) goto_selectedphoto;
-(void) goto_galleryselectedphoto;
-(void) goto_gallery;
-(void) goto_settings:(UIViewController *)back;
-(void) settings_go_back;
-(void) goto_sharephoto:(UIViewController *)back;
-(void) share_go_back;
-(void) goto_printview:(UIViewController *)back;
-(void) print_go_back;
-(void) goto_emailview:(UIViewController *)back;
-(void) email_go_back;
-(void) goto_facebookview:(UIViewController *)back;
-(void) goto_twitterview:(UIViewController *)back;
-(void) goto_flickrview:(UIViewController *)back;
+(void) set_popover: (UIPopoverController *)popover;
+(void) show_popover: (UIBarButtonItem *)b;
+(void) select_settings_chroma;
+(void) show_settings_chroma;
-(void) playSound:(NSURL *)sound delegate:(id<AVAudioPlayerDelegate>) del;
-(void) goto_start;

//  Gallery funcs...
+(NSArray *) GetGalleryPhotos;
+(NSArray *) GetGalleryPairs;
+(NSString *) GetGalleryDir;
+(NSString *) GetFilterDir;
+(NSString *) AddPhotoToGallery:(int)which is_portrait:(bool)is_portrait;
+(NSString *) AddPhotoToGallery:(UIImage *)img;
+(BOOL) DeletePhotoFromGallery:(NSString *)fname;

//  Messages funcs...
+(void)ErrorMessage:(NSString *)message;
+(void)InfoMessage:(NSString *)message;
+(void)NotImplemented:(NSString *)message;

//  Watermark stuff...
-(UIImage *) processTemplate:(UIImage *)insert;
-(UIImage *) processTemplateWatermark:(UIImage *)insert
                                 raw1:(UIImageView *)raw1
                                 raw2:(UIImageView *)raw2
                             vertical:(BOOL)vertical;
-(UIImage *) watermarkImage:(UIImage *)original watermark:(NSString *)path;
-(UIImage *) sanitize:(UIImage *)insert;


//  Current photos...
-(void) saveTakenPhoto:(NSData *)data orientation:(UIInterfaceOrientation)orientation;
+(BOOL) SetCurrentFilteredPhoto:(UIImage *)img;
+(UIImage *) GetActivePhoto;
+(BOOL) setFilteredPhoto:(UIImage *)img original:(NSString *)original;
+(UIImage *) GetCurrentOriginalPhoto;
+(UIImage *) GetCurrentFilteredPhoto;
+(NSString *) FindFilteredVersion: (NSString *)path;
+(BOOL) DeleteCurrentFilteredPhoto;
+(NSString *) GetUUID;



@end
