//
//  ThanksViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 6/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface ThanksViewController : UIViewController
     <AVAudioPlayerDelegate>

//  state...
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) BOOL timer_expired;
@property (nonatomic, assign) BOOL audio_done;
@property (nonatomic, assign) BOOL send_tried;

//  controls...
@property (nonatomic, retain) IBOutlet UIImageView *imgview_bg;
@property (nonatomic, retain) IBOutlet UIImageView *imageview_selected;
@property (nonatomic, retain) IBOutlet UIImage *image_email;

@end
