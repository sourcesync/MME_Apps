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



@interface TakePhotoViewController : UIViewController <AVAudioPlayerDelegate>

//  video session stuff...
@property (nonatomic, retain) AVCaptureSession *session;

//  video device stuff...
@property (nonatomic, retain) AVCaptureDevice *device;
@property (nonatomic, retain) AVCaptureDevice *frontCamera;
@property (nonatomic, retain) AVCaptureDevice *backCamera;

//  input stuff...
@property (nonatomic, retain) AVCaptureDeviceInput *input;

//  preview area stuff...
@property (nonatomic, retain) IBOutlet UIView *view_preview_parent;
@property (nonatomic, retain) IBOutlet UIView *vImagePreview;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) IBOutlet UIImageView *vImage;

//  audio stuff...
@property (nonatomic, retain) AVAudioPlayer *audio;

//  animation stuff...
@property (nonatomic, assign) int state;

@property (nonatomic, assign) BOOL allow_snap;
@property (nonatomic, assign) BOOL camera_ready;

//  background...
@property (nonatomic, retain) IBOutlet UIImageView *img_bg;

//  thumbnails...
@property (nonatomic, retain) IBOutlet UIImageView *thumb1;
@property (nonatomic, retain) IBOutlet UIImageView *thumb2;
@property (nonatomic, retain) IBOutlet UIImageView *thumb3;
@property (nonatomic, retain) IBOutlet UIImageView *thumb4;

//  counter for taken photos...
@property (nonatomic, assign) int count;

//@property (nonatomic, retain) IBOutlet UIImageView *vImage;
//@property (nonatomic, retain) IBOutlet UIImageView *baseImage;



-(IBAction) btn_takephoto:(id)sender;

-(IBAction) btn_switchcam: (id)sender;

-(IBAction) btn_goto_gallery: (id)sender;

-(IBAction) btn_settings: (id)sender;

- (void) playSound:(NSString *)sound usedel:(BOOL)usedel;

@end
