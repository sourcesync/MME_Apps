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

@implementation AppDelegate

- (void)dealloc
{
    //[_window release];
    //[_tabBarController release];
    [super dealloc];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
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
        [[[UINavigationController alloc]
          initWithRootViewController:self.signup_login_view ] autorelease ];
    
    //  Create the takephoto controller...
    self.takephoto_view = 
        [[[TakePhotoViewController alloc]
          initWithNibName:@"TakePhotoViewController" bundle:nil] autorelease];
    
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
    
    //  signup/register tabbed controllers are first...
    self.window.rootViewController = self.navController;
    
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

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

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
    self.window.rootViewController =self.takephoto_view;
}

- (void) goto_selectfavorite:(int)count
{
    SelectFavoriteViewController *s = (SelectFavoriteViewController *)self.selectfavorite_view;
    s.take_count = count;
    self.window.rootViewController = s;
}


-(void) goto_galleryselectedphoto:(NSString *)fname
{
    GallerySelectedPhotoViewController *s = (GallerySelectedPhotoViewController *)self.galleryselectedphoto_view;
    s.selected_fname = fname;
    self.window.rootViewController = s;
}


-(void) goto_sharephoto:(NSString *)fname
{
    SharePhotoViewController *s = (SharePhotoViewController *)self.sharephoto_view;
    s.selected_fname = fname;
    self.window.rootViewController = s;
}

-(void) goto_selectedphoto:(int)which count:(int)count
{
    SelectedPhotoViewController *s = (SelectedPhotoViewController *)self.selectedphoto_view;
    s.take_count = count;
    s.selected_id = which;
    self.window.rootViewController = s;
}

-(void) goto_gallery
{
    self.window.rootViewController =self.gallery_view;
}


- (void) playSound:(NSString *)sound delegate:(id<AVAudioPlayerDelegate>) del
{
    
    NSString *fileName = sound;
    
    NSString *path = [[NSBundle mainBundle] pathForResource:fileName ofType:@"wav"];
    
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath: path];
    
    self.audio =[[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:NULL];
    
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
    
    app.alert = [[UIAlertView alloc] initWithTitle:@"Info"
                                                        message:message
                                                       delegate:self
                                              cancelButtonTitle:@"This Feature Not Yet Implemented"
                                              otherButtonTitles:nil];
    [app.alert show];
    [app.alert release];
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
    NSString  *galleryPath = [ self getGalleryDir ];
    
    //  Form path to file...
    NSString *fullpath = [ NSString stringWithFormat:@"%@/%@", galleryPath, fname ];
    
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

@end
