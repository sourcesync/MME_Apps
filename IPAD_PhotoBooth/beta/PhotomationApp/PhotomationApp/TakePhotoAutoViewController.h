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


//  state stuff...
@property (nonatomic, assign) int count;
@property (nonatomic, assign) int state;
@property (nonatomic, assign) float zoomScale;
@property (nonatomic, retain) CameraView *camera_view;
@property (nonatomic, assign) BOOL allow_swap;
@property (nonatomic, assign) int countdown_val;

//  controls...
@property (nonatomic, retain) IBOutlet UIImageView *img_bg;
@property (nonatomic, retain) IBOutlet UIView *preview_parent;
@property (nonatomic, retain) IBOutlet UIView *camera_normal_view;
@property (nonatomic, retain) IBOutlet UIImageView *camera_snapshot_view;
@property (nonatomic, retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic, retain) IBOutlet UIButton *btn_photobooth;
@property (nonatomic, retain) IBOutlet UIButton *btn_settings;
@property (nonatomic, retain) IBOutlet UIButton *btn_switch;
@property (nonatomic, retain) IBOutlet UIImageView *test_view;

@property (nonatomic, retain) IBOutlet UILabel *lbl_countdown_right;
@property (nonatomic, retain) IBOutlet UILabel *lbl_countdown_left;

//  actions...
-(IBAction) btnaction_swapcam: (id)sender;

@end
