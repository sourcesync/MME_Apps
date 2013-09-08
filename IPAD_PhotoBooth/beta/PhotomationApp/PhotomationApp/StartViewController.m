//
//  StartViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 6/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//


#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "StartViewController.h"
#import "AppDelegate.h"


@implementation StartViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

-(void)logAllFilters {
    NSArray *properties = [CIFilter filterNamesInCategory:
                           kCICategoryBuiltIn];
    NSLog(@"%@", properties);
    for (NSString *filterName in properties) {
        CIFilter *fltr = [CIFilter filterWithName:filterName];
        NSLog(@"%@", [fltr attributes]);
    }
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //[ self logAllFilters ];
    
    //  Add tap recognizer...
    UITapGestureRecognizer *singleTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(singleTapGestureCaptured:)];
    [self.imgview_bg addGestureRecognizer:singleTap];
    [self.imgview_bg setMultipleTouchEnabled:YES];
    [self.imgview_bg setUserInteractionEnabled:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  play the audio...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    [ app.config PlaySound:@"snd_welcome" del:self ];
    self.audio_done = NO;
    
    //  orient elements...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation duration:0];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    
    //  unset delegates...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate];
    [ app.config SetSoundDelegate:@"snd_welcome" del:nil];
    [ app.config StopSound:@"snd_welcome"];
}

#pragma actions

- (void)singleTapGestureCaptured:(UITapGestureRecognizer *)gesture
{
    //if (self.audio_done)
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate];
        [ app goto_emailview:self ];
    }
}


#pragma avdelegate

-(void) audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    self.audio_done = YES;
}


#pragma rotation


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
        self.imgview_bg.image = [ app.config GetImage:@"start_p" ];
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ app.config GetImage:@"start_l" ];
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
