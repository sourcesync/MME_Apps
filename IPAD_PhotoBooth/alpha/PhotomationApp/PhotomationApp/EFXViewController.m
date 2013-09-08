//
//  EFXViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/19/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "EFXViewController.h"

#import "AppDelegate.h"
#import "UIImage+SubImage.h"
#import "UIImage+Resize.h"

@implementation EFXViewController

UIInterfaceOrientation current_orientation;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  Get original file/image...
    self.original_img = [ AppDelegate GetCurrentOriginalPhoto ];
    
    //  Get (any) filtered version that is active...
    self.filtered_img = [ AppDelegate GetCurrentFilteredPhoto ];
    
    //  Is active image original or filtered ?...
    AppDelegate *app = (AppDelegate *) [ [ UIApplication sharedApplication ] delegate ];
    self.use_original = app.active_photo_is_original;
    
    //  Display...
    if (self.use_original)
        self.img_taken.image = self.original_img;
    else
        self.img_taken.image = self.filtered_img;
    
    
    //  play the audio...
    if ( app.config.mode == 1) //experience
    {
        [ app.config PlaySound:@"snd_efx" del:self ];
        self.audio_done = NO;
    }
    
    //  disable buttons in experience mode...
    if ( app.config.mode == 1 )
    {
        self.btn_gallery.enabled = NO;
        self.btn_photobooth.enabled = NO;
        self.btn_settings.enabled = NO;
    }
    
    //  Initialize orientation...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
    
    //  Start the idle timer...
    [ self restartTimer ];
}



-(void)viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    
    //  stop any timer...
    [self.timer invalidate];
    self.timer = nil;
    
    AppDelegate *app = (AppDelegate *) [ [ UIApplication sharedApplication ] delegate ];
    if ( app.config.mode == 1) //experience
    {
        [ app.config SetSoundDelegate:@"snd_efx" del:nil ];
    }
    
    if (self.use_original)
    {
        //  Make sure any filtered version is deleted...
        [ AppDelegate DeleteCurrentFilteredPhoto];
    }
    
}


#pragma avdelegate

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audio_done = YES;
}

#pragma general funcs


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
    
    self.img_taken.image = rot;
    
    return rot;
}



#pragma buttons


-(IBAction) btnaction_gallery:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_gallery ];
}


-(IBAction) btnaction_photobooth:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btnaction_settings:(id)sender
{
    [ AppDelegate NotImplemented:@"" ];
    
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    //[ app goto_settings:self ];
}


-(IBAction) btnaction_yourphoto: (id)sender
{
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    [ app goto_yourphoto ];
}


-(IBAction) btnaction_filter: (id)sender
{
    [ AppDelegate NotImplemented:@"" ];
}


-(IBAction) btnaction_back: (id)sender
{
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    if ( app.config.mode==1) //experience
    {
        [ app goto_selectfavorite];
    }
    else
    {
        [ app efx_go_back ];
    }
}


-(IBAction) btnaction_ilikeit: (id)sender
{
    
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    if ( app.config.mode==1) //experience
    {
        [ app goto_sharephoto:nil ];
    }
    else
    {
        [ app efx_go_back];
    }
}


-(IBAction) btnaction_one: (id)sender
{
    //  Show original...
    self.img_taken.image = self.original_img;
    
    //  Set it globally...
    self.use_original = YES;
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    app.active_photo_is_original = YES;
}


-(IBAction) btnaction_two: (id)sender
{
    //  Filter the original...
    UIImage *filtered = [ self.original_img filterImageBlackAndWhite ];
    
    //  Show the filtered image...
    self.img_taken.image = filtered;
    
    //  Set it globally...
    [ AppDelegate SetCurrentFilteredPhoto:filtered];
    self.use_original = NO;
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    app.active_photo_is_original = NO;
}


-(IBAction) btnaction_three: (id)sender
{
    //  Filter the original...
    UIImage *filtered = [ self.original_img filterImageSepia ];
    
    //  Show the filtered image...
    self.img_taken.image = filtered;
    
    //  Set it globally...
    [ AppDelegate SetCurrentFilteredPhoto:filtered];
    self.use_original = NO;
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    app.active_photo_is_original = NO;
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
    int timeout = app.config.efxview_timeout;
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
    if ( app.config.mode == 1 ) // experience
    {
        [ app goto_sharephoto:nil ];
    }
}


#pragma rotation stuff


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

- (void) reposition: (UIButton*)btn : (CGPoint)pt
{
    CGRect rect = CGRectMake( pt.x, pt.y, btn.frame.size.width, btn.frame.size.height );
    btn.frame = rect;
}

- (void)orientElements: (UIInterfaceOrientation)toInterfaceOrientation
              duration:(NSTimeInterval)duration

{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    current_orientation = toInterfaceOrientation;
    
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"6-Photomation-iPad-EFX-Photo-Screen-Vertical.jpg" ];
        //self.img_bg.frame = CGRectMake(0,0,1024,768);
        
        self.img_taken.frame = CGRectMake(172,132,423,567);
        
        self.btn_back.frame = CGRectMake(8, 20, 129, 44);
        
        self.btn_goback.frame = CGRectMake(255, 857, 129, 44);
        self.btn_ilikeit.frame = CGRectMake(423, 857, 129, 44);
        
        self.btn_one.frame = CGRectMake(172, 711, 73, 106);
        self.btn_two.frame = CGRectMake(261, 711, 73, 106);
        self.btn_three.frame = CGRectMake(348, 711, 73, 106);
        self.btn_four.frame = CGRectMake(435, 711, 73, 106);
        self.btn_five.frame = CGRectMake(523, 711, 73, 106);
        
        self.btn_gallery.frame = CGRectMake(192,941,93,79);
        self.btn_photobooth.frame = CGRectMake(337, 941,93,79);
        self.btn_settings.frame = CGRectMake(480, 941,93,79);
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"6-Photomation-iPad-EFX-Photo-Screen-Horizontal.jpg" ];
        //self.img_bg.frame = CGRectMake(0,0,1024,768);
        
        self.img_taken.frame = CGRectMake(235, 82, 554, 415);
        
        self.btn_back.frame = CGRectMake(13,9, 129, 44);
        
        self.btn_goback.frame = CGRectMake(358,609, 129, 44);
        self.btn_ilikeit.frame = CGRectMake(524,609, 129, 44);
        
        self.btn_one.frame = CGRectMake(229, 505, 113, 83);
        self.btn_two.frame = CGRectMake(343, 505, 113, 83);
        self.btn_three.frame = CGRectMake(456, 505, 113, 83);
        self.btn_four.frame = CGRectMake(570, 505, 113, 83);
        self.btn_five.frame = CGRectMake(683, 505, 113, 83);
        
        self.btn_gallery.frame = CGRectMake(291,682,93,79);
        self.btn_photobooth.frame = CGRectMake(466,682,93,79);
        self.btn_settings.frame = CGRectMake(637,682,93,79);
        
    }
    
    
    //  Depending on current orientation, change the mode for the imageview
    //  to aspect fill...
    if ( current_orientation == UIInterfaceOrientationPortrait )
    {
        if ( self.original_img.size.width > self.original_img.size.height )
            self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
    {
        if ( self.original_img.size.height > self.original_img.size.width )
            self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeRight )
    {
        if ( self.original_img.size.height > self.original_img.size.width )
            self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
    }
    else
    {
        self.img_taken.contentMode = UIViewContentModeScaleToFill;
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        [self orientElements:toInterfaceOrientation duration:duration ];
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        [self orientElements:toInterfaceOrientation duration:duration ];
    }
}




@end
