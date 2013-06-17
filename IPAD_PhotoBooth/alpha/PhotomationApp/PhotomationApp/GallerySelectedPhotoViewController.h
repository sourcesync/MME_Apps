//
//  GallerySelectedPhotoViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/18/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GallerySelectedPhotoViewController : UIViewController

@property (nonatomic,retain) IBOutlet UIImageView *img_bg;
@property (nonatomic,retain) IBOutlet UIImageView *selected;

@property (nonatomic,retain) IBOutlet UIButton *btn_print;
@property (nonatomic,retain) IBOutlet UIButton *btn_efx;
@property (nonatomic,retain) IBOutlet UIButton *btn_share;
@property (nonatomic,retain) IBOutlet UIButton *btn_delete;

@property (nonatomic,retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic,retain) IBOutlet UIButton *btn_photobooth;
@property (nonatomic,retain) IBOutlet UIButton *btn_settings;

@property (nonatomic,retain) IBOutlet UIButton *btn_left;
@property (nonatomic,retain) IBOutlet UIButton *btn_right;

@property (nonatomic,retain) UIImage *selected_img;

-(IBAction) btnaction_print:(id)sender;
-(IBAction) btnaction_delete:(id)sender;
-(IBAction) btnaction_goto_gallery:(id)sender;
-(IBAction) btnaction_goto_takephoto:(id)sender;
-(IBAction) btnaction_settings: (id)sender;

-(IBAction) btnaction_efx: (id)sender;
-(IBAction) btnaction_share: (id)sender;
-(IBAction) btnaction_goleft: (id)sender;
-(IBAction) btnaction_goright: (id)sender;


@end
