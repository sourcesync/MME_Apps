//
//  AppDelegate.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIAlertView.h>

#import "AppDelegate.h"
#import "SignupLoginViewController.h"
#import "LoginViewController.h"
#import "SignupViewController.h"
#import "TakePhotoViewController.h"
#import "SelectFavoriteViewController.h"
#import "SelectedPhotoViewController.h"
#import "GalleryViewController.h"
#import "GallerySelectedPhotoViewController.h"
#import "SharePhotoViewController.h"
#import "LoginNavController.h"
#import "ChromaViewController.h"
#import "SettingsLeftViewController.h"
#import "RightViewController.h"
#import "EmailViewController.h"
#import "PrintViewController.h"
#import "FacebookViewController.h"
#import "TwitterViewController.h"
#import "TakePhotoAutoViewController.h"
#import "TakePhotoManualViewController.h"
#import "YourPhotoViewController.h"
#import "EFXViewController.h"
#import "FlickrViewController.h"

#import "ChromaVideo.h"

#import "UIImage+Resize.h"
#import "UIImage+SubImage.h"



NSString *SnapAndRunShouldUpdateAuthInfoNotification = @"SnapAndRunShouldUpdateAuthInfoNotification";

// preferably, the auth token is stored in the keychain, but since working with keychain is a pain, we use the simpler default system
NSString *kStoredAuthTokenKeyName = @"FlickrOAuthToken";
NSString *kStoredAuthTokenSecretKeyName = @"FlickrOAuthTokenSecret";

NSString *kGetAccessTokenStep = @"kGetAccessTokenStep";
NSString *kCheckTokenStep = @"kCheckTokenStep";

NSString *SRCallbackURLBaseString = @"photomation://auth" ; //@"snapnrun://auth";

@implementation AppDelegate



- (void)dealloc
{
    //[_window release];
    //[_tabBarController release];
    [super dealloc];
}

/*
- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}
 */

