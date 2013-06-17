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
    NSString *docPath = app.fpath;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:docPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:docPath ] autorelease];
        self.selected.image = image;
        self.selected_img = image;
    }
    
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
}

-(IBAction) btnaction_print:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_printview:self];
    
    //[ AppDelegate NotImplemented:@"" ];
}

-(IBAction) btnaction_delete:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( [ AppDelegate deletePhotoFromGallery:app.fpath ] )
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
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_efx:self ];
}

-(IBAction) btnaction_share: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_sharephoto:self ];
     
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
    current_orientation = toInterfaceOrientation;
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"8-Photomation-iPad-Gallery-Single-Pic-Screen-Vertical.jpg" ];
        
        CGRect rect = CGRectMake(173,161,423,568);
        self.selected.frame = rect;
                
        rect = CGRectMake(159,748,77,65);
        self.btn_print.frame = rect;
        
        rect = CGRectMake(260,748,110,65);
        self.btn_efx.frame = rect;
        
        rect = CGRectMake(402,748,91,65);
        self.btn_share.frame = rect;
        
        rect = CGRectMake(534, 748,77,65);
        self.btn_delete.frame = rect;
        
        rect = CGRectMake(37, 408, 73,72);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(659, 409, 73,72);
        self.btn_right.frame = rect;
        
        rect = CGRectMake(184, 931, 97, 85);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(313, 936, 113, 86);
        self.btn_photobooth.frame = rect;
        
        rect = CGRectMake(463, 931, 101, 178);
        self.btn_settings.frame = rect;
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"8-Photomation-iPad-Gallery-Single-Pic-Screen-Horizontal.jpg" ];
        
        CGRect rect = CGRectMake(280,151,464,346);
        self.selected.frame = rect;
        
        rect = CGRectMake(321, 522, 73, 44);
        self.btn_print.frame = rect;
        
        rect = CGRectMake(416, 522, 73, 44);
        self.btn_efx.frame = rect;
        
        rect = CGRectMake(515, 522, 104, 44);
        self.btn_share.frame = rect;
        
        rect = CGRectMake(637, 522, 73, 44);
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
