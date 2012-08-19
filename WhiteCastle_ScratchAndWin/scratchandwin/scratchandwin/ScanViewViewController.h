//
//  ScanViewViewController.h
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVCaptureOutput.h>

#import "ZBarSDK.h"

@interface ScanViewViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIView *vImagePreview;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) IBOutlet UIImageView *vImage;
@property (nonatomic, retain) IBOutlet UIImageView *baseImage;
@property (assign) BOOL rescan;

//  PUBLIC FUNCS...

-(IBAction) download: (id) sender;

-(IBAction) home:(id)sender;

-(IBAction) my_coupons:(id)sender;


@end