- (void)applicationWillTerminate:(UIApplication *)application {
    // FBSample logic
    // if the app is going away, we close the session if it is open
    // this is a good idea because things may be hanging off the session, that need
    // releasing (completion block, etc.) and other components in the app may be awaiting
    // close notification in order to do cleanup
    [self.session close];
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    /*
     Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
     */
    
    // FBSample logic
    // We need to properly handle activation of the application with regards to SSO
    //  (e.g., returning from iOS 6.0 authorization dialog or from fast app switching).
    [FBAppCall handleDidBecomeActiveWithSession:self.session];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    //  Initialize some members...
    self.have_start_orientation = NO;
    self.lock_orientation = NO;
    
    //  Never show status bar...
    [[ UIApplication sharedApplication ] setStatusBarHidden:YES ];

    //  Create the chroma video object...
    self.chroma_video = [ [ ChromaVideo alloc ] init ];
    
    //  Create the configuration object...
    self.config = [ [ Configuration alloc ] init ];
    
    //  Create the one and only window...
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
    //
    //  Initialize all the singleton view controllers...
    //
    
    //  Create signup login choose view...
    self.signup_login_view =
        [[[SignupLoginViewController alloc]
          initWithNibName:@"SignupLoginViewController" bundle:nil] autorelease];
    
    //  Create the login view...
    self.login_view =
        [[[LoginViewController alloc]
          initWithNibName:@"LoginViewController" bundle:nil] autorelease];
    
    //  Create the signup view...
    self.signup_view =
        [[[SignupViewController alloc]
          initWithNibName:@"SignupViewController" bundle:nil] autorelease];
    
    //  Create the navigation controller...
    self.navController =
        [[ [ LoginNavController alloc ]
            initWithRootViewController:self.signup_login_view ] autorelease ];
    
    //  Create the takephoto controller...
    self.takephoto_view = 
        [[[TakePhotoViewController alloc]
          initWithNibName:@"TakePhotoViewController" bundle:nil] autorelease];
    
    //  take photo auto...
    self.takephoto_auto_view =
        [[[TakePhotoAutoViewController alloc]
          initWithNibName:@"TakePhotoAutoViewController" bundle:nil] autorelease ];
    
    //  take photo manual...
    self.takephoto_manual_view =
        [[[TakePhotoManualViewController alloc]
          initWithNibName:@"TakePhotoManualViewController" bundle:nil] autorelease ];

    //  Create the selectfavorite controller...
    self.selectfavorite_view =
        [[[SelectFavoriteViewController alloc]
            initWithNibName:@"SelectFavoriteViewController" bundle:nil] autorelease];
    
    //  Create the selectedphoto controller...
    self.selectedphoto_view =
        [[[SelectedPhotoViewController alloc]
            initWithNibName:@"SelectedPhotoViewController" bundle:nil] autorelease];
    
    //  Create the gallery controller...
    self.gallery_view =
        [[[GalleryViewController alloc]
          initWithNibName:@"GalleryViewController" bundle:nil] autorelease];

    //  Create the galleryselected photo controller...
    self.galleryselectedphoto_view =
        [[[GallerySelectedPhotoViewController alloc]
          initWithNibName:@"GallerySelectedPhotoViewController" bundle:nil] autorelease];
    
    //  Create the sharephoto controller...
    self.sharephoto_view =
        [[[SharePhotoViewController alloc]
          initWithNibName:@"SharePhotoViewController" bundle:nil] autorelease];
    
    //  Create the yourphoto controller...
    self.yourphoto_view =
        [[[YourPhotoViewController alloc]
            initWithNibName:@"YourPhotoViewController" bundle:nil] autorelease];
    
    //  Create the efx controller...
    self.efx_view =
        [[[EFXViewController alloc]
          initWithNibName:@"EFXViewController" bundle:nil] autorelease];
    
    //  Create the chroma controller...
    self.chroma_view =
        [[[ChromaViewController alloc]
            initWithNibName:@"ChromaViewController" bundle:nil] autorelease];
    
    //  Create the email controller...
    self.email_view =
        [[[EmailViewController alloc]
          initWithNibName:@"EmailViewController" bundle:nil] autorelease];
    
    //  Create the print controller...
    self.print_view =
        [[[PrintViewController alloc]
          initWithNibName:@"PrintViewController" bundle:nil] autorelease];
    
    //  Create the print controller...
    self.facebook_view =
        [[[FacebookViewController alloc]
          initWithNibName:@"FacebookViewController" bundle:nil] autorelease];
    
    //  Create the twitter controller...
    self.twitter_view =
        [[[TwitterViewController alloc]
          initWithNibName:@"TwitterViewController" bundle:nil] autorelease];
    
    //  Create the flickr controller...
    self.flickr_view =
        [[[FlickrViewController alloc]
          initWithNibName:@"FlickrViewController" bundle:nil] autorelease];
    
    //  Settings split view...
    SettingsLeftViewController *left =
        [[[SettingsLeftViewController alloc]
          initWithNibName:@"SettingsLeftViewController" bundle:nil] autorelease ];
    UINavigationController *rootNav =
        [[[UINavigationController alloc] initWithRootViewController:left] autorelease];
    UINavigationController *detailNav =
        [[[UINavigationController alloc] initWithRootViewController:self.chroma_view] autorelease];
    self.settings_split_view =
        [ [[UISplitViewController alloc] init ] autorelease ];
    self.settings_split_view.viewControllers =
        [NSArray arrayWithObjects:rootNav, detailNav, nil];
    self.settings_split_view.delegate = left;
    self.settings_popover = nil;
    
    //  signup/register tabbed controllers are first...
    //self.window.rootViewController = self.navController;
    
    //  take photo manual...
    self.window.rootViewController = self.takephoto_manual_view;
    
    //self.window.rootViewController = self.twitter_view;
    //self.is_twitter = YES;
    
    //self.window.rootViewController = self.flickr_view;
    //self.is_twitter = NO;
    
    //self.window.rootViewController = self.facebook_view;
    
    self.window.rootViewController = self.sharephoto_view;
    
    //  make it go !
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


- (void) goto_login
{
    [ self.navController pushViewController:self.login_view animated:YES ];
}


- (void) goto_signup
{
    [ self.navController pushViewController:self.signup_view animated:YES ];
}


-(void) goto_takephoto
{
    //[ self stopAudio ];
    //self.window.rootViewController =self.takephoto_view;
    self.window.rootViewController =self.takephoto_manual_view;
}


-(void) goto_settings: (UIViewController *)back
{
    self.settingsBack = back;
    
    //[ self.window addSubview:self.settings_split_view.view ];
    [self.window setRootViewController:(UIViewController*)self.settings_split_view];
}

- (void) settings_go_back
{
    if (self.settingsBack)
    {
        self.window.rootViewController = self.settingsBack;
        self.settingsBack = nil;
    }
}

- (void) goto_selectfavorite
{
    SelectFavoriteViewController *s = (SelectFavoriteViewController *)self.selectfavorite_view;
    self.window.rootViewController = s;
}


-(void) goto_galleryselectedphoto
{
    GallerySelectedPhotoViewController *s = (GallerySelectedPhotoViewController *)
        self.galleryselectedphoto_view;
    self.window.rootViewController = s;
}


-(void) goto_sharephoto: (UIViewController *)back
{
    SharePhotoViewController *s = (SharePhotoViewController *)self.sharephoto_view;
    self.shareBack = back;
    self.window.rootViewController = s;
}

- (void) share_go_back
{
    if (self.shareBack)
    {
        self.window.rootViewController = self.shareBack;
        self.shareBack = nil;
    }
}


-(void) goto_yourphoto
{
    YourPhotoViewController *s = (YourPhotoViewController *)self.yourphoto_view;
    self.window.rootViewController = s;
}

-(void) goto_efx:(UIViewController *)back
{
    EFXViewController *s = (EFXViewController *)self.efx_view;
    self.efxBack = back;
    self.window.rootViewController = s;
}

- (void) efx_go_back
{
    if (self.efxBack)
    {
        self.window.rootViewController = self.efxBack;
        self.efxBack = nil;
    }
}

-(void) goto_selectedphoto
{
    SelectedPhotoViewController *s =
        (SelectedPhotoViewController *)self.selectedphoto_view;
    self.window.rootViewController = s;
}


-(void) goto_printview:(UIViewController *)back
{
    self.printBack = back;
    
    PrintViewController *s = (PrintViewController *)self.print_view;
    self.window.rootViewController = s;
}

- (void) print_go_back
{
    if (self.printBack)
    {
        self.window.rootViewController = self.printBack;
        self.printBack = nil;
    }
}


-(void) goto_emailview:(UIViewController *)back
{
    
    self.emailBack = back;
    
    EmailViewController *s = (EmailViewController *)self.email_view;
    self.window.rootViewController = s;
}

- (void) email_go_back
{
    if (self.emailBack)
    {
        self.window.rootViewController = self.emailBack;
        self.emailBack = nil;
    }
}

-(void) goto_facebookview:(UIViewController *)back
{
    //self.settingsBack = back;
    
    FacebookViewController *s = (FacebookViewController *)self.facebook_view;
    self.window.rootViewController = s;
}


//  Goto the twitter view...
-(void) goto_twitterview:(UIViewController *)back
{
    //self.twitter_view = back;
    
    TwitterViewController *s = (TwitterViewController *)self.twitter_view;
    self.window.rootViewController = s;
    
    self.is_twitter = YES;
}


//  Goto the twitter view...
-(void) goto_flickrview:(UIViewController *)back
{
    //self.flickrBack = back;
    
    self.is_twitter = NO;
    FlickrViewController *s = (FlickrViewController *)self.flickr_view;
    self.window.rootViewController = s;
    
}


-(void) goto_gallery
{
    [ self stopAudio ];
    
    self.window.rootViewController =self.gallery_view;
}

+ (void) set_popover: (UIPopoverController *)popover
{
    AppDelegate *this = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    this.settings_popover = popover;
    
}
+(void) show_popover: (UIBarButtonItem *)b
{
    AppDelegate *this = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    if (this.settings_popover!=nil)
    {
        [ this.settings_popover presentPopoverFromBarButtonItem:b
                                   permittedArrowDirections:UIPopoverArrowDirectionUnknown
                                                   animated:YES ];
    }
}


+(void) select_settings_chroma
{
    AppDelegate *this = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    
    UINavigationController *leftnav = (UINavigationController *)
        [ this.settings_split_view.viewControllers objectAtIndex:0 ];
        
    SettingsLeftViewController *left = (SettingsLeftViewController *)
        [ leftnav.viewControllers objectAtIndex:0 ];
    
    [ left select_chroma ];
    
}

+(void) show_settings_chroma
{
    AppDelegate *this = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    
    UINavigationController *leftnav = (UINavigationController *)
    [ this.settings_split_view.viewControllers objectAtIndex:0 ];
    
    SettingsLeftViewController *left = (SettingsLeftViewController *)
    [ leftnav.viewControllers objectAtIndex:0 ];
    
    UIViewController *details = (UIViewController *)
    [ this.settings_split_view.viewControllers objectAtIndex:1 ];
    if ( details != this.chroma_view )
    {
        this.settings_split_view.viewControllers =
        [ NSArray arrayWithObjects:left, this.chroma_view, nil ];
    }
}

- (void) playSound:(NSURL *)sound delegate:(id<AVAudioPlayerDelegate>) del
{
    if ( self.audio!=nil )
    {
        [self.audio stop];
        self.audio =nil;
        
    }
    
    NSURL *fileURL = sound;
    
    self.audio = [[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL] autorelease];
    
    self.audio.delegate = del;
    
    [ self.audio prepareToPlay];
    
    [ self.audio play];
    
}

-(void)createDirectory:(NSString *)directoryName atFilePath:(NSString *)filePath
{
    NSString *filePathAndDirectory = [filePath stringByAppendingPathComponent:directoryName];
    NSError *error;
    
    if (![[NSFileManager defaultManager] createDirectoryAtPath:filePathAndDirectory
                                   withIntermediateDirectories:NO
                                                    attributes:nil
                                                         error:&error])
    {
        NSLog(@"Create directory error: %@", error);
    }
}

+(void)ErrorMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}


