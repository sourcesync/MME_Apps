//
//  ChromaVideo.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/10/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVAnimation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVMetadataFormat.h>
#import <AVFoundation/AVVideoSettings.h>

#import "ChromaVideoDelegate.h"

@interface ChromaVideo : NSObject
{
    
    //  private members...
    id <ChromaVideoDelegate> delegate;
}


//  video stuff...
@property (nonatomic, retain) AVCaptureSession *session;

//  device stuff...
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCaptureDevice *frontCamera;
@property (nonatomic, retain) AVCaptureDevice *backCamera;

//  input, output stuff...
@property (nonatomic, retain) AVCaptureDeviceInput *input;
@property (nonatomic, retain) AVCaptureVideoDataOutput *captureOutput;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, assign) dispatch_queue_t queue;

//  chroma stuff...
@property (nonatomic, assign) BOOL have_chroma;
@property (nonatomic, assign) uint8_t touch_hue;
@property (nonatomic, assign) uint8_t touch_hue_l;
@property (nonatomic, assign) uint8_t touch_hue_h;
@property (nonatomic, assign) uint8_t touch_saturation;
@property (nonatomic, assign) uint8_t touch_brightness;
@property (nonatomic, assign) uint8_t touch_brightness_l;
@property (nonatomic, assign) uint8_t touch_brightness_h;

//  useful bools...
@property (nonatomic, assign) BOOL is_front;

//  take pic...
@property (nonatomic, retain) NSData *picData;

//  choma stuff...
@property (nonatomic, assign) int touch_x;
@property (nonatomic, assign) int touch_y;
@property (nonatomic, assign) bool new_touch;
@property (nonatomic, assign) uint8_t touch_bl;
@property (nonatomic, assign) uint8_t touch_bh;
@property (nonatomic, assign) uint8_t touch_gl;
@property (nonatomic, assign) uint8_t touch_gh;
@property (nonatomic, assign) uint8_t touch_rl;
@property (nonatomic, assign) uint8_t touch_rh;
@property (nonatomic, assign) int h_toler;
@property (nonatomic, assign) int br_toler;
@property (nonatomic, assign) int total_pix;
@property (nonatomic, assign) int chroma_pix;


//  public funcs...

+ (void) setManual: (AVCaptureDevice *)device;
+ (void) setAuto: (AVCaptureDevice *)device;
+ (BOOL) isLocked: (AVCaptureDevice *)device;
+ (void) setManualWithZone: (AVCaptureDevice *)device pt:(CGPoint)pt;
- (void) switch_cam: (UIView *)camPreview;
-(void) take_pic: (int)idx;
-(void) set_delegate:(id <ChromaVideoDelegate>) delegate;

- (void)vidCaptureOutput:(AVCaptureOutput *)captureOutput
   didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
          fromConnection:(AVCaptureConnection *)connection
           chromaPreview:(UIImageView *)chromaPreview
          label_coverage:(UILabel *)label_coverage
            colorPreview:(UIImageView *)colorPreview
;
@end
