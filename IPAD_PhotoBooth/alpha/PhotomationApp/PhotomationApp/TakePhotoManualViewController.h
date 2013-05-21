//
//  TakePhotoManualViewController.h
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

@interface TakePhotoManualViewController : UIViewController
    <AVAudioPlayerDelegate,
    ChromaVideoDelegate,
    AVCaptureVideoDataOutputSampleBufferDelegate>

//  state...
@property (nonatomic, assign) int state;
@property (nonatomic, assign) bool allow_snap;
@property (nonatomic, assign) float zoomScale;
@property (nonatomic, assign) bool bCancelAutoNext;
@property (nonatomic, assign) bool AutoNextScheduled;

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

//  function buttons...
@property (nonatomic, retain) IBOutlet UIButton *btn_takepic1;
@property (nonatomic, retain) IBOutlet UIButton *btn_takepic2;
@property (nonatomic, retain) IBOutlet UIButton *btn_swapcam;
@property (nonatomic, retain) IBOutlet UIButton *btn_zoomin;
@property (nonatomic, retain) IBOutlet UIButton *btn_zoomout;
@property (nonatomic, retain) IBOutlet UIButton *btn_flash;

//  audio stuff...
@property (nonatomic, retain) AVAudioPlayer *audio;

//  camera view...
@property (nonatomic, retain) CameraView *camera_view;

//  functions...
-(IBAction) btnaction_takepic: (id)sender;
-(IBAction) btnaction_swapcam: (id)sender;
-(IBAction) btnaction_zoomin: (id)sender;
-(IBAction) btnaction_zoomout: (id)sender;
-(IBAction) btnaction_flash: (id)sender;

-(IBAction) btnaction_gallery: (id)sender;
-(IBAction) btnaction_photobooth: (id)sender;
-(IBAction) btnaction_settings: (id)sender;

@end
