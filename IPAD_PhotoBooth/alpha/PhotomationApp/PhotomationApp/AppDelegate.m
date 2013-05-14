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

#import "ChromaVideo.h"

@implementation AppDelegate

- (void)dealloc
{
    //[_window release];
    //[_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation {
    // attempt to extract a token from the url
    return [FBAppCall handleOpenURL:url
                  sourceApplication:sourceApplication
                        withSession:self.session];
}

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
    self.chroma_video = [ [ ChromaVideo alloc ] init ];
    
    //  Never show status bar...
    [[ UIApplication sharedApplication ] setStatusBarHidden:YES ];

    
    //  The one and only one window...
    self.window = [[[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]] autorelease];
    
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

    //  Create the selectedphoto controller...
    self.galleryselectedphoto_view =
        [[[GallerySelectedPhotoViewController alloc]
          initWithNibName:@"GallerySelectedPhotoViewController" bundle:nil] autorelease];
    
    //  Create the selectedphoto controller...
    self.sharephoto_view =
        [[[SharePhotoViewController alloc]
          initWithNibName:@"SharePhotoViewController" bundle:nil] autorelease];
    
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
    
    //  Create the print controller...
    self.twitter_view =
        [[[TwitterViewController alloc]
          initWithNibName:@"TwitterViewController" bundle:nil] autorelease];
    
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
    
    //  take photo auto...
    self.window.rootViewController = self.takephoto_auto_view;
    
    //  test sharing asap...
    //self.window.rootViewController = self.sharephoto_view;
    
    //  test facebook asap...
    //self.window.rootViewController = self.facebook_view;
    
    //  test twitter asap...
    //self.window.rootViewController = self.twitter_view;
    
    //  test the pref area asap...
    //[ self.window addSubview:self.settings_split_view.view ];
    //[self.window setRootViewController:(UIViewController*)self.settings_split_view];
    
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

/*
- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}
 */

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
}
*/

/*
// Optional UITabBarControllerDelegate method.
- (void)tabBarController:(UITabBarController *)tabBarController didEndCustomizingViewControllers:(NSArray *)viewControllers changed:(BOOL)changed
{
}
*/

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
    self.window.rootViewController =self.takephoto_view;
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


-(void) goto_sharephoto
{
    SharePhotoViewController *s = (SharePhotoViewController *)self.sharephoto_view;
    self.window.rootViewController = s;
}

-(void) goto_selectedphoto
{
    SelectedPhotoViewController *s =
        (SelectedPhotoViewController *)self.selectedphoto_view;
    self.window.rootViewController = s;
}


-(void) goto_printview:(UIViewController *)back
{
    self.settingsBack = back;
    
    PrintViewController *s = (PrintViewController *)self.print_view;
    self.window.rootViewController = s;
}


-(void) goto_emailview:(UIViewController *)back
{
    
    self.settingsBack = back;
    
    EmailViewController *s = (EmailViewController *)self.email_view;
    self.window.rootViewController = s;
}


-(void) goto_facebookview:(UIViewController *)back
{
    self.settingsBack = back;
    
    FacebookViewController *s = (FacebookViewController *)self.facebook_view;
    self.window.rootViewController = s;
}


//  Goto the twitter view...
-(void) goto_twitterview:(UIViewController *)back
{
    self.settingsBack = back;
    
    TwitterViewController *s = (TwitterViewController *)self.twitter_view;
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

- (void) playSound:(NSString *)sound delegate:(id<AVAudioPlayerDelegate>) del
{
    if ( self.audio!=nil )
    {
        [self.audio stop];
        self.audio =nil;
        
    }
    NSString *fileName = sound;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    
    NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: path] autorelease];
    
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
    
    //  Get gallery path...
    //NSString  *galleryPath = [ self getGalleryDir ];
    
    //  Form path to file...
    NSString *fullpath = fname; //[ NSString stringWithFormat:@"%@/%@", galleryPath, fname ];
    
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

+ (NSString *)addPhotoToGallery:(int)which
{
    NSError *error = nil;
    
    // Get gallery path...
    NSString  *galleryPath = [ self getGalleryDir ];        
    
    // Form path to new file...
    NSString *uuid = [AppDelegate GetUUID ];
    NSString *newfname = [ NSString stringWithFormat:@"%@.jpg", uuid];
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



@end
