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


UIInterfaceOrientation current_orientation;

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


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //
    //  Get photo to share/display...
    //
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  Try first filtered image...
    NSString *fullPath = nil;
    if ( app.current_photo_path && app.current_filtered_path )
    {
        fullPath = app.current_filtered_path;
    }
    else if (app.current_photo_path )
    {
        fullPath = app.current_photo_path;
    }
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:fullPath ] autorelease];
        self.selected.image= image;
        self.selected_img = image;

    }
    
    //  play the audio...
    if ( app.config.mode == 1) //experience
    {
        [ app.config PlaySound:@"snd_share" del:self ];
        self.audio_done = NO;
    }

    
    //  orient elements...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
    
    
    //  Start the idle timer...
    [ self restartTimer ];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    
    //  stop any timer...
    [self.timer invalidate];
    self.timer = nil;
    
    
    //  release audio delegate...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app.config SetSoundDelegate:@"snd_share" del:nil];
    [ app.config StopSound:@"snd_share"];
    
}

#pragma timer


-(void) restartTimer
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  we only do timer stuff in experience mode...
    if ( app.config.mode == 0) return;
    
    //  kill the current timer, if any...
    if (self.timer!=nil) [self.timer invalidate];
    self.timer = nil;
    
    //  start the new timer...
    int timeout = app.config.shareview_timeout;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(timerExpired:)
                                                userInfo:nil
                                                 repeats:NO];
}



-(void) timerExpired: (id)obj
{
    //  If got here, and we are the primary view
    //  then go back to start
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if (app.window.rootViewController == self)
    {
        [ app goto_thanks ];
    }
}

#pragma avdelegate

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audio_done = YES;
}

#pragma actions...
-(IBAction) btnaction_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btnaction_gallery: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_gallery ];
}


-(IBAction) btnaction_takephoto: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btnaction_tweet: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_twitterview:self append_hash_tag:NO];
    
}


-(IBAction) btnaction_facebook: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_facebookview:self];
}


-(IBAction) btnaction_flickr: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_flickrview:self];
}


-(IBAction) btnaction_hash: (id)sender
{
    //[ self showTweetSheet: @"#photomation" ];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_twitterview:self append_hash_tag:YES];

}
-(IBAction) btnaction_email:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_emailview:self ];
}


-(IBAction) btnaction_left:(id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

-(IBAction) btnaction_right:(id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btnaction_print:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_printview:self];
}



-(IBAction) btnaction_back:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( app.config.mode==1) // experience
    {
        [ app goto_efx:nil];
    }
}


-(IBAction) btnaction_done:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( app.config.mode==1) // scripted/experience
    {
        [ app goto_thanks];
    }
    else // app/manual
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app goto_gallery ];
    }
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


- (void)showTweetSheet: (NSString *)hash_string
{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    //NSString *fname = app.fpath; //[ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
    
    
    
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
    if ( hash_string!=nil )
    [tweetSheet setInitialText:hash_string];
    
    //  Adds an image to the Tweet.  For demo purposes, assume we have an
    //  image named 'larry.png' that we wish to attach
    //if (![tweetSheet addImage:[UIImage imageNamed:@"image.jpg"]]) {
    if (![tweetSheet addImage:self.image_tweet ])
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

- (NSUInteger)supportedInterfaceOrientations
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    if ( app.lock_orientation )
    {
        return app.take_pic_supported_orientations;
    }
    else
    {
        NSUInteger orientations = UIInterfaceOrientationMaskAll;
        return orientations;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

-(void)orientElements:(UIInterfaceOrientation)toInterfaceOrientation
{
    current_orientation = toInterfaceOrientation;
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"7-Photomation-iPad-SHARE-Photo-Screen-Vertical.jpg" ];
        
        CGRect rect = CGRectMake(171,131,424,568);
        self.selected.frame = rect;
        
        rect = CGRectMake(184,936,101,88);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(318,934,132,87);
        self.btn_takephoto.frame = rect;
        
        rect = CGRectMake(477,936,113,87);
        self.btn_settings.frame = rect;
        
        rect = CGRectMake(121,730,73,44);
        self.btn_hash.frame = rect;
        
        rect = CGRectMake(230,729,96,67);
        self.btn_facebook.frame = rect;
        
        rect = CGRectMake(336,744,96,67);
        self.btn_tweet.frame = rect;
        
        rect = CGRectMake(447,744,96,67);
        self.btn_flickr.frame = rect;
        
        rect = CGRectMake(558,730,81,66);
        self.btn_email.frame = rect;
        
        //
        rect = CGRectMake(37,407,73,44);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(661,407,73,44);
        self.btn_right.frame = rect;
        
        rect = CGRectMake(20,20,90,50);
        self.btn_back.frame = rect;
        
        rect = CGRectMake(318,839,90,50);
        self.btn_done.frame = rect;
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                               @"7-Photomation-iPad-SHARE-Photo-Screen-Horizontal.jpg" ];
        
        CGRect rect = CGRectMake(212,103,601,452);
        self.selected.frame = rect;
        
        rect = CGRectMake(300,689,73,65);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(476,689,73,65);
        self.btn_takephoto.frame = rect;
        
        rect = CGRectMake(644,689,73,65);
        self.btn_settings.frame = rect;
        
        //
        
        rect = CGRectMake(268,563,73,44);
        self.btn_hash.frame = rect;
        
        rect = CGRectMake(375,563,73,65);
        self.btn_facebook.frame = rect;
        
        rect = CGRectMake(484,563,73,65);
        self.btn_tweet.frame = rect;
        
        rect = CGRectMake(593,563,96,67);
        self.btn_flickr.frame = rect;
        
        rect = CGRectMake(697,563,73,65);
        self.btn_email.frame = rect;
        
        //
        
        rect = CGRectMake(163,311,73,65);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(785,311,73,65);
        self.btn_right.frame = rect;
        
        rect = CGRectMake(14,8,90,50);
        self.btn_back.frame = rect;
        
        rect = CGRectMake(861,526,90,50);
        self.btn_done.frame = rect;
    }
    
    //  Depending on current orientation, change the mode for the imageview
    //  to aspect fill...
    if ( current_orientation == UIInterfaceOrientationPortrait )
    {
        if ( self.selected_img.size.width > self.selected_img.size.height )
            self.selected.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
    {
        if ( self.selected_img.size.height > self.selected_img.size.width )
            self.selected.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeRight )
    {
        if ( self.selected_img.size.height > self.selected_img.size.width )
            self.selected.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        self.selected.contentMode = UIViewContentModeScaleToFill;
    }

    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}




@end
