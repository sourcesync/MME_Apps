
//
//  GalleryViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/17/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "GalleryViewController.h"

@interface GalleryViewController ()

@end

@implementation GalleryViewController

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
    
    self.views = [ self getImageArray ];

    self.buttons = [ self getButtonArray ];
}

- (void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    
}


-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    /*
    //  Make sure there is at least one image for debugging purposes...
    NSArray *arr = [AppDelegate GetGalleryPhotos ];
    if ( [ arr count] ==0 )
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        NSString *path = [ AppDelegate AddPhotoToGallery:test ];
        
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate];
        app.current_photo_path = path;
        app.current_filtered_path = nil;
        app.active_photo_is_original = YES;
    }
     */
    
    
    //  Make all image slots invisible...
    for (int i=0;i<16;i++)
    {
        UIImageView *v= (UIImageView *)[ self.views objectAtIndex:i ];
        v.hidden = YES;
        v.backgroundColor = [ UIColor blackColor];
        
        UIButton *b = (UIButton *)[ self.buttons objectAtIndex:i ];
        b.hidden = YES;
        
    }
    
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
    
    //  Reset locked orientation if any...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    app.lock_orientation = NO;
}

- (NSArray *) getImageArray
{
    return [ NSArray arrayWithObjects:
            self.one,self.two,self.three,self.four,
            self.five,self.six,self.seven,self.eight,
            self.nine,self.ten,self.eleven,self.twelve,
            self.thirteen,self.fourteen,self.fifteen,self.sixteen,
            nil ];
}

- (NSArray *) getButtonArray
{
    return [ NSArray arrayWithObjects:
            self.bone,self.btwo,self.bthree,self.bfour,
            self.bfive,self.bsix,self.bseven,self.beight,
            self.bnine,self.bten,self.beleven,self.btwelve,
            self.bthirteen,self.bfourteen,self.bfifteen,self.bsixteen,
            nil ];
}


-(IBAction) btnaction_goto_takephoto:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btn_select_photo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int which = btn.tag;
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    
    
    //  Get the photo pair...
    NSArray *pair = (NSArray *)[ self.show_files objectAtIndex:which ];
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
      
    
    [ app goto_galleryselectedphoto ];
    
}


