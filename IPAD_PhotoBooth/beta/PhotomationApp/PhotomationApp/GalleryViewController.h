//
//  GalleryViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/17/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GalleryViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *img_bg;

@property (nonatomic, retain) IBOutlet UIImageView *one;
@property (nonatomic, retain) IBOutlet UIImageView *two;
@property (nonatomic, retain) IBOutlet UIImageView *three;
@property (nonatomic, retain) IBOutlet UIImageView *four;
@property (nonatomic, retain) IBOutlet UIImageView *five;
@property (nonatomic, retain) IBOutlet UIImageView *six;
@property (nonatomic, retain) IBOutlet UIImageView *seven;
@property (nonatomic, retain) IBOutlet UIImageView *eight;
@property (nonatomic, retain) IBOutlet UIImageView *nine;
@property (nonatomic, retain) IBOutlet UIImageView *ten;
@property (nonatomic, retain) IBOutlet UIImageView *eleven;
@property (nonatomic, retain) IBOutlet UIImageView *twelve;
@property (nonatomic, retain) IBOutlet UIImageView *thirteen;
@property (nonatomic, retain) IBOutlet UIImageView *fourteen;
@property (nonatomic, retain) IBOutlet UIImageView *fifteen;
@property (nonatomic, retain) IBOutlet UIImageView *sixteen;

@property (nonatomic, retain) IBOutlet UIButton *bone;
@property (nonatomic, retain) IBOutlet UIButton *btwo;
@property (nonatomic, retain) IBOutlet UIButton *bthree;
@property (nonatomic, retain) IBOutlet UIButton *bfour;
@property (nonatomic, retain) IBOutlet UIButton *bfive;
@property (nonatomic, retain) IBOutlet UIButton *bsix;
@property (nonatomic, retain) IBOutlet UIButton *bseven;
@property (nonatomic, retain) IBOutlet UIButton *beight;
@property (nonatomic, retain) IBOutlet UIButton *bnine;
@property (nonatomic, retain) IBOutlet UIButton *bten;
@property (nonatomic, retain) IBOutlet UIButton *beleven;
@property (nonatomic, retain) IBOutlet UIButton *btwelve;
@property (nonatomic, retain) IBOutlet UIButton *bthirteen;
@property (nonatomic, retain) IBOutlet UIButton *bfourteen;
@property (nonatomic, retain) IBOutlet UIButton *bfifteen;
@property (nonatomic, retain) IBOutlet UIButton *bsixteen;

@property (nonatomic, retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic, retain) IBOutlet UIButton *btn_takephoto;
@property (nonatomic, retain) IBOutlet UIButton *btn_settings;
@property (nonatomic, retain) IBOutlet UIButton *btn_left;
@property (nonatomic, retain) IBOutlet UIButton *btn_right;

@property (nonatomic, retain) NSArray *views;
@property (nonatomic, retain) NSArray *buttons;
@property (nonatomic, retain) NSArray *show_files;

@property (nonatomic, retain) NSArray *gallery_pairs;

@property (assign) int current_idx;
@property (assign) int current_page;
@property (assign) int page_size;

-(IBAction) btnaction_goto_takephoto:(id)sender;
-(IBAction) btn_select_photo:(id)sender;
-(IBAction) btnaction_settings: (id)sender;


-(IBAction) btnaction_goleft: (id)sender;
-(IBAction) btnaction_goright: (id)sender;


-(void) showPage:(int)first last:(int)last;
@end
