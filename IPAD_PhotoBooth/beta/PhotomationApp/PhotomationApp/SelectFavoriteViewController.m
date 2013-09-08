//
//  SelectFavoriteViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "SelectFavoriteViewController.h"

@interface SelectFavoriteViewController ()

@end

@implementation SelectFavoriteViewController

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

- (void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    NSMutableArray *array = [ NSMutableArray arrayWithObjects:
                             self.first, self.second, self.third, self.fourth, nil];
    NSMutableArray *barray = [ NSMutableArray arrayWithObjects:
                             self.bfirst, self.bsecond, self.bthird, self.bfourth, nil];
     
    for ( int i=0;i < 4; i ++) 
    {
        UIImageView *view = (UIImageView *)[ array objectAtIndex:i ];
        view.hidden = YES;
        UIButton *btn = (UIButton *)[ barray objectAtIndex:i ];
        btn.hidden = YES;
    }
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    int take_count = app.take_count;
    
    
    for ( int i=0;i < take_count; i ++)
    {
        NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",i ];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname ];
        NSLog(@"%@",jpgPath);
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpgPath];
        if (fileExists)
        {
            UIImageView *view = (UIImageView *)[ array objectAtIndex:i ];
            UIImage *image = [[ UIImage alloc ] initWithContentsOfFile:jpgPath ];
            [ view initWithImage:image ];
            view.hidden = NO;

            UIButton *btn = (UIButton *)[ barray objectAtIndex:i ];
            btn.hidden = NO;
        }
    }
    
    //  play the audio...
    if ( app.config.mode == 1) //experience
    {
        [ app.config PlaySound:@"snd_pickfavorite" del:self ];
        self.audio_done = NO;
    }
    
    //  Disable some things in experience mode...
    if ( app.config.mode == 1 )
    { 
        self.btn_gallery.enabled = NO;
        self.btn_photobooth.enabled = NO;
        self.btn_settings.enabled = NO;
    }
    
    //  orient elements...
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
    
    
    //  Start the idle timer...
    [ self restartTimer ];
}

- (void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    
    //  stop any timer...
    [self.timer invalidate];
    self.timer = nil;
    
    //  release audio delegate...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app.config SetSoundDelegate:@"snd_pickfavorite" del:nil];
    [ app.config SetSoundDelegate:@"snd_picked" del:nil];
    
    
    
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
    int timeout = app.config.selectfavview_timeout;
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
        [ app goto_start ];
    }
}


#pragma avdelegate

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audio_done = YES;
}

-(void) goto_shared
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    [ app goto_sharephoto:nil ];
}


-(void) goto_efx
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    [ app goto_efx:nil ];
}

-(IBAction) photo_selected: (id)sender
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    
    //  get image index...
    UIView *view = (UIView *)sender;
    int tag = view.tag;
    
    //  check within bounds
    if ( tag >= app.take_count )
    {
        return;
    }
    
    //  stop experience audio...
    if ( app.config.mode == 1 )
    {
        [ app.config StopSound:@"snd_pickfavorite"];
    }
    
    //  Set the global path to the selected photo...
    app.selected_id = tag;
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",
                       app.selected_id ];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    app.current_photo_path = jpgPath;
    
    //  Play selection sound...
    if ( app.config.mode == 1) //experience
    {
        [ app.config PlaySound:@"snd_picked" del:nil ];
    }
    
    if ( app.config.mode==1) // experience
    {
        [self performSelector:@selector(goto_efx) withObject:self afterDelay:1.0];
    }
    else
    {
        //  Show selected photo screen...
        [ app goto_selectedphoto ];
    }
}


-(IBAction) delete_all:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    
    
    //  Stop experience audio...
    [ app.config StopSound:@"snd_pickfavorite"];
    
    [ app goto_takephoto ];
}


-(IBAction) btn_settings:(id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


#pragma rotate


- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations =
    UIInterfaceOrientationMaskAll;
    return orientations;
}


- (BOOL)shouldAutorotate
{
    return YES;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
    {
        return YES;
    }
    else
    {
        return YES;
    }
}

-(void)orientElements:(UIInterfaceOrientation)toInterfaceOrientation
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        
        self.img_bg.image = [ app.config GetImage:@"your_mp" ];
        
        CGRect rect = CGRectMake(158,137, 217,293);
        self.first.frame = rect;
        self.bfirst.frame = rect;
        
        rect = CGRectMake(393, 137, 221,293);
        self.second.frame = rect;
        self.bsecond.frame = rect;
        
        rect = CGRectMake(158, 453, 217,292);
        self.third.frame = rect;
        self.bthird.frame = rect;
        
        rect = CGRectMake(393, 453, 221,292);
        self.fourth.frame = rect;
        self.bfourth.frame = rect;
        
        rect = CGRectMake(147, 772, 156, 44);
        self.bdelete.frame = rect;
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        
        self.img_bg.image = [ app.config GetImage:@"your_ml" ];
        
        CGRect rect = CGRectMake(289,164, 210,152);
        self.first.frame = rect;
        self.bfirst.frame = rect;
        
        rect = CGRectMake(522, 164, 210,152);
        self.second.frame = rect;
        self.bsecond.frame = rect;
        
        rect = CGRectMake(289, 348, 210,152);
        self.third.frame = rect;
        self.bthird.frame = rect;
        
        rect = CGRectMake(522, 348, 210,152);
        self.fourth.frame = rect;
        self.bfourth.frame = rect;
        
        rect = CGRectMake(434, 560, 156, 44);
        self.bdelete.frame = rect;
        
    }
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}



@end
