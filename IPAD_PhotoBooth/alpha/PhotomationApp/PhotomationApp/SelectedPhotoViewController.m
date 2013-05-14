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
}


- (BOOL)shouldAutorotate
{
    return NO;
}


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpgPath];
    if (fileExists)
    {
        UIImage *image = [[[ UIImage alloc ] initWithContentsOfFile:jpgPath ] autorelease];
        self.selected.image = image;
    }
    
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        self.btn_print.hidden = NO;
    }
    else
    {
        self.btn_print.hidden = YES;
    }
}


-(IBAction) btnPrint: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ app goto_printview:self ];
}
  
- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(IBAction) delete_photo:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    [ app goto_selectfavorite ];
}


-(IBAction) btn_save:(id)sender
{
    
    [ self playSound:@"selection"];
    
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    NSString *fname = [ AppDelegate addPhotoToGallery:app.selected_id ];
    
    if ( fname != nil )
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
        [ app goto_gallery ];
    }
}


- (void) playSound:(NSString *)sound
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app playSound:sound delegate:self];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}

-(IBAction) btn_gallery:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_gallery ];
}


-(IBAction) btn_efx: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

-(IBAction) btn_share: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = [ AppDelegate addPhotoToGallery:app.selected_id ];
    if ( fname !=nil )
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app goto_sharephoto ];
    }
}


-(IBAction) btn_settings:(id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

@end
