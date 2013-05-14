//
//  SharePhotoViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/18/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//


#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

#import "AppDelegate.h"
#import "SharePhotoViewController.h"
#import "UIImage+SubImage.h"
#import "UIImage+Resize.h"

@interface SharePhotoViewController ()

@end

@implementation SharePhotoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}


- (BOOL)shouldAutorotate
{
    return NO;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //NSString *galleryPath = [ AppDelegate getGalleryDir ];
    //NSString *fullPath = [ NSString stringWithFormat:@"%@/%@", galleryPath, self.selected_fname ];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fullPath = app.fname;
                          
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:fullPath ] autorelease];
        self.selected.image= image;
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        self.selected.image= test;
    }
}

-(IBAction) btn_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btn_gallery: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_gallery ];
}


-(IBAction) btn_takephoto: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btn_share: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btn_tweet: (id)sender
{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    //[ app goto_twitterview:self];
    [ self showTweetSheet ];
}


-(IBAction) btn_facebook: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_facebookview:self];
}


-(IBAction) btn_print: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_printview:self ];

}
-(IBAction) btn_email:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_emailview:self ];
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
    UIImage *result = [ rsize_template pasteImage:rsize_insert bounds:rect ];
    
    UIImage *rot = [ UIImage imageWithCGImage:result.CGImage scale:1.0 orientation:UIImageOrientationUp ];
    
    return rot;
}


- (void)showTweetSheet
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = app.fname; //[ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
    
    UIImage *template = nil;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fname];
    if (fileExists)
    {
        UIImage *image = [[[ UIImage alloc ] initWithContentsOfFile:fname ] autorelease];
        //self.imgview_selected.image = image;
        
        template = [ self processTemplate:image ];
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        //self.imgview_selected.image = test;
        
        template = [ self processTemplate:test ];
    }
    
    //  Create an instance of the Tweet Sheet
    SLComposeViewController *tweetSheet = [SLComposeViewController
                                           composeViewControllerForServiceType:
                                           SLServiceTypeTwitter];
    
    // Sets the completion handler.  Note that we don't know which thread the
    // block will be called on, so we need to ensure that any UI updates occur
    // on the main queue
    tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
        switch(result) {
                //  This means the user cancelled without sending the Tweet
            case SLComposeViewControllerResultCancelled:
                break;
                //  This means the user hit 'Send'
            case SLComposeViewControllerResultDone:
                break;
        }
        
        //  dismiss the Tweet Sheet
        dispatch_async(dispatch_get_main_queue(), ^{
            [self dismissViewControllerAnimated:NO completion:^{
                NSLog(@"Tweet Sheet has been dismissed.");
            }];
        });
    };
    
    //  Set the initial body of the Tweet
    [tweetSheet setInitialText:@"#photomation rocks"];
    
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach
    //if (![tweetSheet addImage:[UIImage imageNamed:@"image.jpg"]]) {
    if (![tweetSheet addImage:template ])
    {
        NSLog(@"Unable to add the image!");
    }
    
    /*
    //  Add an URL to the Tweet.  You can add multiple URLs.
    if (![tweetSheet addURL:[NSURL URLWithString:@"http://twitter.com/"]]){
        NSLog(@"Unable to add the URL!");
    }
     */
    
    //  Presents the Tweet Sheet to the user
    [self presentViewController:tweetSheet animated:NO completion:^{
        NSLog(@"Tweet sheet has been presented.");
    }];
}



@end