-(IBAction) btnaction_settings: (id)sender
{
    //[ AppDelegate NotImplemented:nil ];
    AppDelegate *app =
    ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    if (app.config.mode==0)
        [ app goto_settings:self ];
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
    int page_size = 12;
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    
    current_orientation = toInterfaceOrientation;
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        //self.img_bg.image = [ UIImage imageNamed:
        //                     @"8-Photomation-iPad-Gallery-Main-Screen-Vertical.jpg" ];
        self.img_bg.image = [ app.config GetImage:@"gallery_p"];
        
        CGRect rect = CGRectMake(119,171, 117,156);
        self.one.frame = rect;
        self.bone.frame = rect;
        
        rect = CGRectMake(258, 171, 117,156);
        self.two.frame = rect;
        self.btwo.frame = rect;
        
        rect = CGRectMake(397, 171, 117,156);
        self.three.frame = rect;
        self.bthree.frame = rect;
        
        rect = CGRectMake(532, 171, 117,156);
        self.four.frame = rect;
        self.bfour.frame = rect;
        
        rect = CGRectMake(119, 353, 117,156);
        self.five.frame = rect;
        self.bfive.frame = rect;
        
        rect = CGRectMake(258, 353, 117, 156);
        self.six.frame = rect;
        self.bsix.frame = rect;
        
        rect = CGRectMake(397, 353, 117,156);
        self.seven.frame = rect;
        self.bseven.frame = rect;
        
        rect = CGRectMake(532, 353, 117,156);
        self.eight.frame = rect;
        self.beight.frame = rect;
        
        rect = CGRectMake(119, 534, 117,156);
        self.nine.frame = rect;
        self.bnine.frame = rect;
        
        rect = CGRectMake(258, 534, 117,156);
        self.ten.frame = rect;
        self.bten.frame = rect;
        
        rect = CGRectMake(397, 534, 117,156);
        self.eleven.frame = rect;
        self.beleven.frame = rect;
        
        rect = CGRectMake(532, 534, 117,156);
        self.twelve.frame = rect;
        self.btwelve.frame = rect;
        
        
        //gw rect = CGRectMake(677, 434,139,105);
        self.thirteen.hidden = YES;
        self.bthirteen.hidden = YES;
        
        //gw rect = CGRectMake(677, 434,139,105);
        self.fourteen.hidden = YES;
        self.bfourteen.hidden = YES;
        
        //gw rect = CGRectMake(677, 434,139,105);
        self.fifteen.hidden = YES;
        self.bfifteen.hidden = YES;
        
        //gw rect = CGRectMake(677, 434,139,105);
        self.sixteen.hidden = YES;
        self.bsixteen.hidden = YES;
        
        //
        rect = CGRectMake(200,944, 73,72);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(347, 944, 73,72);
        self.btn_takephoto.frame = rect;
        
        rect = CGRectMake(490, 944, 73,72);
        self.btn_settings.frame = rect;
        
        rect = CGRectMake(26, 394, 73,72);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(675, 394, 73,72);
        self.btn_right.frame = rect;
        
        page_size = 12;
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        //self.img_bg.image = [ UIImage imageNamed:
        //                     @"8-Photomation-iPad-Gallery-Main-Screen-Horizontal.jpg" ];
        self.img_bg.image = [ app.config GetImage:@"gallery_l"];
        
        CGRect rect = CGRectMake(209,124, 139,105);
        self.one.frame = rect;
        self.bone.frame = rect;
        
        rect = CGRectMake(364,124, 139,105);
        self.two.frame = rect;
        self.btwo.frame = rect;
        
        rect = CGRectMake(521, 124, 139,105);
        self.three.frame = rect;
        self.bthree.frame = rect;
        
        rect = CGRectMake(677, 124, 139,105);
        self.four.frame = rect;
        self.bfour.frame = rect;
        
        rect = CGRectMake(209, 243, 139,105);
        self.five.frame = rect;
        self.bfive.frame = rect;
        
        rect = CGRectMake(364, 243, 139,105);
        self.six.frame = rect;
        self.bsix.frame = rect;
        
        rect = CGRectMake(521, 243, 139,105);
        self.seven.frame = rect;
        self.bseven.frame = rect;
        
        rect = CGRectMake(677, 243, 139,105);
        self.eight.frame = rect;
        self.beight.frame = rect;
        
        rect = CGRectMake(209, 362, 139,105);
        self.nine.frame = rect;
        self.bnine.frame = rect;
        
        rect = CGRectMake(364, 362, 139,105);
        self.ten.frame = rect;
        self.bten.frame = rect;
        
        rect = CGRectMake(521, 362,139,105);
        self.eleven.frame = rect;
        self.beleven.frame = rect;
        
        rect = CGRectMake(677, 362,139,105);
        self.twelve.frame = rect;
        self.btwelve.frame = rect;
        
        rect = CGRectMake(209, 482,139,105);
        self.thirteen.frame = rect;
        self.thirteen.hidden = NO;
        self.bthirteen.frame = rect;
        self.bthirteen.hidden = NO;
        
        rect = CGRectMake(364, 482,139,105);
        self.fourteen.frame = rect;
        self.fourteen.hidden = NO;
        self.bfourteen.frame = rect;
        self.bfourteen.hidden = NO;
        
        rect = CGRectMake(521, 482,139,105);
        self.fifteen.hidden = NO;
        self.fifteen.frame = rect;
        self.bfifteen.hidden = NO;
        self.bfifteen.frame = rect;
        
        rect = CGRectMake(677, 482,139,105);
        self.sixteen.hidden = NO;
        self.sixteen.frame = rect;
        self.bsixteen.hidden = NO;
        self.bsixteen.frame = rect;
        
        //
        rect = CGRectMake(302,689, 73,72);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(476, 689, 73,72);
        self.btn_takephoto.frame = rect;
        
        rect = CGRectMake(645, 689, 73,72);
        self.btn_settings.frame = rect;
        
        rect = CGRectMake(160, 308, 73,72);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(789, 308, 73,72);
        self.btn_right.frame = rect;
        
        page_size = 16;
    }
    
    //  Get global directories...
    NSString *gallerydir = [ AppDelegate GetGalleryDir ];
    NSString *filtereddir = [ AppDelegate GetFilterDir ];
    
    //  HACK: get the last page_size...
    NSArray *pairs = [ AppDelegate GetGalleryPairs ];
    int len = [ pairs count ];
    int first = 0;
    int last = len-1;
    if (len>page_size)
    {
        first = len - page_size;
    }
    
    NSRange range = NSMakeRange( first, last-first+1);
    self.show_files = [ pairs subarrayWithRange:range ];
    
    //  Hide all first and set default aspect to scale fill...
    for ( int i=0; i< 16; i++ )
    {
        UIImageView *v= (UIImageView *)[ self.views objectAtIndex:i ];
        v.hidden = YES;
        v.contentMode = UIViewContentModeScaleToFill;
        
        //  Show the button...
        UIButton *b = (UIButton *)[ self.buttons objectAtIndex:i ];
        b.hidden = YES;
    }
    
    //  Load gallery images into the image views...
    //for (int i=0;i<[ self.show_files count];i++)
    for ( int i=0; i<= (last-first); i++ )
    {
        //  Get the name of the jpg file...
        NSArray *pair = (NSArray *)
            [ pairs objectAtIndex:i];
        
        //  Form path to original file...
        NSString *original =
            (NSString *)[ pair objectAtIndex:0];
        NSString *fullpath =
            [ NSString stringWithFormat:@"%@/%@", gallerydir, original ];
        
        
        //  Is there a filterd version ?  The use it instead !
        NSString *filtered =
            (NSString *)[ pair objectAtIndex:1];
        if ( [ filtered compare:@""] != NSOrderedSame )
        {
            fullpath = [ NSString stringWithFormat:@"%@/%@", filtereddir, original ];
        }
        
        //  Load the image...
        UIImage *image = [ [[ UIImage alloc ]
                            initWithContentsOfFile:fullpath ] autorelease ];
        
        //  Assign to the imageview and show it...
        UIImageView *v= (UIImageView *)[ self.views objectAtIndex:i ];
        v.image = image;
        v.hidden = NO;
        
        //  Depending on current orientation, change the mode for the imageview
        //  to aspect fill...
        if ( current_orientation == UIInterfaceOrientationPortrait )
        {
            if ( image.size.width > image.size.height )
                v.contentMode = UIViewContentModeScaleAspectFit;
        }
        else if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
        {
            if ( image.size.height > image.size.width )
                v.contentMode = UIViewContentModeScaleAspectFit;
        }
        else if ( current_orientation == UIInterfaceOrientationLandscapeRight )
        {
            if ( image.size.height > image.size.width )
                v.contentMode = UIViewContentModeScaleAspectFit;
        }
        
        
        //  Show the button...
        UIButton *b = (UIButton *)[ self.buttons objectAtIndex:i ];
        b.hidden = NO;
    }
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}


@end
