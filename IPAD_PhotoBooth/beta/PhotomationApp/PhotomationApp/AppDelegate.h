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
#import "ContentManager.h"

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
@property (nonatomic, assign) bool active_photo_is_original;
@property (nonatomic, assign) bool active_photo_is_gallery;
@property (nonatomic, assign) bool is_portrait;
@property (nonatomic, assign) bool lock_orientation;
@property (nonatomic, assign) UIInterfaceOrientation taken_pic_orientation;
@property (nonatomic, assign) NSUInteger take_pic_supported_orientations;
@property (nonatomic, assign) bool have_start_orientation;
@property (nonatomic, assign) UIInterfaceOrientation start_orientation;
@property (nonatomic, assign) NSUInteger start_orientation_mask;
@property (nonatomic, assign) bool is_simulator;
@property (nonatomic, assign) bool is_twitter;

//  Windows and Views...
@property (strong, nonatomic, retain) UIWindow *window;
@property (strong, nonatomic, retain) UINavigationController *navController;
@property (strong, nonatomic, retain) UIViewController *signup_login_view;
@property (strong, nonatomic, retain) UIViewController *signup_view;
@property (strong, nonatomic, retain) UIViewController *login_view;
@property (strong, nonatomic, retain) UIViewController *takephoto_view;
@property (strong, nonatomic, retain) UIViewController *takephoto_auto_view;
@property (strong, nonatomic, retain) UIViewController *takephoto_manual_view;
@property (strong, nonatomic, retain) UIViewController *selectfavorite_view;
@property (strong, nonatomic, retain) UIViewController *yourphoto_view;
@property (strong, nonatomic, retain) UIViewController *efx_view;
@property (strong, nonatomic, retain) UIViewController *efxBack;
@property (strong, nonatomic, retain) UIViewController *selectedphoto_view;
@property (strong, nonatomic, retain) UIViewController *galleryselectedphoto_view;
@property (strong, nonatomic, retain) UIViewController *gallery_view;
@property (strong, nonatomic, retain) UIViewController *sharephoto_view;
@property (strong, nonatomic, retain) UIViewController *shareBack;
@property (strong, nonatomic, retain) UIViewController *chroma_view;
@property (strong, nonatomic, retain) UIViewController *email_view;
@property (strong, nonatomic, retain) UIViewController *emailBack;
@property (strong, nonatomic, retain) UIViewController *flickr_view;
@property (strong, nonatomic, retain) UIViewController *flickrBack;
@property (strong, nonatomic, retain) UIViewController *print_view;
@property (strong, nonatomic, retain) UIViewController *printBack;
@property (strong, nonatomic, retain) UIViewController *facebook_view;
@property (strong, nonatomic, retain) UIViewController *twitter_view;
@property (strong, nonatomic, retain) UIPopoverController *settings_popover;
@property (strong, nonatomic, retain) UISplitViewController *settings_split_view;
@property (strong, nonatomic, retain) UIViewController *settingsBack;
@property (strong, nonatomic, retain) UIAlertView *alert;
@property (strong, nonatomic, retain) UIViewController *thanks_view;
@property (strong, nonatomic, retain) UIViewController *start_view;
@property (strong, nonatomic, retain) UIViewController *cms_view;
@property (strong, nonatomic, retain) NSString *login_name;
@property (strong, nonatomic, retain) NSString *current_photo_path;
@property (strong, nonatomic, retain) NSString *current_filtered_path;
@property (strong, nonatomic, retain) AVAudioPlayer *audio;
@property (strong, nonatomic, retain) ContentManager *cm;
@property (strong, nonatomic, retain) OFFlickrAPIContext *flickrContext;
@property (strong, nonatomic, retain) NSString *flickrUserName;
@property (strong, nonatomic, retain) NSString *current_email;
@property (strong, nonatomic, retain) NSString *file_name;
@property (strong, nonatomic, retain) Configuration *config;
@property (strong, nonatomic, retain) ChromaVideo  *chroma_video;
@property (strong, nonatomic, retain) UIViewController *settings_right_view;
@property (strong, nonatomic, retain) UINavigationController *detail_nav;
@property (strong, nonatomic, retain) UIViewController *left;

extern NSString *SRCallbackURLBaseString;
extern NSString *SnapAndRunShouldUpdateAuthInfoNotification;

+(bool) is_context_twitter;
+(void)ErrorMessage:(NSString *)message;
-(void) goto_login;
-(void) goto_cms;
-(void) goto_takephoto;
-(void) playSound:(NSURL *)sound delegate:(id<AVAudioPlayerDelegate>) del;
-(void) goto_start;
-(void) goto_thanks;
-(void) goto_efx:(UIViewController *)back;
-(void) goto_selectedphoto;
+(NSString *) AddPhotoToGallery:(int)which is_portrait:(bool)is_portrait;
+(void)NotImplemented:(NSString *)message;
+(NSString *) GetGalleryDir;
+(NSString *) GetFilterDir;
+(NSArray *) GetGalleryPairs;
+(UIImage *) GetActivePhoto;
+(NSArray *) GetGalleryPhotos;
-(void) goto_selectfavorite;
-(void) goto_settings:(UIViewController *)back;
-(void) goto_gallery;
-(void) goto_printview:(UIViewController *)back;
-(void) goto_galleryselectedphoto;-(void) settings_go_back;
+(BOOL) DeletePhotoFromGallery:(NSString *)fname;
-(void) goto_facebookview:(UIViewController *)back;
-(void) goto_twitterview:(UIViewController *)back append_hash_tag:(BOOL)append_hash_tag;
-(void) goto_flickrview:(UIViewController *)back;
-(void) goto_emailview:(UIViewController *)back;
-(UIImage *) processTemplate:(UIImage *)insert;
-(UIImage *) processTemplateWatermark:(UIImage *)insert
                                 raw1:(UIImageView *)raw1
                                 raw2:(UIImageView *)raw2
                             vertical:(BOOL)vertical;
+(void)InfoMessage:(NSString *)message;
+(NSString *) GetUUID;
-(void) email_go_back;+(void) set_popover: (UIPopoverController *)popover;
-(void) goto_sharephoto:(UIViewController *)back;
+(UIImage *) GetCurrentFilteredPhoto;
-(void) efx_go_back;
+(BOOL) SetCurrentFilteredPhoto:(UIImage *)img;
-(void) print_go_back;
+(AppDelegate *)sharedDelegate;
-(void) clearRequest;
-(void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken
                           secret:(NSString *)inSecret;
+(BOOL) DeleteCurrentFilteredPhoto;
-(void) goto_yourphoto;
+(UIImage *) GetCurrentOriginalPhoto;
+(NSString *) AddPhotoToGallery:(UIImage *)img;

+(NSString *) GetCurrentOriginalPhotoPath;
-(void) settings_done;



/*

-(void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken
                            secret:(NSString *)inSecret

//  View funcs....
-(void) goto_signup;
-(void) share_go_back;
+(void) show_popover: (UIBarButtonItem *)b;
+(void) select_settings_chroma;
+(void) show_settings_chroma;
//  Gallery funcs...
+(NSArray *) GetGalleryPhotos;

//  Messages funcs...

//  Watermark stuff...-(UIImage *) watermarkImage:(UIImage *)original watermark:(NSString *)path;
-(UIImage *) sanitize:(UIImage *)insert;


//  Current photos...
-(void) saveTakenPhoto:(NSData *)data orientation:(UIInterfaceOrientation)orientation;+(BOOL) setFilteredPhoto:(UIImage *)img original:(NSString *)original;
+(NSString *) FindFilteredVersion: (NSString *)path;
;*/


@end
