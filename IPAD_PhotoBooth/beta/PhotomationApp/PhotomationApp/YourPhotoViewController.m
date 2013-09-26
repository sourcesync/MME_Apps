//
//  YourPhotoViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/31/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "YourPhotoViewController.h"

#import "AppDelegate.h"

@interface YourPhotoViewController ()

@end

@implementation YourPhotoViewController


UIInterfaceOrientation current_orientation;

- (void)didReceiveMemoryWarning
{
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
    [ super didReceiveMemoryWarning];
}

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


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    NSString *fname =
        [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpgPath];
    if (fileExists)
    {
        UIImage *image = [[[ UIImage alloc ]
                           initWithContentsOfFile:jpgPath ] autorelease];
        //float width = image.size.width;
        //float height = image.size.height;
        
        self.img_taken.image = image;
        self.selected_img = image;
    }
    
    //  disable a few things in experience mode...
    if ( app.config.mode == 1 )
    {
        self.btn_gallery.enabled = NO;
        self.btn_photobooth.enabled = NO;
        self.btn_settings.enabled = NO;
    }
    
    //  orient elements...
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
    
    
    
}

#pragma button actions

-(IBAction) btnaction_goto_takephoto: (id)sender
{
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btnaction_goto_efx: (id)sender
{
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    
    //  Set taken photo as current photo globally...
    NSString *fname =
        [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    app.current_photo_path = jpgPath;
    app.file_name = fname;
    app.current_filtered_path = nil;
    app.active_photo_is_original = YES;
    [ AppDelegate DeleteCurrentFilteredPhoto];
    
    //  Save it to the gallery..
    [ AppDelegate AddPhotoToGallery:self.selected_img];
    
    //  Next screen is efx ( the back button should take you to take photo )...
    [ app goto_efx: app.takephoto_manual_view ];
}


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
    AppDelegate *app =
    ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    if (app.config.mode==0)
        [ app goto_settings:self ];
    //[ AppDelegate NotImplemented:@"" ];
    
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    //[ app goto_settings:self ];
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
    CGRect rect =
        CGRectMake( pt.x, pt.y, btn.frame.size.width, btn.frame.size.height );
    btn.frame = rect;
}

- (void)orientElements: (UIInterfaceOrientation)toInterfaceOrientation
              duration:(NSTimeInterval)duration
            
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    current_orientation = toInterfaceOrientation;
    
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        //self.img_bg.image = [ UIImage imageNamed:
        //                     @"5-Photomation-iPad-Your-Photo-Screen-Vertical.jpg" ];
        self.img_bg.image = [ app.config GetImage:@"your_ap" ];
        //self.img_bg.frame = CGRectMake(0,0,1024,768);
        
        self.img_taken.frame = CGRectMake(172,132,423,567);
        
        self.btn_back.frame = CGRectMake(8, 20, 129, 44);
        self.btn_takeagain.frame = CGRectMake(235, 741, 129, 44);
        self.btn_ilikeit.frame = CGRectMake(405, 741, 129, 44);
        
        self.btn_gallery.frame = CGRectMake(192,941,93,79);
        self.btn_photobooth.frame = CGRectMake(337, 941,93,79);
        self.btn_settings.frame = CGRectMake(480, 941,93,79);
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ app.config GetImage:@"your_al" ];
        //self.img_bg.image = [ UIImage imageNamed:
        //                     @"5-Photomation-iPad-your-Photo-Screen-Horizontal.jpg" ];
        //self.img_bg.frame = CGRectMake(0,0,1024,768);
        
        self.img_taken.frame = CGRectMake(210,102,603,451);
        
        self.btn_back.frame = CGRectMake(2,11, 129, 44);
        self.btn_takeagain.frame = CGRectMake(365,616, 129, 44);
        self.btn_ilikeit.frame = CGRectMake(535,616, 129, 44);
        
        self.btn_gallery.frame = CGRectMake(291,682,93,79);
        self.btn_photobooth.frame = CGRectMake(466,682,93,79);
        self.btn_settings.frame = CGRectMake(637,682,93,79);
             
    }
    
    
    //  Depending on current orientation, change the mode for the imageview
    //  to aspect fill...
    if ( current_orientation == UIInterfaceOrientationPortrait )
    {
        if ( self.selected_img.size.width > self.selected_img.size.height )
            self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
    {
        if ( self.selected_img.size.height > self.selected_img.size.width )
            self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeRight )
    {
        if ( self.selected_img.size.height > self.selected_img.size.width )
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
