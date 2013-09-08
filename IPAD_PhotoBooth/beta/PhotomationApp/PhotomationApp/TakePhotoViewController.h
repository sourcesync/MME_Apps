//
//  TakePhotoViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/14/13.
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

@interface TakePhotoViewController : UIViewController <AVAudioPlayerDelegate,
    ChromaVideoDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>


//  preview area stuff...
@property (nonatomic, retain) IBOutlet UIView *view_preview_parent;
@property (nonatomic, retain) IBOutlet UIView *vImagePreview;
@property (nonatomic, retain) IBOutlet UIImageView *vImage;
@property (nonatomic, retain) IBOutlet UIImageView *chromaView;
@property (nonatomic, retain) IBOutlet UIImageView *bgView;

//  audio stuff...
@property (nonatomic, retain) AVAudioPlayer *audio;

//  capture output...
@property (nonatomic, retain)  AVCaptureStillImageOutput *stillImageOutput;

//  animation stuff...
@property (nonatomic, assign) int state;

//  allows...
@property (nonatomic, assign) BOOL allow_snap;
@property (nonatomic, assign) BOOL camera_ready;
@property (nonatomic, assign) BOOL allow_rotation;
@property (nonatomic, assign) BOOL allow_settings;

//  background...
@property (nonatomic, retain) IBOutlet UIImageView *img_bg;

//  flip button...
@property (nonatomic, retain) IBOutlet UIButton *btn_flip;

//  tab bar buttons...
@property (nonatomic, retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic, retain) IBOutlet UIButton *btn_takephoto;
@property (nonatomic, retain) IBOutlet UIButton *btn_settings;


//  tab bar img...
@property (nonatomic, retain) IBOutlet UIImageView *img_tabbar;

//  thumbnails...
@property (nonatomic, retain) IBOutlet UIImageView *thumb1;
@property (nonatomic, retain) IBOutlet UIImageView *thumb2;
@property (nonatomic, retain) IBOutlet UIImageView *thumb3;
@property (nonatomic, retain) IBOutlet UIImageView *thumb4;


//  chroma state...
//@property (nonatomic, assign) bool have_chroma;
@property (nonatomic, assign) bool chroma_started;
@property (nonatomic, assign) dispatch_queue_t queue;

//  counter for taken photos...
@property (nonatomic, assign) int count;

@property (nonatomic, assign) float zoomScale;

-(IBAction) btn_takephoto:(id)sender;

-(IBAction) btn_switchcam: (id)sender;

-(IBAction) btn_goto_gallery: (id)sender;

-(IBAction) btn_settings: (id)sender;

-(IBAction) btn_zoom_up: (id)sender;

-(IBAction) btn_zoom_down: (id)sender;

- (void) playSound:(NSString *)sound usedel:(BOOL)usedel;

@end
