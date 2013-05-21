//
//  SharePhotoViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/18/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SharePhotoViewController : UIViewController

@property (nonatomic, retain) NSString *selected_fname;

@property (nonatomic, retain) IBOutlet UIImageView *selected;

@property (nonatomic, assign) int selected_id;

@property (nonatomic, assign) int take_count;

@property (nonatomic, retain) IBOutlet UIImageView *img_bg;

@property (nonatomic, retain) IBOutlet UIButton *btn_facebook;
@property (nonatomic, retain) IBOutlet UIButton *btn_tweet;
@property (nonatomic, retain) IBOutlet UIButton *btn_email;
@property (nonatomic, retain) IBOutlet UIButton *btn_print;

@property (nonatomic, retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic, retain) IBOutlet UIButton *btn_takephoto;
@property (nonatomic, retain) IBOutlet UIButton *btn_settings;

@property (nonatomic, retain) IBOutlet UIButton *btn_left;
@property (nonatomic, retain) IBOutlet UIButton *btn_right;


-(IBAction) btnaction_tweet: (id)sender;
-(IBAction) btnaction_facebook: (id)sender;
-(IBAction) btnaction_email: (id)sender;
-(IBAction) btnaction_print: (id)sender;
-(IBAction) btnaction_settings: (id)sender;
-(IBAction) btnaction_gallery: (id)sender;
-(IBAction) btnaction_takephoto: (id)sender;

-(IBAction) btnaction_left:(id)sender;
-(IBAction) btnaction_right:(id)sender;


@end
