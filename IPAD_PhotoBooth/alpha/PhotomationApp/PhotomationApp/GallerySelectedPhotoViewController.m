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

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    self.selected.image = nil;
    
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
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


-(IBAction) btnaction_delete:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( [ AppDelegate deletePhotoFromGallery:app.fname ] )
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app goto_gallery ];
    }
}

-(IBAction) btnaction_goto_gallery:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_gallery ];
}

-(IBAction) btnaction_goto_takephoto:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btnaction_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btnaction_efx: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

-(IBAction) btnaction_share: (id)sender
{
    //[ AppDelegate NotImplemented:nil ];
    
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_sharephoto ];
     
}


-(IBAction) btnaction_goleft: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

-(IBAction) btnaction_goright: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
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
                             @"gallery_single.jpg" ];
        
        CGRect rect = CGRectMake(173,161,423,568);
        self.selected.frame = rect;
        
        //rect = CGRectMake(134, 734, 79, 59);
        //self.btn_save.frame = rect;
        
        rect = CGRectMake(145,759,101,88);
        self.btn_efx.frame = rect;
        
        rect = CGRectMake(342,759,132,87);
        self.btn_share.frame = rect;
        
        rect = CGRectMake(542, 759,113,87);
        self.btn_delete.frame = rect;
        
        
        rect = CGRectMake(37, 408, 73,72);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(659, 409, 73,72);
        self.btn_right.frame = rect;
        
        
        rect = CGRectMake(145, 759, 97, 85);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(342, 759, 113, 86);
        self.btn_photobooth.frame = rect;
        
        rect = CGRectMake(542, 759, 101, 178);
        self.btn_settings.frame = rect;
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"gallery_single_horizontal.jpg" ];
        
        CGRect rect = CGRectMake(337,91,349,465);
        self.selected.frame = rect;
        
        //rect = CGRectMake(324, 573, 79, 59);
        //self.btn_save.frame = rect;
        
        rect = CGRectMake(337, 573, 112, 77);
        self.btn_efx.frame = rect;
        
        rect = CGRectMake(476, 573, 97, 60);
        self.btn_share.frame = rect;
        
        rect = CGRectMake(633, 573, 73, 61);
        self.btn_delete.frame = rect;
        
        
        rect = CGRectMake(162, 320, 73,72);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(789, 320, 73,72);
        self.btn_right.frame = rect;
        
        
        rect = CGRectMake(296, 687, 97, 85);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(468, 685, 113, 86);
        self.btn_photobooth.frame = rect;
        
        rect = CGRectMake(637, 686, 101, 178);
        self.btn_settings.frame = rect;
    }
    
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}



@end