+(void)InfoMessage:(NSString *)message
{
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:message
                                                       delegate:nil
                                              cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alertView show];
}

+(void)NotImplemented:(NSString *)message
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    app.alert = [ [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"This Feature Not Yet Implemented"
                                   otherButtonTitles:nil] autorelease ];
    [app.alert show];
    //[app.alert release];
}

+(NSString *)getGalleryDir
{
    NSError *error = nil;
    
    NSString *gallerysubdir = [ NSString stringWithFormat:@"Documents/Gallery"];
    NSString  *galleryPath = [NSHomeDirectory() stringByAppendingPathComponent:gallerysubdir];
    
    BOOL isdir = NO;
    BOOL exists = [ [ NSFileManager defaultManager] fileExistsAtPath:galleryPath isDirectory:&isdir];
    if ( !exists )
    {
        if (![[NSFileManager defaultManager] createDirectoryAtPath:galleryPath
                                       withIntermediateDirectories:YES
                                                        attributes:nil
                                                             error:&error])
        {
            [ AppDelegate ErrorMessage:@"Cannot create gallery directory."];
            return nil;
        }
    }
    
    return galleryPath;
}

+(NSArray *) getGalleryPhotos
{
    NSError *error = nil;
    
    NSString  *galleryPath = [ AppDelegate getGalleryDir ];
    
    NSArray *filelist_raw = [ [ NSFileManager defaultManager]
                             contentsOfDirectoryAtPath:galleryPath
                             error:&error];
    
    NSArray *filelist_sorted = [filelist_raw sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            NSDictionary* first_properties  = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@", galleryPath, obj1] error:nil];
            NSDate*       first             = [first_properties  objectForKey:NSFileModificationDate];
            NSDictionary* second_properties = [[NSFileManager defaultManager] attributesOfItemAtPath:[NSString stringWithFormat:@"%@/%@", galleryPath, obj2] error:nil];
            NSDate*       second            = [second_properties objectForKey:NSFileModificationDate];
        return [second  compare:first];
        }];
    
    return filelist_sorted;
}

