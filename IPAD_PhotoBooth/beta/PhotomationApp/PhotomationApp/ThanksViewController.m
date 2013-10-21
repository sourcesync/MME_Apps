//
//  ThanksViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 6/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "ThanksViewController.h"

#import "AppDelegate.h"
#import "EmailViewController.h"

@interface ThanksViewController ()

@end

@implementation ThanksViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}


-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  Get the file/image to display...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fullPath = app.current_photo_path;
    if ( !app.active_photo_is_original)
        fullPath = app.current_filtered_path;
        
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists)
    {
        UIImage *image =
        [[[ UIImage alloc ] initWithContentsOfFile:fullPath ] autorelease];
        float width = image.size.width;
        float height = image.size.height;
        
        if ( width > height )
        {
            self.image_email =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:NO ];
        }
        else
        {
            self.image_email =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:YES ];
        }
        self.imageview_selected.image = self.image_email;
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        self.image_email = test;
        self.imageview_selected.image = test;
    }
    self.imageview_selected.hidden = YES;
    
    //  start the timeout timer...
    [ self restartTimer];
    
    
    //  play the audio...
    if ( app.config.mode == 1) //experience
    {
        [ app.config PlaySound:@"snd_thanks" del:self ];
        self.audio_done = NO;
    }

    //  orient elements...
    UIInterfaceOrientation uiorientation =
         [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation duration:0];
    
    //  initiate the send...
    [ self performSelector:@selector(doSend:) withObject:self afterDelay:1 ];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    
    //  stop any timer...
    [self.timer invalidate];
    self.timer = nil;
    
    //  release audio stuff...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app.config SetSoundDelegate:@"snd_thanks" del:nil];
    [ app.config StopSound:@"snd_thanks"];
    
}


#pragma avdelegate

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audio_done = YES;
    
    [ self decide_restart ];
}

-(void) decide_restart
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    if ( self.send_tried && self.audio_done )
    {
        [ app goto_start];
    }
    
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
    self.timer_expired = NO;
    
    //  start the new timer...
    int timeout = app.config.thanksview_timeout;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(timerExpired:)
                                                userInfo:nil
                                                 repeats:NO];
}


-(void) timerExpired: (id)obj
{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    self.timer_expired = YES;
}

#pragma send...

-(void) doSend: (id)obj
{
    self.send_tried = NO;
    
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    
    NSString *email_addr = app.current_email;
    
    UIImage *to_send = self.image_email;
    
    ContentManager *cm = app.cm;
    Configuration *config = app.config;
    
    //
    //  print photo...
    //
    if ( config.printMode!=0)
    {
        NSString *urlString = config.printURL;
        [ EmailViewController postimage_for_print:urlString image:to_send ];
    }
    
    //
    //  Send photo to server...
    //
    NSString *urlServer = [ cm get_setting_string:@"str_email_send_url"];
    NSString *url = [ EmailViewController postimage:email_addr url:urlServer image:to_send ];
    app.landing_page = url;
    
    //
    //  Post to facekbook...
    //
    if ( app.landing_page )
        [ app post_link_to_facebook ];
    
    self.send_tried = YES;
    
    [ self decide_restart ];
    
}


#pragma rotation...



- (NSUInteger)supportedInterfaceOrientations
{
    
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    
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

- (void) reposition: (UIButton*)btn : (CGPoint)pt
{
    CGRect rect = CGRectMake( pt.x, pt.y, btn.frame.size.width, btn.frame.size.height );
    btn.frame = rect;
}

- (void)orientElements: (UIInterfaceOrientation)toInterfaceOrientation
              duration:(NSTimeInterval)duration

{
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ app.config GetImage:@"thx_p" ];
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ app.config GetImage:@"thx_l" ];
    }
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ app.config GetImage:@"thanks_p"];
        [self orientElements:toInterfaceOrientation duration:duration ];
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ app.config GetImage:@"thanks_l"];
        [self orientElements:toInterfaceOrientation duration:duration ];
    }
}



@end
