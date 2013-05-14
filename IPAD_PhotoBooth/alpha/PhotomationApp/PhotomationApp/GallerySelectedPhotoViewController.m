//
//  GallerySelectedPhotoViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/18/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "GallerySelectedPhotoViewController.h"

@interface GallerySelectedPhotoViewController ()

@end

@implementation GallerySelectedPhotoViewController

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


- (BOOL)shouldAutorotate
{
    return NO;
}


-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    self.selected.image = nil;
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
    //NSString *galleryPath = [ AppDelegate getGalleryDir ];
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //NSString *fullPath = [ NSString stringWithFormat:@"%@/%@", galleryPath, app.fname ];
    NSString *docPath = app.fname;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:docPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:docPath ] autorelease];
        self.selected.image = image;
    }
}


-(IBAction) btn_delete:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( [ AppDelegate deletePhotoFromGallery:app.fname ] )
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app goto_gallery ];
    }
}

-(IBAction) btn_goto_gallery:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_gallery ];
}

-(IBAction) btn_goto_takephoto:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btn_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btn_efx: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

-(IBAction) btn_share: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_sharephoto ];
}

@end
