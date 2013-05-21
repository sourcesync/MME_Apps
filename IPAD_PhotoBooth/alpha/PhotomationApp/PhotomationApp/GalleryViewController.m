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
    
    //  Get the gallery directory...
    NSString *gallerydir = [ AppDelegate getGalleryDir ];
    
    //  HACK: get the last 12...
    NSArray *files = [ AppDelegate getGalleryPhotos ];
    int len = [ files count ];
    int first = 0;
    int last = len-1;
    if (len>12)
    {
        first = len - 12;
    }
    
    NSRange range = NSMakeRange( first, last-first+1);
    self.show_files = [ files subarrayWithRange:range ];
    
    //  Load gallery images into the image views...
    //for (int i=0;i<[ self.show_files count];i++)
    for ( int i=0; i<= (last-first); i++ )
    {
        //  Get the name of the jpg file...
        NSString *jpgname = (NSString *)[ files objectAtIndex:i];
        
        //  Form the full path to the jpg file...
        NSString *fullpath = [ NSString stringWithFormat:@"%@/%@", gallerydir, jpgname ];
        
        //  Load the image...
        UIImage *image = [ [[ UIImage alloc ] initWithContentsOfFile:fullpath ] autorelease ];
        
        //  Assign to the imageview and show it...
        UIImageView *v= (UIImageView *)[ self.views objectAtIndex:i ];
        v.image = image;
        v.hidden = NO;
        
        //  Show the button...
        UIButton *b = (UIButton *)[ self.buttons objectAtIndex:i ];
        b.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  Make all image slots invisible...
    for (int i=0;i<12;i++)
    {
        UIImageView *v= (UIImageView *)[ self.views objectAtIndex:i ];
        v.hidden = YES;
        
        UIButton *b = (UIButton *)[ self.buttons objectAtIndex:i ];
        b.hidden = YES;
        
    }
    
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
}

- (NSArray *) getImageArray
{
    return [ NSArray arrayWithObjects:
            self.one,self.two,self.three,self.four,
            self.five,self.six,self.seven,self.eight,
            self.nine,self.ten,self.eleven,self.twelve, nil ];
}

- (NSArray *) getButtonArray
{
    return [ NSArray arrayWithObjects:
            self.bone,self.btwo,self.bthree,self.bfour,
            self.bfive,self.bsix,self.bseven,self.beight,
            self.bnine,self.bten,self.beleven,self.btwelve, nil ];
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
    
    NSString *fname = [ self.show_files objectAtIndex:which ];
    NSString *galleryPath = [ AppDelegate getGalleryDir ];
    NSString *docPath = [ NSString stringWithFormat:@"%@/%@", galleryPath, fname ];
    //NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:docPath];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    app.fname = docPath;
    
    [ app goto_galleryselectedphoto ];
    
}


-(IBAction) btnaction_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
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
                             @"06-Photomation-iPad-Gallery-Main-Screen-Vertical.jpg" ];
        
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
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ UIImage imageNamed:
                             @"06-Photomation-iPad-Gallery-Main-Screen-Horizontal.jpg" ];
        
        CGRect rect = CGRectMake(276,109, 104,143);
        self.one.frame = rect;
        self.bone.frame = rect;
        
        rect = CGRectMake(399,109, 104,143);
        self.two.frame = rect;
        self.btwo.frame = rect;
        
        rect = CGRectMake(523, 109, 104,143);
        self.three.frame = rect;
        self.bthree.frame = rect;
        
        rect = CGRectMake(645, 109, 104,143);
        self.four.frame = rect;
        self.bfour.frame = rect;
        
        rect = CGRectMake(276, 272, 104,143);
        self.five.frame = rect;
        self.bfive.frame = rect;
        
        rect = CGRectMake(399, 272, 104,143);
        self.six.frame = rect;
        self.bsix.frame = rect;
        
        rect = CGRectMake(523, 272, 104,143);
        self.seven.frame = rect;
        self.bseven.frame = rect;
        
        rect = CGRectMake(645, 272, 104,143);
        self.eight.frame = rect;
        self.beight.frame = rect;
        
        rect = CGRectMake(276, 434, 104,143);
        self.nine.frame = rect;
        self.bnine.frame = rect;
        
        rect = CGRectMake(399, 434, 104,143);
        self.ten.frame = rect;
        self.bten.frame = rect;
        
        rect = CGRectMake(523, 434, 104,143);
        self.eleven.frame = rect;
        self.beleven.frame = rect;
        
        rect = CGRectMake(645, 434, 104,143);
        self.twelve.frame = rect;
        self.btwelve.frame = rect;
        
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
    }
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}


@end
