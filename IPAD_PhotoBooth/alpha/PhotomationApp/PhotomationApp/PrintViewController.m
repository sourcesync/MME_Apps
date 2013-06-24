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


-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  ];
}


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)
        [ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = app.current_photo_path;
    
    
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
        
    NSString  *jpgPath = fname;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpgPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:jpgPath ] autorelease];
        
        self.img_selected = image;
        
        float width = image.size.width;
        float height = image.size.height;
        
        if ( width > height )
        {
            self.img_template =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:NO ];
        }
        else
        {
            self.img_template =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:YES ];
        }
        
        //float ewidth = self.image_email.size.width;
        //float eheight = self.image_email.size.height;
        
        self.imgview_template_watermark.image = self.img_template;
        self.imgview_selected_watermark.image = self.img_selected;
        
        
    }
    else
    {
        /*
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        //self.selected_image = test;
        self.imgview_selected.image = test;
        
        UIImage *template = [ app processTemplateWatermark:test ];
        self.imgview_template.image = template;
        //self.templated_image = template;
         */
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
    
    
    
    [ self orientElements:uiorientation ];
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

/*

- (UIImage*) maskImage:(UIImage *)image withMask:(UIImage *)maskImage {
    
    CGImageRef maskRef = maskImage.CGImage;
    
    CGImageRef mask = CGImageMaskCreate(CGImageGetWidth(maskRef),
                                        CGImageGetHeight(maskRef),
                                        CGImageGetBitsPerComponent(maskRef),
                                        CGImageGetBitsPerPixel(maskRef),
                                        CGImageGetBytesPerRow(maskRef),
                                        CGImageGetDataProvider(maskRef), NULL, false);
    
    CGImageRef masked = CGImageCreateWithMask([image CGImage], mask);
    
    return [UIImage imageWithCGImage:masked];
    
}

-(void) processTemplate:(UIImage *)insert
{
    
    //  Mask the insert...
    //UIImage *watermark = [ UIImage imageNamed:@"Photomation-logo-transparent.png"];
    //insert = [ self maskImage:insert withMask:watermark ];
    
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
    //UIImage *result = [ rsize_template pasteImage:watermarked_image bounds:rect ];
    
    UIImage *rot =
        [ UIImage imageWithCGImage:result.CGImage scale:1.0 orientation:UIImageOrientationUp ];
    
    UIImage *watermark = [ UIImage imageNamed:@"Photomation-logo-transparent.png"];
    
    UIImage *watermarked_image = [ self maskImage:rot withMask:watermark ];
    
    self.imgview_template.image = watermarked_image;
    self.templated_image = watermarked_image;
}
*/


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

- (IBAction)btn_printSelected:(id)sender
{
    UIImage *img = self.imgview_selected_watermark.image;
        
    [ self printImage: img ];
}


- (IBAction)btn_printTemplate:(id)sender
{
    UIImage *img = self.imgview_template_watermark.image;
    
    [ self printImage: img ];
}

-(IBAction)btn_donePressed:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ app print_go_back ];
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


- (void)orientElements:(UIInterfaceOrientation)toInterfaceOrientation
{
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        //self.imgview_selected.image = self.selected_image;
        //self.imgview_template.image = self.templated_image;
        

        //self.imgview_selected.image = self.vert_pic;
        //self.imgview_template.image = self.vert_template;
        
        //[self orientElements:toInterfaceOrientation duration:duration zoomScale:self.zoomScale];
        
        if ( self.img_selected.size.width > self.img_selected.size.height )
        {
            self.imgview_selected_watermark.contentMode = UIViewContentModeScaleAspectFit;
            self.imgview_template_watermark.contentMode = UIViewContentModeScaleAspectFit;
        }
        else
        {
            self.imgview_selected_watermark.contentMode = UIViewContentModeScaleToFill;
            self.imgview_template_watermark.contentMode = UIViewContentModeScaleToFill;
        }
        
        
        CGRect rect = CGRectMake(15, 64, 320, 427);
        self.imgview_selected_watermark.frame = rect;
        rect = CGRectMake(355,64,400,600);
        self.imgview_template_watermark.frame = rect;
        rect = CGRectMake(159, 514, 73, 44);
        self.btn_printSelected.frame = rect;
        rect = CGRectMake(519, 691, 73, 44);
        self.btn_printTemplate.frame = rect;
        rect = CGRectMake(659, 935, 73, 44);
        self.btn_done.frame = rect;
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        if ( self.img_selected.size.height > self.img_selected.size.width )
        {
            self.imgview_selected_watermark.contentMode = UIViewContentModeScaleAspectFit;
            self.imgview_template_watermark.contentMode = UIViewContentModeScaleAspectFit;
        }
        else
        {
            self.imgview_selected_watermark.contentMode = UIViewContentModeScaleToFill;
            self.imgview_template_watermark.contentMode = UIViewContentModeScaleToFill;
        }
        //[self orientElements:toInterfaceOrientation duration:duration zoomScale:self.zoomScale];
        CGRect rect = CGRectMake(31,31, 427, 320);
        self.imgview_selected_watermark.frame = rect;
        
        rect = CGRectMake(304,359,600,400);
        self.imgview_template_watermark.frame = rect;
        //self.imgview_template.backgroundColor = [ UIColor redColor];
        
        rect = CGRectMake(152,371, 73, 44);
        self.btn_printSelected.frame = rect;
        rect = CGRectMake(223,716, 73, 44);
        self.btn_printTemplate.frame = rect;
        rect = CGRectMake(921,705, 73, 44);
        self.btn_done.frame = rect;
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
    duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}

@end
