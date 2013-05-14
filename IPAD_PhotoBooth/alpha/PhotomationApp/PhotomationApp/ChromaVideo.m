//
//  ChromaVideo.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/10/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "ChromaVideo.h"

#import "ChromaVideoDelegate.h"

#import "AppDelegate.h"


@implementation ChromaVideo



-(id)init
{
    
    self.have_chroma = NO;
    
    //  Get front/back devices...
    NSArray *devices = [AVCaptureDevice devices];
    for (AVCaptureDevice *device in devices)
    {
        if ([device hasMediaType:AVMediaTypeVideo])
        {
            if ([device position] == AVCaptureDevicePositionBack)
            {
                self.backCamera = device;
                [ ChromaVideo setAuto:self.backCamera ];
                
            }
            else
            {
                self.frontCamera = device;
                [ ChromaVideo setAuto:self.frontCamera ];
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
        
    }
    
    //  Initial device is front camera...
    self.device = self.frontCamera;
    self.is_front = YES;
    
    //  Initialize video session...
    self.session = [[[AVCaptureSession alloc] init] autorelease];
	self.session.sessionPreset = AVCaptureSessionPresetHigh;
    self.session.sessionPreset = AVCaptureSessionPreset640x480;
    
    [ self.session beginConfiguration ];
    
    //  Create video layer...
	self.captureVideoPreviewLayer =
    [[[AVCaptureVideoPreviewLayer alloc] initWithSession:self.session] autorelease];
    //self.captureVideoPreviewLayer.frame = self.camPreview.bounds;
    //[self.camPreview.layer addSublayer:self.captureVideoPreviewLayer];
    //if ( self.is_front)
    //    self.camPreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    
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
        self.captureOutput = [[AVCaptureVideoDataOutput alloc] init];
        /*While a frame is processes in -captureOutput:didOutputSampleBuffer:fromConnection: delegate methods no other frames are added in the queue.
         If you don't want this behaviour set the property to NO */
        self.captureOutput.alwaysDiscardsLateVideoFrames = YES;
        
        // Set the video output to store frame in BGRA (It is supposed to be faster)
        NSString* key = (NSString*)kCVPixelBufferPixelFormatTypeKey;
        NSNumber* value = [NSNumber numberWithUnsignedInt:kCVPixelFormatType_32BGRA];
        NSDictionary* videoSettings = [NSDictionary dictionaryWithObject:value forKey:key];
        [self.captureOutput setVideoSettings:videoSettings];
        
        //  Bind the input and output...
        [self.session addInput:self.input];
        [self.session addOutput:self.captureOutput];
        
        self.stillImageOutput = [[[AVCaptureStillImageOutput alloc] init] autorelease];
        NSDictionary *outputSettings =
        [[[NSDictionary alloc] initWithObjectsAndKeys: AVVideoCodecJPEG, AVVideoCodecKey, nil] autorelease];
        [ self.stillImageOutput setOutputSettings:outputSettings];
        [ self.session addOutput:self.stillImageOutput];
        
        self.queue = dispatch_queue_create("cameraQueue", NULL);
        
        [ self.session commitConfiguration ];
        [ self.session startRunning];
    }

    return self;
}

- (void) switch_cam: (UIView *)camPreview
{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ self.session stopRunning];
    [ self.session beginConfiguration];
    
    if ( self.device.position == AVCaptureDevicePositionBack )
    {
        self.device = self.frontCamera;
        self.is_front = YES;
        [ self.session removeInput:self.input];
        NSError *error = nil;
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        
        camPreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
        
    }
    else
    {
        self.device = self.backCamera;
        self.is_front = NO;
        [ self.session removeInput:self.input];
        NSError *error = nil;
        self.input = [AVCaptureDeviceInput deviceInputWithDevice:self.device error:&error];
        
        camPreview.transform = CGAffineTransformMakeScale(1.0f, 1.0f);
    }
    
    if ( self.input)
    {
        [ self.session addInput:self.input];
        [ self.session commitConfiguration];
        [ self.session startRunning ];
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

}

+ (BOOL) isLocked: (AVCaptureDevice *)device
{
    if ([device isExposureModeSupported :AVCaptureExposureModeLocked])
    {
        if ( device.exposureMode == AVCaptureExposureModeLocked )
            return YES;
        else
            return NO;
    }
    else
    {
        NSLog(@"Exposure Lock Not Supported");
        return NO;
    }
}


+ (void) setAuto: (AVCaptureDevice *)device
{
    AVCaptureExposureMode emode = AVCaptureExposureModeContinuousAutoExposure;
    AVCaptureWhiteBalanceMode wmode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    AVCaptureFocusMode fmode = AVCaptureFocusModeContinuousAutoFocus;
    
    NSError *error;
    [ device lockForConfiguration:&error];
    
    if ([device isExposureModeSupported :emode])
        device.exposureMode = emode;
    
    if ([device isWhiteBalanceModeSupported:wmode])
        device.whiteBalanceMode = wmode;
    
    if ([device isFocusModeSupported:fmode])
        device.focusMode = fmode;
    
    [ device unlockForConfiguration];
}

+ (void) setManual: (AVCaptureDevice *)device
{
    AVCaptureExposureMode emode = AVCaptureExposureModeLocked;
    AVCaptureFocusMode fmode = AVCaptureFocusModeLocked;
    AVCaptureWhiteBalanceMode wmode = AVCaptureWhiteBalanceModeLocked;
    
    NSError *error;
    [ device lockForConfiguration:&error];
    
    if ([device isExposureModeSupported :emode])
        device.exposureMode = emode;
    
    if ([device isWhiteBalanceModeSupported:wmode])
        device.whiteBalanceMode = wmode;
    
    if ([device isFocusModeSupported:fmode])
        device.focusMode = fmode;
    
    [ device unlockForConfiguration];
}


+ (void) setManualWithZone: (AVCaptureDevice *)device pt:(CGPoint)pt
{
    //  unlock ??
    AVCaptureExposureMode emode = AVCaptureExposureModeAutoExpose;
    AVCaptureFocusMode fmode = AVCaptureFocusModeAutoFocus;
    AVCaptureWhiteBalanceMode wmode = AVCaptureWhiteBalanceModeAutoWhiteBalance;
    
    NSError *error;
    [ device lockForConfiguration:&error];
    
    if ([device isExposureModeSupported :emode])
        device.exposureMode = emode;
    
    if ([device isWhiteBalanceModeSupported:wmode])
        device.whiteBalanceMode = wmode;
    
    if ([device isFocusModeSupported:fmode])
        device.focusMode = fmode;
    
    if ([device isExposurePointOfInterestSupported ])
        device.exposurePointOfInterest = pt;
    else
        NSLog(@"exposure pt not supported");
    
    if ([device isFocusPointOfInterestSupported ])
        device.focusPointOfInterest = pt;
    
    // set lock...
    emode = AVCaptureExposureModeLocked;
    fmode = AVCaptureFocusModeLocked;
    wmode = AVCaptureWhiteBalanceModeLocked;
    
    [ device lockForConfiguration:&error];
    
    if ([device isExposureModeSupported :emode])
        device.exposureMode = emode;
    
    if ([device isWhiteBalanceModeSupported:wmode])
        device.whiteBalanceMode = wmode;
    
    if ([device isFocusModeSupported:fmode])
        device.focusMode = fmode;
    
    [ device unlockForConfiguration];
}


-(void) set_delegate:(id <ChromaVideoDelegate>) del
{
    delegate = del;
}

-(void) take_pic: (int)idx
{
   
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

    [self.stillImageOutput  captureStillImageAsynchronouslyFromConnection:videoConnection
                                                   completionHandler: ^(CMSampleBufferRef imageSampleBuffer, NSError *error)
     {
     
         NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:imageSampleBuffer];
         self.picData = imageData; 
         if (delegate!=nil)
             [ delegate PictureTaken:imageData ];
     }
     ];
     
}


