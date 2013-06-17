//
//  EFXViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/19/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "EFXViewController.h"

#import "AppDelegate.h"

@interface EFXViewController ()

@end

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
    
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    //NSString *fname =
    //    [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
    //NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    NSString *jpgPath = app.fpath;
    
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
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
    
    
    
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
    [ app efx_go_back ];
}


-(IBAction) btnaction_ilikeit: (id)sender
{
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    
    //  Save to gallery in app mode, because we got here from take-pic and we
    //  haven't saved to gallery yet...
    NSString *fname = [ AppDelegate addPhotoToGallery:0
                                          is_portrait:app.is_portrait];
    if (fname!=nil)
    {
        //  In app mode, go to share photo now...
        [ app goto_sharephoto:self ];
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
        
        self.btn_back.frame = CGRectMake(2,11, 129, 44);
        
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