+ (NSString *)GetUUID
{
    CFUUIDRef theUUID = CFUUIDCreate(NULL);
    CFStringRef string = CFUUIDCreateString(NULL, theUUID);
    CFRelease(theUUID);
    return [(NSString *)string autorelease];
}


+ (BOOL)deletePhotoFromGallery:(NSString *)fname
{
    NSError *error = nil;
    
    //  Form path to file...
    NSString *fullpath = fname; 
    
    //  Remove gallery file...
    if ( ! [[NSFileManager defaultManager] removeItemAtPath:fullpath error:&error] )
    {
        [ AppDelegate ErrorMessage:@"Cannot delete gallery file."];
        return false;
    }
    else
    {
        return true;
    }
}

+ (NSString *)addPhotoToGallery:(int)which is_portrait:(bool)is_portrait
{
    NSError *error = nil;
    
    //  Check if gallery is full...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    NSArray *current_gallery = [ self getGalleryPhotos ];
    if ( [ current_gallery count ] >= app.config.max_gallery_photos )
    {
        [ AppDelegate ErrorMessage:@"Gallery Is Full" ];
        return nil;
    }
    
    // Get gallery path...
    NSString  *galleryPath = [ self getGalleryDir ];        
    
    // Form path to new file...
    NSString *uuid = [AppDelegate GetUUID ];
    NSString *newfname;
    if (is_portrait)
    {
        newfname = [ NSString stringWithFormat:@"P%@.jpg", uuid];
    }
    else
    {
        newfname = [ NSString stringWithFormat:@"L%@.jpg", uuid];
    }
    NSString *newfpath = [ NSString stringWithFormat:@"%@/%@", galleryPath, newfname ];

    //  Form path to photo...
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",which ];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    if (![[NSFileManager defaultManager]  copyItemAtPath:jpgPath toPath:newfpath error:&error ] )
    {
        [ AppDelegate ErrorMessage:@"Cannot copy file to gallery."];
        return nil;
    }
    else
    {
        return newfname;
    }
}