#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)vidCaptureOutput:(AVCaptureOutput *)captureOutput
    didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
          fromConnection:(AVCaptureConnection *)connection
           chromaPreview:(UIImageView *)chromaPreview
          label_coverage:(UILabel *)label_coverage
            colorPreview:(UIImageView *)colorPreview
                  

{
    
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];
    
	/*We create an autorelease pool because as we are not in the main_queue our code is
	 not executed in the main thread. So we have to create an autorelease pool for the thread we are in*/
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    /* convert to image/video dimensions */
    int xx = (int)self.touch_x* 480.0/ (272 - 1);
    int yy = (int)self.touch_y* 640.0/ (363 - 1);
    
    if (self.new_touch) // signal to get the chroma color at touch pixel...
    {
        self.new_touch = NO;
        
        uint8_t *addr = 0;
        
        if (self.is_front)
            addr = (baseAddress + ( xx *bytesPerRow + ( (yy)*4) ));
        else
            addr = (baseAddress + ( (480 - 1 - xx )*bytesPerRow + ( (yy)*4) ));
        
        
        //int toler = self.slider_sensitivity.value;
        //NSLog(@"toler %d\n", toler);
        
        uint8_t touch_b = addr[0];
        //self.touch_bl = MAX( touch_b-toler, 0 );
        //self.touch_bh = MIN( touch_b+toler, 255 );
        
        uint8_t touch_g = addr[1];
        //self.touch_gl = MAX( touch_g-toler, 0 );
        //self.touch_gh = MIN( touch_g+toler, 255 );
        
        uint8_t touch_r = addr[2];
        //self.touch_rl = MAX( touch_r-toler, 0 );
        //self.touch_rh = MIN( touch_r+toler, 255 );
        
        
        NSLog(@" RGB  B %d %d G %d %d R %d %d",
              self.touch_bl, self.touch_bh,
              self.touch_gl, self.touch_gh,
              self.touch_rl, self.touch_rh
              );
        
        
        UIColor *touch_color = [ UIColor colorWithRed:touch_r/255.0 green:touch_g/255.0
                                                 blue:touch_b/255.0 alpha:1.0 ];
        
        
        CGFloat hue, brightness, saturation, alpha;
        [ touch_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ];
        app.chroma_video.touch_hue = (uint8_t) (hue * 0xFF);
        app.chroma_video.touch_hue_l = MAX( app.chroma_video.touch_hue-app.chroma_video.h_toler, 0 );
        app.chroma_video.touch_hue_h = MIN( app.chroma_video.touch_hue+app.chroma_video.h_toler, 255 );
        
        app.chroma_video.br_toler = app.chroma_video.br_toler;
        app.chroma_video.touch_brightness = (uint8_t)( brightness * 0xFF );
        app.chroma_video.touch_brightness_l = MAX( app.chroma_video.touch_brightness-app.chroma_video.br_toler, 0 );
        app.chroma_video.touch_brightness_h = MIN( app.chroma_video.touch_brightness+app.chroma_video.br_toler, 255 );
        
        app.chroma_video.touch_saturation = (uint8_t)( saturation * 0xFF );
        
        NSLog(@" HSB %d %d %d", app.chroma_video.touch_hue, app.chroma_video.touch_saturation,
              app.chroma_video.touch_brightness );
        
        if (colorPreview)
            [colorPreview performSelectorOnMainThread:@selector(setBackgroundColor:)
                                            withObject:touch_color waitUntilDone:YES];
        app.chroma_video.have_chroma = YES;
    }
    
    if (app.chroma_video.have_chroma )
    {
        self.total_pix = 0;
        self.chroma_pix = 0;
        for ( int i=0;i<480;i++)
        {
            for (int k=0;k<640;k++)
            {
                uint8_t *addr = (baseAddress + ( i*bytesPerRow + (k)*4) );
                uint8_t _b = addr[0];
                uint8_t _g = addr[1];
                uint8_t _r = addr[2];
                
                self.total_pix++;
                
                float outH, outS, outL;
                {
                    float r = _r/255.0f;
                    float g = _g/255.0f;
                    float b = _b/255.0f;
                    
                    float h,s, l, v, m, vm, r2, g2, b2;
                    
                    h = 0;
                    s = 0;
                    l = 0;
                    
                    v = MAX(r, g);
                    v = MAX(v, b);
                    m = MIN(r, g);
                    m = MIN(m, b);
                    
                    l = (m+v)/2.0f;
                    
                    if (l <= 0.0)
                    {
                        //if(outH)
                        outH = h;
                        //if(outS)
                        outS = s;
                        //if(outL)
                        outL = l;
                        
                        //return;
                    }
                    else
                    {
                        
                        vm = v - m;
                        s = vm;
                        
                        if (s > 0.0f)
                        {
                            s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
                            
                            {
                                r2 = (v - r)/vm;
                                g2 = (v - g)/vm;
                                b2 = (v - b)/vm;
                                
                                if (r == v){
                                    h = (g == m ? 5.0f + b2 : 1.0f - g2);
                                }else if (g == v){
                                    h = (b == m ? 1.0f + r2 : 3.0 - b2);
                                }else{
                                    h = (r == m ? 3.0f + g2 : 5.0f - r2);
                                }
                                
                                h/=6.0f;
                                
                                //if(outH)
                                outH = h;
                                //if(outS)
                                outS = s;
                                //if(outL)
                                outL = l;
                            }
                            
                            
                        }
                        else
                        {
                            //if(outH)
                            outH = h;
                            //if(outS)
                            outS = s;
                            //if(outL)
                            outL = l;
                            
                            //return;
                        }
                        
                    }
                }
                
                uint8_t hh = (int)(outH * 0xFF);
                //uint8_t ss = (int)(outS * 0xFF);
                uint8_t bb = (int)(outL * 0xFF);
                
                
                if ( ( hh >= app.chroma_video.touch_hue_l ) && ( hh <=app.chroma_video.touch_hue_h ) &&
                    ( bb >= app.chroma_video.touch_brightness_l ) && ( bb <=app.chroma_video.touch_brightness_h ) )
                {
                    addr[0] = 0x00;
                    addr[1] = 0x00;
                    addr[2] = 0x00;
                    addr[3] = 0x00;
                    self.chroma_pix++;
                }
            }
        }
        
        
        /*Create a CGImageRef from the CVImageBufferRef*/
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
        
        /*We release some components*/
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
        
        
        /*We display the result on the custom layer. All the display stuff must be done in the main thread because
         UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
         we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
        //[self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (id) newImage waitUntilDone:YES];
        
        /*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
         Same thing as for the CALayer we are not in the main thread so ...*/
        UIImage *image=
        [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
        //UIImage *image= [UIImage imageWithCGImage:newImage ];
        
        
        /*We relase the CGImageRef*/
        CGImageRelease(newImage);
        
        if (chromaPreview)
            [chromaPreview performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];
        
        if (label_coverage)
        {
            float coverage = (float)(self.chroma_pix*100.0/self.total_pix);
            NSString *text = [ NSString stringWithFormat:@"Coverage: %02.1f%%", coverage ];
            [label_coverage performSelectorOnMainThread:@selector(setText:)
                                              withObject:text waitUntilDone:NO];
        }
        
        //[self.colorPreview performSelectorOnMainThread:@selector(setBackgroundColor:)
        //                                  withObject:touch_color waitUntilDone:YES];
    } // if have_chroma
    
    /*We unlock the  image buffer*/
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
	
    [pool drain];
    
}



@end
