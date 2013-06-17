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
#import "CameraView.h"

@interface TakePhotoAutoViewController : UIViewController
    <AVAudioPlayerDelegate,
    ChromaVideoDelegate,
    AVCaptureVideoDataOutputSampleBufferDelegate>


//  preview parent...
@property (nonatomic, retain) IBOutlet UIView *preview_parent;

//  camera view stuff...
@property (nonatomic, retain) IBOutlet UIView *camera_normal_view;

//  snapshot view stuff...
@property (nonatomic, retain) IBOutlet UIImageView *camera_snapshot_view;

//  background image...
@property (nonatomic, retain) IBOutlet UIImageView *img_bg;

//  tab bar buttons...
@property (nonatomic, retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic, retain) IBOutlet UIButton *btn_photobooth;
@property (nonatomic, retain) IBOutlet UIButton *btn_settings;

//  state stuff...
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) float zoomScale;

//  audio stuff...
@property (nonatomic, retain) AVAudioPlayer *audio;

//  camera view...
@property (nonatomic, retain) CameraView *camera_view;

@end