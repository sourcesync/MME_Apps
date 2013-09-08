//
//  EmailViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface EmailViewController : UIViewController
    < UITextFieldDelegate, AVAudioPlayerDelegate >

//  state...
@property (nonatomic, assign) int selected_id;
@property (nonatomic, retain) NSTimer *timer;
@property (nonatomic, assign) BOOL audio_done;

//  controls...
@property (nonatomic, retain) IBOutlet UIButton *btn_cancel;
@property (nonatomic, retain) IBOutlet UITextField *fld_email;
@property (nonatomic, retain) IBOutlet UIImageView *imageview_selected;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_raw1;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_raw2;
@property (nonatomic, retain) IBOutlet UIImageView *imageview_bg;
@property (nonatomic, retain) UIImage *image_email;
@property (nonatomic, retain) IBOutlet UILabel *lbl_message;

//  actions...
-(IBAction) btn_fillemail:(id)sender;
-(IBAction) btn_send:(id)sender;
-(IBAction) btn_cancel:(id)sender;

//  class funcs...
+(BOOL) postimage:(NSString *)email image:(UIImage *)image;

@end
