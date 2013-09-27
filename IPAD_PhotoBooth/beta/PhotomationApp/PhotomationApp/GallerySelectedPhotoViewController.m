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
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.gallery_pairs = nil;
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    UIImage *img = [ AppDelegate GetActivePhoto ];
    self.selected.image = img;
    self.selected_img = img;
    
    self.gallery_pairs = [ AppDelegate GetGalleryPairs ];
    
    //  Locate the active photo (index) in this list...
    self.current_idx = -1;
    NSString *this_path = [ AppDelegate GetCurrentOriginalPhotoPath ];
    NSString *this_last_part = [ this_path lastPathComponent ];
    NSLog(@"this path-%@", this_path);
    for ( int i=0;i< [ self.gallery_pairs count];i++)
    {
        NSArray *pair = (NSArray *)[ self.gallery_pairs objectAtIndex:i ];
        NSString *path = (NSString *) [ pair objectAtIndex:0 ];
        NSString *last_part = [ path lastPathComponent];
        NSLog(@"compare to gallery path-%@", path);
        if ( [ this_last_part compare:last_part ] == NSOrderedSame )
        {
            self.current_idx = i;
            break;
        }
    }
    if (self.current_idx<0)
    {
        [ AppDelegate ErrorMessage:@"This item is no longer in the gallery"];
    }
    
    //  Initialize orientation...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
}

-(IBAction) btnaction_print:(id)sender
{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    //[ app goto_printview:self];
    
    [ AppDelegate InfoMessage:@"Not Available" ];
}

-(IBAction) btnaction_delete:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //int count = [ self.gallery_pairs count ];
    
    if ( [ AppDelegate DeletePhotoFromGallery:app.current_photo_path ] )
    {
        
        self.gallery_pairs = nil;
        self.gallery_pairs = [ AppDelegate GetGalleryPairs ];
        
        // see if next photo is viable...
        int new_idx = -1;
        if (self.current_idx < [ self.gallery_pairs count ] )
            new_idx = self.current_idx;
        else if ( self.current_idx != 0 )
            new_idx = self.current_idx-1;
    
        if ( new_idx>=0)
        {
            //count = [ self.gallery_pairs count];
        
            //  Get the photo pair...
            //NSArray *pair = (NSArray *)[ self.show_files objectAtIndex:which ];
            NSArray *pair = [ self.gallery_pairs objectAtIndex:new_idx];
            NSString *original = [ pair objectAtIndex:0 ];
            NSString *filtered = [ pair objectAtIndex:1 ];
        
            //  Form full path to original...
            NSString *galleryPath = [ AppDelegate GetGalleryDir ];
            NSString *original_fullpath =
            [ NSString stringWithFormat:@"%@/%@", galleryPath, original ];
            app.current_photo_path = original_fullpath;
            app.active_photo_is_original = YES;
            app.file_name = original;
            app.current_filtered_path = nil;
            app.active_photo_is_gallery = YES;
        
            //  Form full path to filtered if its a file...
            if ( [ filtered compare:@""] != NSOrderedSame )
            {  
                NSString *filterPath = [ AppDelegate GetFilterDir ];
                NSString *filter_fullpath =
                [ NSString stringWithFormat:@"%@/%@", filterPath, filtered ];
                app.current_filtered_path = filter_fullpath;
                app.active_photo_is_original = NO;
            }
        }
        else
        {
            app.current_photo_path = nil;
            app.current_filtered_path = nil;
        }

        [ app goto_gallery ];
    }
    else
    {
        [AppDelegate ErrorMessage:@"Could not delete image"];
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
    AppDelegate *app =
    ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    if (app.config.mode==0)
        [ app goto_settings:self ];
    //[ AppDelegate NotImplemented:nil ];
}


-(IBAction) btnaction_efx: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_efx:self ];
}

-(IBAction) btnaction_share: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( app.config.sharing)
        [ app goto_sharephoto:self ];
    else
        [ AppDelegate InfoMessage:@"Sharing Is Not Enabled."];
     
}

-(void) SetCurrentFromIDX: (int)idx
{
    int which = idx;
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  Get the photo pair...
    NSArray *pair = (NSArray *)[ self.gallery_pairs objectAtIndex:which ];
    NSString *original = [ pair objectAtIndex:0 ];
    NSString *filtered = [ pair objectAtIndex:1 ];
    
    //  Form full path to original...
    NSString *galleryPath = [ AppDelegate GetGalleryDir ];
    NSString *original_fullpath =
    [ NSString stringWithFormat:@"%@/%@", galleryPath, original ];
    app.current_photo_path = original_fullpath;
    app.active_photo_is_original = YES;
    app.file_name = original;
    app.current_filtered_path = nil;
    
    //  Form full path to filtered if its a file...
    if ( [ filtered compare:@""] != NSOrderedSame )
    {
        NSString *filterPath = [ AppDelegate GetFilterDir ];
        NSString *filter_fullpath =
        [ NSString stringWithFormat:@"%@/%@", filterPath, filtered ];
        app.current_filtered_path = filter_fullpath;
        app.active_photo_is_original = NO;
    }
    
    self.selected_img = [ AppDelegate GetActivePhoto ];
    self.selected.image = self.selected_img;

    self.current_idx = which;
}

-(IBAction) btnaction_goleft: (id)sender
{
    //int size = [ self.gallery_pairs count ];
    if (self.current_idx<0)
    {
        [ AppDelegate ErrorMessage:@"An Error Occurred" ];
    }
    else if (self.current_idx==0)
    {
        [ AppDelegate InfoMessage:@"End Reached"];
    }
    else
    {
        [ self SetCurrentFromIDX:(self.current_idx-1) ];
    }
        
}

-(IBAction) btnaction_goright: (id)sender
{
    int size = [ self.gallery_pairs count ];
    if (self.current_idx<0)
    {
        [ AppDelegate ErrorMessage:@"An Error Occurred" ];
    }
    else if ( (size>0) && ( self.current_idx == (size-1) ) )
    {
        [ AppDelegate InfoMessage:@"End Reached"];
    }
    else
    {
        [ self SetCurrentFromIDX:(self.current_idx+1) ];
    }
        
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
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        //self.img_bg.image = [ UIImage imageNamed:
          //                   @"8-Photomation-iPad-Gallery-Single-Pic-Screen-Vertical.jpg" ];
        self.img_bg.image = [ app.config GetImage:@"gal_sel_p" ];
        
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
        //self.img_bg.image = [ UIImage imageNamed:
        //                     @"8-Photomation-iPad-Gallery-Single-Pic-Screen-Horizontal.jpg" ];
        self.img_bg.image = [ app.config GetImage:@"gal_sel_l" ];
        
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
