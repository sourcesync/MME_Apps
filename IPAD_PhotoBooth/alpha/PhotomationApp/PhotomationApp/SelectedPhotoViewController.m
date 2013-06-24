//
//  FavoritePhotoViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/15/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "SelectedPhotoViewController.h"

@interface SelectedPhotoViewController ()

@end

@implementation SelectedPhotoViewController

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
    
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    app.start_orientation =uiorientation;
}

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
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"05b-Photomation-iPad-Selected-Photo-Screen-Vertical.jpg" ];
        
        CGRect rect = CGRectMake(173, 132, 422, 567);
        self.selected.frame = rect;
        
        rect = CGRectMake(134, 734, 79, 59);
        self.btn_save.frame = rect;
        
        rect = CGRectMake(260, 726, 112, 77);
        self.btn_efx.frame = rect;
        
        rect = CGRectMake(408, 734, 97, 60);
        self.btn_share.frame = rect;
        
        rect = CGRectMake(566, 733, 73, 61);
        self.btn_trash.frame = rect;
        
        rect = CGRectMake(140, 819, 73, 44);
        self.btn_print.frame = rect;
        
        rect = CGRectMake(185, 935, 97, 85);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(328, 939, 113, 86);
        self.btn_photobooth.frame = rect;
        
        rect = CGRectMake(477, 939, 101, 178);
        self.btn_settings.frame = rect;
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"05b-Photomation-iPad-Selected-Photo-Screen-Horizontal.jpg" ];
        
        CGRect rect = CGRectMake(344, 103, 336, 449);
        self.selected.frame = rect;
        
        rect = CGRectMake(324, 573, 79, 59);
        self.btn_save.frame = rect;
        
        rect = CGRectMake(428, 573, 112, 77);
        self.btn_efx.frame = rect;
        
        rect = CGRectMake(529, 573, 97, 60);
        self.btn_share.frame = rect;
        
        rect = CGRectMake(634, 573, 73, 61);
        self.btn_trash.frame = rect;
        
        rect = CGRectMake(196, 573, 73, 44);
        self.btn_print.frame = rect;
        
        rect = CGRectMake(301, 687, 97, 85);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(452, 687, 113, 86);
        self.btn_photobooth.frame = rect;
        
        rect = CGRectMake(634, 692, 101, 178);
        self.btn_settings.frame = rect;
    }
 
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
    duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  Set current orientation..
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
    
    //  Get and show active photo...
    UIImage *img = [ AppDelegate GetActivePhoto ];
    self.selected.image = img;
    
    
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        self.btn_print.hidden = NO;
    }
    else
    {
        self.btn_print.hidden = YES;
    }
}


-(IBAction) btnaction_print: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ app goto_printview:self ];
}
  
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(IBAction) btnaction_delete:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btnaction_save:(id)sender
{
    [ self playSelection ];
    
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    NSString *fname =
        [ AppDelegate AddPhotoToGallery:app.selected_id is_portrait:app.is_portrait];
     
    if ( fname != nil )
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
        [ app goto_gallery ];
    }
}


- (void) playSelection
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app playSound:app.config.snd_selection delegate:self];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}

-(IBAction) btnaction_gallery:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_gallery ];
}


-(IBAction) btnaction_efx: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

-(IBAction) btnaction_share: (id)sender
{
    //[ AppDelegate NotImplemented:nil ];
    
    
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_sharephoto:self ];
    
    /*
    AppDelegate *app =
        (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = [ AppDelegate 
                       addPhotoToGallery:app.selected_id
                       is_portrait:app.is_portrait ];
    if ( fname !=nil )
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app goto_sharephoto ];
    }
     */
}

-(IBAction) btnaction_settings:(id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btnaction_photobooth:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_takephoto ];
}

@end
