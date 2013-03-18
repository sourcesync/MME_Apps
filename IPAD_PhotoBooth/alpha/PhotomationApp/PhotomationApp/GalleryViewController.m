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
    //  Get the gallery directory...
    NSString *gallerydir = [ AppDelegate getGalleryDir ];
    
    //  HACK: get the last 16...
    NSArray *files = [ AppDelegate getGalleryPhotos ];
    int len = [ files count ];
    int first = MAX(0, len-16 );
    int last = MIN(len-1, 15);
    NSRange range = NSMakeRange( first, last+1 );
    self.show_files = [ files subarrayWithRange:range ];
    
    //  Load gallery images into the image views...
    for (int i=0;i<[ self.show_files count];i++)
    {
        //  Get the name of the jpg file...
        NSString *jpgname = (NSString *)[ self.show_files objectAtIndex:i];
        
        //  Form the full path to the jpg file...
        NSString *fullpath = [ NSString stringWithFormat:@"%@/%@", gallerydir, jpgname ];
        
        //  Load the image...
        UIImage *image = [[ UIImage alloc ] initWithContentsOfFile:fullpath ];
        
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
    
    //  Make all image slots invisible...
    for (int i=0;i<16;i++)
    {
        UIImageView *v= (UIImageView *)[ self.views objectAtIndex:i ];
        v.hidden = YES;
        
        UIButton *b = (UIButton *)[ self.buttons objectAtIndex:i ];
        b.hidden = YES;
        
    }
}

- (NSArray *) getImageArray
{
    return [ NSArray arrayWithObjects:
            self.one,self.two,self.three,self.four,
            self.five,self.six,self.seven,self.eight,
            self.nine,self.ten,self.eleven,self.twelve,
            self.thirteen,self.fourteen,self.fifteen,self.sixteen, nil ];
}

- (NSArray *) getButtonArray
{
    return [ NSArray arrayWithObjects:
            self.bone,self.btwo,self.bthree,self.bfour,
            self.bfive,self.bsix,self.bseven,self.beight,
            self.bnine,self.bten,self.beleven,self.btwelve,
            self.bthirteen,self.bfourteen,self.bfifteen,self.bsixteen, nil ];
}


-(IBAction) btn_goto_takephoto:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btn_select_photo:(id)sender
{
    UIButton *btn = (UIButton *)sender;
    int which = btn.tag;
    
    NSString *fname = [ self.show_files objectAtIndex:which ];
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_galleryselectedphoto:fname ];
    
}


-(IBAction) btn_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}

@end
