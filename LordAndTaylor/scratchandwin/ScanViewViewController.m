//
//  ScanViewViewController.m
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ScanViewViewController.h"

#import "AppDelegate.h"

#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVAnimation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVMetadataFormat.h>
#import <AVFoundation/AVVideoSettings.h>

@interface ScanViewViewController ()

@end

@implementation ScanViewViewController

@synthesize vImagePreview=_vImagePreview;
@synthesize stillImageOutput=_stillImageOutput;
@synthesize vImage=_vImage;
@synthesize rescan=_rescan;
@synthesize baseImage=_baseImage;
@synthesize fake=_fake;

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
    
    
    self.rescan = NO;
    self.fake = YES;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES  ]; 
    
    if (!self.rescan)
    {
        self.baseImage.image = [ UIImage imageNamed:@"iphone-home-scan.png" ];
        self.vImage.frame = CGRectMake(12, 52, 140, 210);
        self.vImagePreview.frame = CGRectMake(12, 52, 140, 210);
    }
    else 
    {
        self.baseImage.image = 
            //[ UIImage imageNamed:@"iphone-splashscreen-rescan2-hole.png" ];
        [ UIImage imageNamed:@"iphone-rescan.png" ];
        self.vImage.frame = CGRectMake(91, 52, 140, 210);
        self.vImagePreview.frame = CGRectMake(91, 52, 140, 210);
    }
    
    self.vImage.hidden = YES;
    
}

-(void) viewDidAppear:(BOOL)animated
{
    AVCaptureSession *session = [[AVCaptureSession alloc] init];
	session.sessionPreset = AVCaptureSessionPresetHigh;
    
    session.sessionPreset = AVCaptureSessionPreset640x480;
    
	CALayer *viewLayer = self.vImagePreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);
    
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer = [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    
	captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
	[self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
	AVCaptureDevice *device = 
        [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
	NSError *error = nil;
	AVCaptureDeviceInput *input = [AVCaptureDeviceInput deviceInputWithDevice:device error:&error];
	if (!input) 
    {
		// Handle the error appropriately.
		NSLog(@"ERROR: trying to open camera: %@", error);
	}
	[session addInput:input];
    
	[session startRunning];
    
    
    self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *outputSettings = [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
    [self.stillImageOutput setOutputSettings:outputSettings];
    
    [session addOutput:self.stillImageOutput];
}

-(IBAction) captureNow
{
    /*
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Capture" 
                                                    message:@"Before Capture" 
                                                   delegate:nil 
                                          cancelButtonTitle:@"OK"
                                          otherButtonTitles:nil];
    [alert show];
    [alert release];
     */
    
	AVCaptureConnection *videoConnection = nil;
	for (AVCaptureConnection *connection in self.stillImageOutput.connections)
	{
		for (AVCaptureInputPort *port in [connection inputPorts])
		{
			if ([[port mediaType] isEqual:AVMediaTypeVideo] )
			{
				videoConnection = connection;
				break;
			}
		}
		if (videoConnection) { break; }
	}
    
	NSLog(@"about to request a capture from: %@", self.stillImageOutput);
    
    /*
    alert = [[UIAlertView alloc] initWithTitle:@"Capture" 
                                       message:@"About To Capture" 
                                      delegate:nil 
                             cancelButtonTitle:@"OK"
                             otherButtonTitles:nil];
    [alert show];
    [alert release];
    */
    
	[self.stillImageOutput captureStillImageAsynchronouslyFromConnection:videoConnection completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         /*
		 CFDictionaryRef exifAttachments = CMGetAttachment( imageSampleBuffer, kCGImagePropertyExifDictionary, NULL);
		 if (exifAttachments)
		 {
             // Do something with the attachments.
             NSLog(@"attachements: %@", exifAttachments);
		 }
         else
             NSLog(@"no attachments");
         */
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         UIImage *image = [[UIImage alloc] initWithData:imageData];
         
         self.vImage.image = image;
         self.vImage.hidden = NO;
         
         CGImageRef cgImage = [image CGImage];
         ZBarImage *zimg = [ [ ZBarImage alloc ] initWithCGImage: cgImage ];
         
         ZBarImageScanner *zscanner = [[ ZBarImageScanner alloc ] init ];
         NSInteger num_codes = [zscanner scanImage:zimg ];
         
         if ( num_codes > 0 )
         {
             self.rescan = NO;
             
             // Get the code...
             ZBarSymbolSet *data =  zscanner.results;
             NSString *all = [ NSString stringWithFormat:@"" ];
             for(ZBarSymbol *symbol in data) 
             {
                 NSString *item = symbol.data;
                 all = [ NSString stringWithFormat:@"%@%@", all, item ];
                 // process result
             }
             
             // Look for valid code...
             if ( [ all compare:@"1000" ] == NSOrderedSame )
             {
              
                 // Create the download url...
                 NSString *durl = [ NSString stringWithFormat:
                               @"http://favpic.mobi/event/WhiteCastle/images/%@.jpg", all ];
             
                 // Go to download page...
                 AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
                 [ app Download:durl:YES ];
             }
             else if ( [ all compare:@"2000" ]  == NSOrderedSame )
             {
                 
                 // Create the download url...
                 NSString *durl = [ NSString stringWithFormat:
                    @"http://favpic.mobi/event/WhiteCastle/images/%@.jpg", all ];
                 
                 // Go to download page...
                 AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
                 [ app Download:durl:NO ];
             }
             else 
             {
             
                 UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Scratch&Win" 
                                            message:@"This is not a valid QR Code for this app." 
                                           delegate:nil 
                                  cancelButtonTitle:@"OK"
                                  otherButtonTitles:nil];
                 [alert show];
                 [alert release];
                 
                 self.rescan = YES;
                 self.baseImage.image = 
                    //[ UIImage imageNamed:@"iphone-splashscreen-rescan2-hole.png" ];
                    [ UIImage imageNamed:@"iphone-rescan.png" ];
                 self.vImage.frame = CGRectMake(91, 125, 140, 210);
                 self.vImagePreview.frame = CGRectMake(91, 125, 140, 210);
                 self.vImage.hidden = YES;
             }
         }
         else 
         {
             self.rescan = YES;
             self.baseImage.image = 
                //[ UIImage imageNamed:@"iphone-splashscreen-rescan2-hole.png" ];
                [ UIImage imageNamed:@"iphone-rescan.png" ];
             self.vImage.frame = CGRectMake(91, 125, 140, 210);
             self.vImagePreview.frame = CGRectMake(91, 125, 140, 210);
             self.vImage.hidden = YES;
         
         }
	 }];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

-(void) download: (id)sender
{
    [self captureNow ];
    return;
    
    
}



-(IBAction) home:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app Home ];
}


-(IBAction) my_coupons:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app ShowMyCoupons ];
}



@end