- (void) stopAudio
{
    if ( self.audio!=nil)
    {
        [ self.audio stop ];
        self.audio = nil;
    }
}


- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    UIImage *blended = [ image blendImage:maskImage ];
    return blended;
    
}


-(UIImage *) processTemplate:(UIImage *)insert
{
    //  Load the template...
    UIImage *template = [ UIImage imageNamed:@"email.jpg" ];
    
    // Resize the template to the final res...
    CGSize sz = CGSizeMake(400,600);
    UIImage *rsize_template = [ template
                               resizedImage:sz interpolationQuality:kCGInterpolationHigh ];
    
    //  Resize the insert...
    //CGSize isz = CGSizeMake(240, 320);
    CGSize isz = CGSizeMake(320, 427);
    UIImage *rsize_insert = [ insert
                             resizedImage:isz interpolationQuality:kCGInterpolationHigh ];
    
    //  Place the insert...
    //CGRect rect = CGRectMake(80, 140, 240, 320);
    CGRect rect = CGRectMake(40, 70, 320, 427);
    UIImage *result =
        [ rsize_template pasteImage:rsize_insert bounds:rect ];
    
    UIImage *rot =
        [ UIImage imageWithCGImage:result.CGImage scale:1.0 orientation:UIImageOrientationUp ];
    return rot;
}


