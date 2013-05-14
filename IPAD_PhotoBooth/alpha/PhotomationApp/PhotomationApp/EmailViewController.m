//
//  EmailViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "EmailViewController.h"

#import "AppDelegate.h"
#import "UIImage+Resize.h"
#import "UIImage+SubImage.h"

@interface EmailViewController ()

@end

@implementation EmailViewController

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
    
    self.fld_email.frame =
        CGRectMake( self.fld_email.frame.origin.x, self.fld_email.frame.origin.y,
                   self.fld_email.frame.size.width, 40 );
    //NSString *galleryPath = [ AppDelegate getGalleryDir ];
    //NSString *fullPath = [ NSString stringWithFormat:@"%@/%@", galleryPath, self.selected_fname ];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fullPath = app.fname;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:fullPath ] autorelease];
        self.imageview_selected.image = image;
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        self.imageview_selected.image = test;
    }
}



-(IBAction) btn_fillemail:(id)sender
{
    self.fld_email.text = @"george@devnullenterprises.com";
}


-(UIImage *) processTemplate:(UIImage *)insert
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
    return rot;
    //return result;
}

-(UIImage *) sanitize:(UIImage *)insert
{
    //  Load the template...
    //UIImage *template = [ UIImage imageNamed:@"email.jpg" ];
    
    // Resize the template to the final res...
    //CGSize sz = CGSizeMake(400,600);
    //UIImage *rsize_template = [ template
    //                           resizedImage:sz interpolationQuality:kCGInterpolationHigh ];
    
    //  Resize the insert...
    //CGSize isz = CGSizeMake(240, 320);
    CGSize isz = CGSizeMake( insert.size.width, insert.size.height );
    UIImage *rsize_insert = [ insert
                             resizedImage:isz interpolationQuality:kCGInterpolationHigh ];
    
    //  Place the insert...
    //CGRect rect = CGRectMake(80, 140, 240, 320);
    //CGRect rect = CGRectMake(0, 0, insert.size.width, insert.size.height);
    //UIImage *result = [ rsize_template pasteImage:rsize_insert bounds:rect ];
    
    UIImage *rot = [ UIImage imageWithCGImage:rsize_insert.CGImage scale:1.0 orientation:UIImageOrientationUp ];
    return rot;
    //return result;
}


-(void) postimage:(NSString *)email
{
 //[ self processTemplate ];
 
 //NSString *galleryPath = [ AppDelegate getGalleryDir ];
 //NSString *fullPath = [ NSString stringWithFormat:@"%@/%@", galleryPath, self.selected_fname ];
 
    UIImage *img = self.imageview_selected.image;
    
    //UIImage *template = [ self processTemplate:img ];
    UIImage *template = [ self sanitize:img ];
    
    NSData *imageData = UIImageJPEGRepresentation( template, 1.0f );
    if ( !imageData )
    {
        [ AppDelegate ErrorMessage:@"No image or photo"];
        return;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@ipad_app_send.php", @"http://photomation.mmeink.com/"];
 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
 
 
    NSString *boundary = [NSString
                          stringWithString:@"---------------------------14737809831466499882746641449"];
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",boundary];
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
 
    NSMutableData *body = [NSMutableData data];
 
    //  THE EVENT...
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:
                       @"Content-Disposition: form-data; name=\"event\"\r\n\r\n"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:@"Photomation"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
 
    //  THE EMAIL...
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:
                       @"Content-Disposition: form-data; name=\"email\"\r\n\r\n"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithString:email]
                      dataUsingEncoding:NSUTF8StringEncoding]];
 
    //  Create a guid...
    NSString *uid = [ AppDelegate GetUUID ];
    
    //  THE FILE...
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:
                       @"Content-Disposition: form-data; name=\"photo\"; filename=\"%@.jpg\"\r\n",
                       uid]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString
                       stringWithString:@"Content-Type: application/octet-stream\r\n\r\n"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
 
    [body appendData:[[NSString stringWithFormat:@"\r\n--%@--\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
 
    [request setHTTPBody:body];
 
    NSData *returnData = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
 
    NSLog([NSString stringWithFormat:@"Image Return String: %@", returnString]);
}
 


-(IBAction) btn_send:(id)sender
{
    NSString *email = self.fld_email.text;
    if ([ email rangeOfString:@"@"].location == NSNotFound)
    {
        [ AppDelegate ErrorMessage:@"Invalid email address" ];
    }
    else
    {
        self.btn_cancel.enabled = NO;
        self.btn_done.enabled = NO;
        self.btn_send.enabled = NO;
        
        [ self postimage: email ];
        
        
        self.btn_cancel.enabled = YES;
        self.btn_done.enabled = YES;
        self.btn_send.enabled = YES;
    }
}


-(IBAction)donePressed:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ app settings_go_back ];
}


-(IBAction) btn_cancel:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app settings_go_back ];
}



@end
