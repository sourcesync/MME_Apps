//
//  TakePhotoViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//


#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVAnimation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVMetadataFormat.h>
#import <AVFoundation/AVVideoSettings.h>

#import <UIKit/UIAlertView.h>

#import "TakePhotoViewController.h"

#import "AppDelegate.h"

#define MAX_PHOTOS 4

@interface TakePhotoViewController ()

@end

@implementation TakePhotoViewController

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
    
    //self.view_preview_parent.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    
    
        //CGAffineTransformMakeRotation(M_PI);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated
{
    
    //
    //  Live preview...
    //
    
    //  Get front/back devices...
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices)
    {        
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            if ([device position] == AVCaptureDevicePositionBack)
            {
                self.backCamera = device;
            }
            else
            {
                self.frontCamera = device;
            }
        }
    }
    
    //  We need both cameras...
    if ( !self.backCamera || !self.frontCamera )
    {
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                    message:@"Front and Back cameras are required"
                                    delegate:self
                                    cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
        return;
    }
    
    //  Create video session...
    self.session = [[AVCaptureSession alloc] init];
	self.session.sessionPreset = AVCaptureSessionPresetHigh;
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    
    
    //  Create the preview frame/layer...
	CALayer *viewLayer = self.vImagePreview.layer;
	NSLog(@"viewLayer = %@", viewLayer);
	AVCaptureVideoPreviewLayer *captureVideoPreviewLayer =
        [[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session];
	captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
        [self.vImagePreview.layer addSublayer:captureVideoPreviewLayer];
    
    //  Create the device...
    self.device = self.frontCamera;
    self.vImagePreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    
    //  Create the input...
	NSError *error = nil;
	self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
	if (!self.input)
    {
		// Handle the error appropriately.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Cannot set device input"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
	}
    else
    {
        //  Configure the session and start it...
        [self.session addInput:self.input];
        [self.session startRunning];
    
        //  Prepare still image object...
        self.stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
        NSDictionary *outputSettings =
            [[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil];
        [ self.stillImageOutput setOutputSettings:outputSettings];
        [ self.session addOutput:self.stillImageOutput];
        
        //  Delay finalization of init because it takes camera a little while to start...
        [ self performSelector:@selector(finishInit) withObject:self afterDelay:1 ];
    }
    
    
}

- (void) finishInit
{
    self.view_preview_parent.hidden = NO;
    self.vImage.hidden = YES;
    self.vImagePreview.hidden = NO;
    self.allow_snap = YES;
    
    
    [ self playSound:@"selection" usedel:NO ];
}

-(void) viewWillAppear:(BOOL)animated
{
    self.view_preview_parent.hidden = YES;
    self.vImage.hidden = YES;
    self.vImagePreview.hidden = YES;
    self.allow_snap = NO;
    self.thumb1.hidden = YES;
    self.thumb2.hidden = YES;
    self.thumb3.hidden = YES;
    self.thumb4.hidden = YES;
    self.count = 0;
    self.state = 0;
}

-(void) rotatePreview: (int)degrees
{
    //  rotate the preview image so it matches the video preview...
    float width = self.vImage.frame.size.width;
    float height = self.vImage.frame.size.height;
    self.vImage.layer.anchorPoint = CGPointMake(width/2.0f, height/2.0f);
    self.vImage.center = CGPointMake(CGRectGetWidth(self.view.bounds), 0.0);
    
    // Rotate 90 degrees to hide it off screen
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, degrees*(M_PI/180.0f) );
    self.vImage.transform = rotationTransform;
}

-(IBAction) btn_takephoto:(id)sender
{
    if (self.state==0)
    {
       
        
        [ self getready ];
    }
    
    //[ self captureNow ];
}


-(void) goto_selectfavorite
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [app goto_selectfavorite:MAX_PHOTOS];
    
}

-(IBAction) btn_switchcam:(id)sender
{
    if (self.allow_snap) return;
    
    [ self.session stopRunning];
    [ self.session beginConfiguration];
    
    if ( self.device.position == AVCaptureDevicePositionBack )
    {
        self.device = self.frontCamera;
        [ self.session removeInput:self.input];
        NSError *error = nil;
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        
        self.vImagePreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
       
    }
    else
    {
        self.device = self.backCamera;
        [ self.session removeInput:self.input];
        NSError *error = nil;
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        
        self.vImagePreview.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
    
    if ( self.input)
    {
        [ self.session addInput:self.input];
        [ self.session commitConfiguration];
        [ self.session startRunning];
    }
    else
    {
		// Handle the error appropriately.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Cannot set device input"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];	}
        

}

-(void) captureNow
{
    
    self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightsfull_768_955.png"];
    
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
        
    self.allow_snap = NO;
    
	[self.stillImageOutput  captureStillImageAsynchronouslyFromConnection:videoConnection
                                                       completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
         
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         
         // Get the image, possibly mirrored...
         UIImage *image = nil;
         if ( self.device == self.frontCamera )
         {
             //CIImage *img = [[ CIImage alloc ] initWithData:imageData ];
         
             //image = [[ UIImage alloc ] initWithCIImage:img scale:1.0
                                            //orientation:UIImageOrientationLeftMirrored ];
             
             
             image = [[UIImage alloc] initWithData:imageData];
         }
         else
         {
             image = [[UIImage alloc] initWithData:imageData];
         }
         
         // Set the preview image...
         self.vImage.image = image;
         self.vImage.hidden = NO;
         
         // Set the thumbnail...
         UIImageView *thumb =(UIImageView *) [
                    [ NSArray arrayWithObjects:
                     self.thumb1,self.thumb2,self.thumb3,self.thumb4,nil] objectAtIndex:self.count ];
         thumb.hidden = NO;
         thumb.image = image;
         
         // Hide the video preview...
         self.vImagePreview.hidden = YES;
         
         // Identify the home directory and file name
         NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",self.count];
         NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
         
         // Write the file...
         [imageData writeToFile:jpgPath atomically:YES];
         
         // Change background to just lights on...
         self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightson_768_955.png"];
         
         // Increment count...
         self.count += 1;
         
         // Decide what to do now...
         if (self.count== MAX_PHOTOS)
         {
             // Show bg with lights off...
             self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightsoff_768_955.png"];
             
             // Goto select-favorite view after small delay...
             [ self performSelector:@selector(goto_selectfavorite) withObject:self afterDelay:1 ];
         }
         else
         {
             [ self performSelector:@selector(getready) withObject:self afterDelay:1 ];
         }
         
                  
     }];
}

-(void) getready
{
    self.state = 1;
    
    self.vImage.hidden = YES;
    self.vImagePreview.hidden = NO;
    
    self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightson_768_955.png"];
    
    
    [ self playSound:@"getready" usedel:YES];
}

-(void) countdown
{
    [ self playSound:@"countdown" usedel:YES];
}

- (void) playSound:(NSString *)sound usedel:(BOOL)usedel
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if (usedel)
        [ app playSound:sound delegate:self];
    else
        [ app playSound:sound delegate:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.state==1) // getready done...
    {
        [ self.audio release ];
    
        self.state = 2;
        
        [ self countdown ];
    }
    else if (self.state==2) // countdown done...
    {
        [ self captureNow ];
        
        self.state = 0;
    }
    
}


-(IBAction) btn_goto_gallery: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_gallery ];
}


-(IBAction) btn_settings: (id)sender
{
    [ AppDelegate NotImplemented:nil ];
}
@end