-(UIImage *) watermarkImage:(UIImage *)original watermark:(NSString *)path
{
    UIImage *watermark = [ UIImage imageNamed:path ];
    UIImage *mask = [ self maskImage:original withMask:watermark ];
    return mask;
}

-(UIImage *) processTemplateWatermark:(UIImage *)insert
                                 raw1:(UIImageView *)raw1
                                 raw2:(UIImageView *)raw2
                             vertical:(BOOL)vertical
{
    if (vertical)
    {
        //  Load the template...
        UIImage *template = [ UIImage imageNamed:@"email_vert_1200x1800.jpg" ];
    
        // Resize the template to the final res...
        CGSize sz = CGSizeMake(400,600);
        UIImage *rsize_template = [ template
                               resizedImage:sz interpolationQuality:kCGInterpolationHigh ];
    
        //  Resize the insert...
        CGSize isz = CGSizeMake(320, 427);
        UIImage *rsize_insert = [ insert
                             resizedImage:isz interpolationQuality:kCGInterpolationHigh ];
    
        //  Place the insert...
        CGRect rect = CGRectMake(40, 70, 320, 427);
        UIImage *result = [ rsize_template pasteImage:rsize_insert bounds:rect ];
    
        //  Load the watermark...
        UIImage *watermark = [ UIImage imageNamed:@"watermark400x600.png"];
        
        //  Watermark...
        UIImage *watermarked_image = [ self maskImage:result withMask:watermark ];
        
        return watermarked_image;
    }
    else
    {        
        //  Load the template...
        UIImage *template = [ UIImage imageNamed:@"email_horiz_1800x1200.png" ];
        
        // Resize the template to the final res...
        CGSize sz = CGSizeMake(600,400);
        UIImage *rsize_template = [ template
                                   resizedImage:sz interpolationQuality:kCGInterpolationHigh ];
    
        
        CGSize isz = CGSizeMake(256+128+32, 192+96+24); //427, 320);
        UIImage *rsize_insert = [ insert
                                 resizedImage:isz interpolationQuality:kCGInterpolationHigh ];
        raw1.image = rsize_insert;
        
        //  Insert into the verticalized template...
        //  Place the insert...
        CGRect rect = CGRectMake(100, 50, 256+128+32, 192+96+24); //427, 320);
        UIImage *result = [ rsize_template pasteImage:rsize_insert bounds:rect ];
        raw2.image = result;
       
        //  Load the water mark...
        UIImage *watermark = [ UIImage imageNamed:@"watermark600x400.png"];
        
        //  water mark the image...
        UIImage *watermarked_image = [ self maskImage:result withMask:watermark ];
        
        return watermarked_image;
    }
}

#pragma mark - auth / flickr


- (OFFlickrAPIRequest *)flickrRequest
{
	if (!flickrRequest)
    {
		flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:self.flickrContext];
		flickrRequest.delegate = self;
	}
	
	return flickrRequest;
}

-(void) clearRequest
{
    [flickrRequest cancel];
    flickrRequest.delegate = nil;
    flickrRequest = nil;
    flickrContext = nil;
}

- (BOOL)application:(UIApplication *)application openURL:(NSURL *)url sourceApplication:(NSString *)sourceApplication annotation:(id)annotation
{
    
    if ([self flickrRequest].sessionInfo)
    {
        // already running some other request
        NSLog(@"Already running some other request");
    }
    else
    {
        NSString *token = nil;
        NSString *verifier = nil;
        BOOL result = OFExtractOAuthCallback(url, [NSURL URLWithString:SRCallbackURLBaseString], &token, &verifier);
        
        if (!result)
        {
            NSLog(@"Cannot obtain token/secret from URL: %@", [url absoluteString]);
            return NO;
        }
        
        [self flickrRequest].sessionInfo = kGetAccessTokenStep;
        
        [flickrRequest fetchOAuthAccessTokenWithRequestToken:token verifier:verifier];
        
    }
	
    return YES;
}


