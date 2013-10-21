//
//  YourPhotoViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/31/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YourPhotoViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *img_bg;
@property (nonatomic, retain) IBOutlet UIImageView *img_taken;

@property (nonatomic, retain) UIImage *selected_img;

@property (nonatomic, retain) IBOutlet UIButton *btn_back;
@property (nonatomic, retain) IBOutlet UIButton *btn_ilikeit;
@property (nonatomic, retain) IBOutlet UIButton *btn_takeagain;

@property (nonatomic, retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic, retain) IBOutlet UIButton *btn_photobooth;
@property (nonatomic, retain) IBOutlet UIButton *btn_settings;

-(IBAction) btnaction_take_again:(id)sender;

-(IBAction) btnaction_goto_takephoto: (id)sender;

-(IBAction) btnaction_goto_efx: (id)sender;

-(IBAction) btnaction_gallery:(id)sender;

-(IBAction) btnaction_photobooth:(id)sender;

-(IBAction) btnaction_settings:(id)sender;

-(IBAction) btnaction_back: (id)sender;

@property (nonatomic, retain) NSString *last_current_photo_path;
@property (nonatomic, retain) NSString *last_filtered_current_photo_path;
@property (assign) BOOL last_active_is_original;

@end
