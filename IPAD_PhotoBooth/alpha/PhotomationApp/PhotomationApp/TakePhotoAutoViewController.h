//
//  TakePhotoAutoViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVAnimation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVMetadataFormat.h>
#import <AVFoundation/AVVideoSettings.h>

#import "ChromaVideo.h"
#import "ChromaVideoDelegate.h"

@interface TakePhotoAutoViewController : UIViewController <AVAudioPlayerDelegate,
ChromaVideoDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

//  camera view stuff...
@property (nonatomic, retain) IBOutlet UIView *camera_normal_view;

//  snapshot view stuff...
@property (nonatomic, retain) IBOutlet UIImageView *camera_snapshot_view;

//  capture stuff...
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

//  chroma stuff...
@property (nonatomic, assign) bool chroma_started;
@property (nonatomic, assign) dispatch_queue_t chroma_queue;

//  zoom stuff...
@property (nonatomic, assign) float zoomScale;

@end
