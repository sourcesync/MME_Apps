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

#import "UIImage+Resize.h"

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
    
    //AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    /*
    //
    //  Live preview...
    //
    
    //  Create video session...
    //self.session = [[[AVCaptureSession alloc] init] autorelease];
	//self.session.sessionPreset = AVCaptureSessionPresetHigh;
    //self.session.sessionPreset = AVCaptureSessionPreset640x480;
    AVCaptureSession *session = app.session;
    
    //  Create the preview frame/layer...
	self.captureVideoPreviewLayer =
        [[[AVCaptureVideoPreviewLayer alloc] initWithSession:session] autorelease];
	self.captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:self.captureVideoPreviewLayer];
    
    //  Flip based on camera...
    if (self.is_front)
        self.vImagePreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    
    //  Create the input...
	NSError *error = nil;
	self.input = [AVCaptureDeviceInput deviceInputWithDevice:app.device error:&error];
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
        [session addInput:self.input];
        //[self.session startRunning];
        
        //  Prepare still image object...
        self.stillImageOutput = [[[AVCaptureStillImageOutput alloc] init] autorelease];
        NSDictionary *outputSettings =
        [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
        [ self.stillImageOutput setOutputSettings:outputSettings];
        [ session addOutput:self.stillImageOutput];
        
    }
     */
    
    
    self.queue = dispatch_queue_create("cameraQueue", NULL);
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

-(void) viewDidAppear:(BOOL)animated
{
    
    [ super viewDidAppear:animated ];
    
    //AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    //if (app.chroma_video.have_chroma)
    //{
    //    [ self startChroma ];
    //}
    
}


#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection
{
    if ( !self.chroma_started)
    {
        NSLog(@"deny capture output in tphoto");
        return;
    }
    
    NSLog(@"ok capture output in tphoto");
    AppDelegate *app = ( AppDelegate *)
        [ [ UIApplication sharedApplication] delegate ];
    
    //app.chroma_video.h_toler = self.slider_sensitivity.value;
    //app.chroma_video.br_toler = self.slider_br_sensitivity.value;
    
    [ app.chroma_video vidCaptureOutput:captureOutput
                  didOutputSampleBuffer:sampleBuffer
                         fromConnection:connection
                          chromaPreview:self.chromaView
                         label_coverage:nil
                           colorPreview:nil ];
}

- (void) startChroma
{
    if ( self.chroma_started ) return;
    
    self.chromaView.hidden = NO;
    self.vImagePreview.hidden = YES;
    self.bgView.hidden = NO;
    
    self.chroma_started  = YES;
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [app.chroma_video.captureOutput setSampleBufferDelegate:self queue:self.queue];
    
    
    //dispatch_release(self.queue);
    
}

- (void) stopChroma
{
    if ( !self.chroma_started ) return;
    
    self.chroma_started  = NO;
    
    
    self.chromaView.hidden = YES;
    self.vImagePreview.hidden = NO;
    self.bgView.hidden = YES;

    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [app.chroma_video.captureOutput setSampleBufferDelegate:nil queue:nil];
    
}



- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations =
        UIInterfaceOrientationMaskAll;
    return orientations;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
    {
        return YES;
    }
    else
    {
        return NO;
    }
        //return self.allow_rotation;
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        //  Set the bg image...
        UIImage *img = [ UIImage imageNamed:@"bg_takephoto_lightsoff_768_955.png" ];
        self.img_bg.image = img;
        
        //  Set the flip button...
        self.btn_flip.frame = CGRectMake(347, 664, 76, 40);
        
        //  Tab bar image...
        self.img_tabbar.image = [ UIImage imageNamed:@"tabbar_768_87.png"];
        self.img_tabbar.frame = CGRectMake(0, 917, 768, 87);
        
        //  Tab bar buttons...
        self.btn_gallery.frame = CGRectMake(148,920,112,85);
        self.btn_takephoto.frame = CGRectMake(328,920,113,81);
        self.btn_settings.frame = CGRectMake(516,920,102,85);
        
        //  Camera view...
        self.view_preview_parent.frame = CGRectMake(250,255,272,333);
        self.vImagePreview.transform = CGAffineTransformIdentity;
        self.vImagePreview.frame = CGRectMake( 0, -15, 272, 363 );
        
        AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
        app.chroma_video.captureVideoPreviewLayer.bounds = CGRectMake( 0,0,272,363 ); //150,-50,363,272 );
        app.chroma_video.captureVideoPreviewLayer.position = CGPointMake(136,181);
        app.chroma_video.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
        //self.captureVideoPreviewLayer.transform = CGAffineTransformIdentity;
        //[ self btn_switchcam:self ];
        
    } 
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        //  Set the bg image...
        UIImage *img = [ UIImage imageNamed:@"bg_takephoto_horiz_lightsoff_1024_748.png" ];
        self.img_bg.image = img;
        
        //  Set the flip button...
        self.btn_flip.frame = CGRectMake(473, 576, 76, 40);
        
        //  Tab bar image...
        self.img_tabbar.image = [ UIImage imageNamed:@"tabbar_horiz_1024_86.png"];
        self.img_tabbar.frame = CGRectMake(0, 662, 1024, 86);
        
        //  Tab bar buttons...
        self.btn_gallery.frame = CGRectMake(292,662,88,86);
        self.btn_takephoto.frame = CGRectMake(467,662,88,86);
        self.btn_settings.frame = CGRectMake(637,664,88,86);
        
        //  Camera view...
        self.view_preview_parent.frame = CGRectMake(376,168,272,333);
        self.vImagePreview.transform = CGAffineTransformIdentity;
        [ self rotatePreview:90];
        self.vImagePreview.frame = CGRectMake( 0, -15, 272, 363 );
        
        AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
        app.chroma_video.captureVideoPreviewLayer.bounds = CGRectMake( 0,0,363, 484 ); //272 );
        app.chroma_video.captureVideoPreviewLayer.position = CGPointMake(181,136);
        app.chroma_video.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
        
    }
}


- (void) finishInit
{
    self.view_preview_parent.hidden = NO;
    self.vImage.hidden = YES;
    self.vImagePreview.hidden = NO;
    
    self.allow_snap = YES;
    self.camera_ready = YES;
    
    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    if ( app.chroma_video.have_chroma )
    {
        [ self startChroma ];
    }
    
    [ self playSound:@"selection" usedel:NO ];
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    //  Reset a bunch of vars...
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
    self.camera_ready = NO;
    self.allow_rotation = YES;
    self.allow_settings = YES;
    self.chroma_started = NO;
    self.chromaView.hidden = YES;
    self.bgView.hidden = YES;
    
    //  Allow rotation again...
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    app.lock_orientation = NO;
    
    //  Setup chroma video...
	app.chroma_video.captureVideoPreviewLayer.frame = self.vImagePreview.bounds;
    [self.vImagePreview.layer addSublayer:app.chroma_video.captureVideoPreviewLayer];
    
    //  Flip based on camera and initialize zoom factor...
    if (app.chroma_video.is_front)
        self.vImagePreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    self.zoomScale = 1.0f;
    
    //  Initialize chroma video...
    [ app.chroma_video set_delegate:self ];    
    
    //  Delay finalization of init because it takes camera a little while to start...
    [ self performSelector:@selector(finishInit) withObject:self afterDelay:1 ];

}


-(IBAction) btn_zoom_up: (id)sender
{
    [ self scaleBy:1.02];
}

-(IBAction) btn_zoom_down: (id)sender
{
    float testZoom = self.zoomScale*0.98;
    if ( testZoom>1.0)
        [ self scaleBy:0.98];
}

-(void) scaleBy: (float)factor
{
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    self.zoomScale *= factor;
    
    //  Flip based on camera...
    if (app.chroma_video.is_front)
        self.vImagePreview.transform =
            CGAffineTransformMakeScale(-self.zoomScale,self.zoomScale);
    else
        self.vImagePreview.transform =
            CGAffineTransformMakeScale(self.zoomScale,self.zoomScale);
    
    self.vImage.transform =
        CGAffineTransformMakeScale(self.zoomScale,self.zoomScale);
}

-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //[self.vImagePreview.layer addSublayer:app.captureVideoPreviewLayer];
    
    [ self stopChroma ];
    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [ app.chroma_video.captureVideoPreviewLayer removeFromSuperlayer ];
    
    //[ self.session stopRunning ];
}

-(void) rotatePreview: (int)degrees
{
    //  rotate the preview image so it matches the video preview...
    //float width = self.vImagePreview.frame.size.width;
    //float height = self.vImagePreview.frame.size.height;
    //self.vImagePreview.layer.anchorPoint = CGPointMake(width/2.0f, height/2.0f);
    //self.vImagePreview.center = CGPointMake(CGRectGetWidth(self.view.bounds), 0.0);
    
    // Rotate 90 degrees to hide it off screen
    CGAffineTransform rotationTransform = CGAffineTransformIdentity;
    rotationTransform = CGAffineTransformRotate(rotationTransform, degrees*(M_PI/180.0f) );
    self.vImagePreview.transform = rotationTransform;
}

