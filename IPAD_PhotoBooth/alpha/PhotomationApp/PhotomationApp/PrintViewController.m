//
//  PrintViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "PrintViewController.h"

#import "AppDelegate.h"

#import "UIImage+SubImage.h"
#import "UIImage+Resize.h"


@interface PrintViewController ()

@end

@implementation PrintViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
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
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = app.fname; //[ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
    
    //NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    //BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpgPath];
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fname];
    if (fileExists)
    {
        UIImage *image = [[[ UIImage alloc ] initWithContentsOfFile:fname ] autorelease];
        self.imgview_selected.image = image;
        
        [ self processTemplate:image ];
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        self.imgview_selected.image = test;
        
        [ self processTemplate:test ];
    }
    
    if ([UIPrintInteractionController isPrintingAvailable])
    {
        self.btn_printSelected.hidden = NO;
        self.btn_printTemplate.hidden = NO;
    }
    else
    {
        self.btn_printSelected.hidden = YES;
        self.btn_printTemplate.hidden = YES;
    }
}


- (void)printInteractionControllerWillStartJob:(UIPrintInteractionController *)printInteractionController
{
    
    self.btn_done.enabled = NO;
    self.btn_printSelected.enabled = NO;
    self.btn_printTemplate.enabled = NO;
}

- (void)printInteractionControllerDidFinishJob:(UIPrintInteractionController *)printInteractionController
{
    
    self.btn_done.enabled = YES;
    self.btn_printSelected.enabled = YES;
    self.btn_printTemplate.enabled = YES;
}


-(void) processTemplate:(UIImage *)insert
{
    //  Load the template...
    UIImage *template = [ UIImage imageNamed:@"email.jpg" ];
    
    // Resize the template to the final res...
    CGSize sz = CGSizeMake(400,600);
    UIImage *rsize_template = [ template
                               resizedImage:sz interpolationQuality:kCGInterpolationHigh ];
    
    //  Resize the insert...
    //CGSize isz = CGSizeMake(240, 320);
    CGSize isz = CGSizeMake(320, 427);
    UIImage *rsize_insert = [ insert
                             resizedImage:isz interpolationQuality:kCGInterpolationHigh ];
    
    //  Place the insert...
    //CGRect rect = CGRectMake(80, 140, 240, 320);
    CGRect rect = CGRectMake(40, 70, 320, 427);
    UIImage *result = [ rsize_template pasteImage:rsize_insert bounds:rect ];
    
    UIImage *rot = [ UIImage imageWithCGImage:result.CGImage scale:1.0 orientation:UIImageOrientationUp ];
    
    self.imgview_template.image = rot;
}



-(void) printImage:(UIImage *)img
{
    UIPrintInteractionController *pic = [UIPrintInteractionController sharedPrintController];
    
    pic.delegate = self;
    
    pic.printingItem = img;
    
    
    UIPrintInfo *printInfo = [UIPrintInfo printInfo];
    printInfo.outputType = UIPrintInfoOutputGeneral;
    printInfo.jobName = @"photomation";
    pic.printInfo = printInfo;
   
    pic.showsPageRange = YES;
    
    void (^completionHandler)(UIPrintInteractionController *, BOOL, NSError *) =
    ^(UIPrintInteractionController *printController, BOOL completed, NSError *error)
    {
        if (!completed && error)
        {
            NSLog(@"Printing could not complete because of error: %@", error);
        }
        
        self.btn_done.enabled = YES;
        self.btn_printSelected.enabled = YES;
        self.btn_printTemplate.enabled = YES;
    };
    
    [ pic presentAnimated:YES completionHandler:completionHandler ];

}

- (IBAction)printSelected:(id)sender
{
    UIImage *img = self.imgview_selected.image;
        
    [ self printImage: img ];
}


- (IBAction)printTemplate:(id)sender
{
    UIImage *img = self.imgview_template.image;
    
    [ self printImage: img ];
}

-(IBAction)donePressed:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ app settings_go_back ];
}

@end
