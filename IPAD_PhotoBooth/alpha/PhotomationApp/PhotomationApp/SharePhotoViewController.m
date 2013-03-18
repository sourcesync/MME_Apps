//
//  SharePhotoViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/18/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "SharePhotoViewController.h"

@interface SharePhotoViewController ()

@end

@implementation SharePhotoViewController

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

-(void)viewWillAppear:(BOOL)animated
{
    NSString *galleryPath = [ AppDelegate getGalleryDir ];
    NSString *fullPath = [ NSString stringWithFormat:@"%@/%@", galleryPath, self.selected_fname ];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists)
    {
        UIImage *image = [[ UIImage alloc ] initWithContentsOfFile:fullPath ];
        [ self.selected initWithImage:image ];
    }
}

-(IBAction) btn_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


-(IBAction) btn_gallery: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_gallery ];
}


-(IBAction) btn_takephoto: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btn_share: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}


@end
