//
//  ChromaViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/1/13.
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

#import "SubstitutableDetailViewController.h"

@interface ChromaViewController : UIViewController
    <AVAudioPlayerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate,
    SubstitutableDetailViewController>


/// Things for IB
@property (nonatomic, retain) IBOutlet UINavigationBar *navigationBar;
/// SubstitutableDetailViewController
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;

//  video session stuff...

//  which camera?...
@property (nonatomic, assign) bool is_front;

//  input stuff...
//@property (nonatomic, retain) AVCaptureDeviceInput *input;
//@property (nonatomic, retain) AVCaptureVideoDataOutput *captureOutput;

//  various chromakey uielements - views, layers, buttons...
@property (nonatomic, retain) IBOutlet UIView *camPreview;
@property (nonatomic, retain) IBOutlet UIImageView *chromaPreview;
@property (nonatomic, retain) IBOutlet UIImageView *colorPreview;
@property (nonatomic, retain) IBOutlet UIImageView *bgPreview;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *captureVideoPreviewLayer;
@property (nonatomic, retain) IBOutlet UILabel *label_coverage;
@property (nonatomic, retain) IBOutlet UISlider *slider_sensitivity;
@property (nonatomic, retain) IBOutlet UILabel *label_sensitivity;
@property (nonatomic, retain) IBOutlet UISlider *slider_br_sensitivity;
@property (nonatomic, retain) IBOutlet UILabel *label_br_sensitivity;
@property (nonatomic, assign) int sensitivity;
@property (nonatomic, assign) int br_sensitivity;

//  practice stuff...
@property (nonatomic, assign) bool practicing;
@property (nonatomic, retain) IBOutlet UIButton *btn_practice;
@property (nonatomic, retain) IBOutlet UIImageView *img_practice_source;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity_practice;
@property (nonatomic, retain) IBOutlet UIImageView *img_test;
@property (nonatomic, retain) IBOutlet UILabel *lbl_please_wait;
@property (nonatomic, assign) bool rendering;
@property (nonatomic, retain) IBOutlet UILabel *lbl_practice;


//  camera ui stuff...
@property (nonatomic, retain) IBOutlet UIButton *btn_cam_lock;
@property (nonatomic, retain) IBOutlet UIButton *btn_capture;
@property (nonatomic, retain) IBOutlet UILabel *lbl_cam;

//  chroma state... 
//@property (nonatomic, assign) bool have_chroma;
@property (nonatomic, assign) bool chroma_started;

//gw analyze
@property (nonatomic, retain) dispatch_queue_t queue;

/*
@property (nonatomic, assign) int touch_x;
@property (nonatomic, assign) int touch_y;
@property (nonatomic, assign) bool new_touch;

@property (nonatomic, assign) uint8_t touch_bl;
@property (nonatomic, assign) uint8_t touch_bh;
@property (nonatomic, assign) uint8_t touch_gl;
@property (nonatomic, assign) uint8_t touch_gh;
@property (nonatomic, assign) uint8_t touch_rl;
@property (nonatomic, assign) uint8_t touch_rh;
*/

//@property (nonatomic, assign) uint8_t touch_hue;
//@property (nonatomic, assign) uint8_t touch_hue_l;
//@property (nonatomic, assign) uint8_t touch_hue_h;
//@property (nonatomic, assign) uint8_t touch_saturation;
//@property (nonatomic, assign) uint8_t touch_brightness;

//@property (nonatomic, assign) int total_pix;
//@property (nonatomic, assign) int chroma_pix;

-(IBAction) btn_capture: (id)sender;

-(IBAction)lock_camera:(id)sender;

-(IBAction) btn_action_practice: (id)sender;

@end