+ (AppDelegate *)sharedDelegate
{
    return (AppDelegate *)[[UIApplication sharedApplication] delegate];
}

- (void)cancelAction
{
	[flickrRequest cancel];
    
	[self setAndStoreFlickrAuthToken:nil secret:nil];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:SnapAndRunShouldUpdateAuthInfoNotification object:self];
}

- (void)setAndStoreFlickrAuthToken:(NSString *)inAuthToken secret:(NSString *)inSecret
{
	if (![inAuthToken length] || ![inSecret length])
    {
		self.flickrContext.OAuthToken = nil;
        self.flickrContext.OAuthTokenSecret = nil;
        
		[[NSUserDefaults standardUserDefaults]
            removeObjectForKey:kStoredAuthTokenKeyName];
        
        [[NSUserDefaults standardUserDefaults]
            removeObjectForKey:kStoredAuthTokenSecretKeyName];
        
	}
	else
    {
		self.flickrContext.OAuthToken = inAuthToken;
        self.flickrContext.OAuthTokenSecret = inSecret;
		[[NSUserDefaults standardUserDefaults] setObject:inAuthToken forKey:kStoredAuthTokenKeyName];
		[[NSUserDefaults standardUserDefaults] setObject:inSecret forKey:kStoredAuthTokenSecretKeyName];
	}
}

+ (bool) is_context_twitter
{
    AppDelegate *app = [ AppDelegate sharedDelegate ];
    return app.is_twitter;
}

- (OFFlickrAPIContext *)flickrContext
{
    if (!flickrContext)
    {
        if (self.is_twitter)
        {
            flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE__TWITTER_SAMPLE_API_KEY sharedSecret:OBJECTIVE__TWITTER_SAMPLE_API_SHARED_SECRET];
            
        }
        else
        {
            flickrContext = [[OFFlickrAPIContext alloc] initWithAPIKey:OBJECTIVE__FLICKR_SAMPLE_API_KEY sharedSecret:OBJECTIVE__FLICKR_SAMPLE_API_SHARED_SECRET];
        }
        
        NSString *authToken = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenKeyName];
        NSString *authTokenSecret = [[NSUserDefaults standardUserDefaults] objectForKey:kStoredAuthTokenSecretKeyName];
        
        if (([authToken length] > 0) && ([authTokenSecret length] > 0)) {
            flickrContext.OAuthToken = authToken;
            flickrContext.OAuthTokenSecret = authTokenSecret;
        }
    }
    
    return flickrContext;
}

#pragma mark OFFlickrAPIRequest delegate methods
- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthAccessToken:(NSString *)inAccessToken secret:(NSString *)inSecret userFullName:(NSString *)inFullName userName:(NSString *)inUserName userNSID:(NSString *)inNSID
{
    [self setAndStoreFlickrAuthToken:inAccessToken secret:inSecret];
    self.flickrUserName = inUserName;
    
	[[NSNotificationCenter defaultCenter] postNotificationName:SnapAndRunShouldUpdateAuthInfoNotification object:self];
    
    [self flickrRequest].sessionInfo = nil;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    if (inRequest.sessionInfo == kCheckTokenStep)
    {
		self.flickrUserName = [inResponseDictionary valueForKeyPath:@"user.username._text"];
	}
	
	[[NSNotificationCenter defaultCenter] postNotificationName:SnapAndRunShouldUpdateAuthInfoNotification object:self];
    
    [self flickrRequest].sessionInfo = nil;
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
	if (inRequest.sessionInfo == kGetAccessTokenStep)
    {
	}
	else if (inRequest.sessionInfo == kCheckTokenStep)
    {
		[self setAndStoreFlickrAuthToken:nil secret:nil];
	}
	
    
	[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
    
	[[NSNotificationCenter defaultCenter] postNotificationName:SnapAndRunShouldUpdateAuthInfoNotification object:self];
}

@synthesize flickrContext;


@end