-(IBAction) btn_takephoto:(id)sender
{
    if (self.state==0)
    {
        self.allow_rotation = NO;
        self.allow_settings = NO;
        [ self getready ];
    }
}


-(void) goto_selectfavorite
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    app.take_count = MAX_PHOTOS;
    
    [app goto_selectfavorite ];
    
}

-(IBAction) btn_switchcam:(id)sender
{
    //return;
    
    if (!self.camera_ready) return;
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app.chroma_video switch_cam:self.vImagePreview ];
    
    /*
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app.session stopRunning];
    [ app.self.session beginConfiguration];
    
    if ( app.device.position == AVCaptureDevicePositionBack )
    {
        app.device = app.frontCamera;
        self.is_front = YES;
        [ app.session removeInput:app.input];
        NSError *error = nil;
        app.input = [AVCaptureDeviceInput deviceInputWithDevice:app.device error:&error];
        
        self.vImagePreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
       
    }
    else
    {
        app.device = app.backCamera;
        self.is_front = NO;
        [ app.session removeInput:app.input];
        NSError *error = nil;
        app.input = [AVCaptureDeviceInput deviceInputWithDevice:app.device error:&error];
        
        self.vImagePreview.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
    
    if ( app.input)
    {
        [ app.session addInput:app.input];
        [ app.session commitConfiguration];
        [ app.session startRunning ];
    }
    else
    {
		// Handle the error appropriately.
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error"
                                                            message:@"Cannot set device input"
                                                           delegate:self
                                                  cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [alertView show];
    }
        
     */

}

-(void) PictureTaken:(NSData *)imageData
{
    
    UIImage  *image= [[[UIImage alloc] initWithData:imageData] autorelease];
    
    // Set the preview image...
    self.vImage.image = image;
    self.vImage.hidden = NO;
    
    // Set the thumbnail...
    UIImageView *thumb =(UIImageView *) [
                                         [ NSArray arrayWithObjects:
                                          self.thumb1,self.thumb2,self.thumb3,self.thumb4,nil] objectAtIndex:self.count ];
    
    
    // Hide the video preview...
    self.vImagePreview.hidden = YES;
    
    // Identify the home directory and file name
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",self.count];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    
    //  Possibly deal with scaling...
    if (self.zoomScale!=1.0)
    {
        int width = image.size.width;
        int rwidth = width * self.zoomScale;
        int height = image.size.height;
        int rheight = (int)image.size.height * self.zoomScale;
        UIImage *resized = [ image resizedImage:CGSizeMake(rwidth,rheight)
                           interpolationQuality:kCGInterpolationHigh ];
        
        int woffset = (int)( (rwidth - width)/2.0 );
        int hoffset = (int)( (rheight - height)/2.0 );
        CGRect fromRect = CGRectMake(woffset, hoffset, width, height); // or whatever rectangle
        CGImageRef drawImage = CGImageCreateWithImageInRect(resized.CGImage, fromRect);
        UIImage *subImage = [UIImage imageWithCGImage:drawImage];
        CGImageRelease(drawImage);
        
        //  TODO: Need to rotate the same as non-zoomed !
        
        //UIImage *ii = [ UIImage imageWithCGImage:subImage.CGImage
        //                                   scale:1.0 orientation:UIImageOrientationRight ];
        
        NSData *imageData = UIImageJPEGRepresentation(subImage, 1.0);
        
        //  Write the file...
        [imageData writeToFile:jpgPath atomically:YES];
        
        //  Set the thumbnail...
        thumb.hidden = NO;
        thumb.image = subImage;
    }
    else
    {
        //  Set the thumbnail...
        thumb.hidden = NO;
        thumb.image = image;
        
        // Write the file...
        [imageData writeToFile:jpgPath atomically:YES];
    }
    
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


}

-(void) captureNow
{
    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightsfull_768_955.png"];
            
    self.allow_snap = NO;
    
    //  Take the pic...
   [ app.chroma_video take_pic:self.count ];
    
    
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
    
    NSURL *url = [ NSURL URLWithString:sound];
    
    if (usedel)
        [ app playSound:url delegate:self];
    else
        [ app playSound:url delegate:nil];
}

- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if (self.state==1) // getready done...
    {
        //[ self.audio release ];
        self.audio = nil;
    
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
    if (self.allow_settings)
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app goto_settings:self ];
    }
}
@end
