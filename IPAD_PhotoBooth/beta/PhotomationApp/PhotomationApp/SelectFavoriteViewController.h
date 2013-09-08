//
//  SelectFavoriteViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFavoriteViewController : UIViewController
    <AVAudioPlayerDelegate>

//  state...
@property (nonatomic, assign) BOOL audio_done;
@property (nonatomic, retain) NSTimer *timer;

//  controls...
@property (nonatomic, retain) IBOutlet UIImageView *img_bg;
@property (nonatomic, retain) IBOutlet UIImageView *first;
@property (nonatomic, retain) IBOutlet UIImageView *second;
@property (nonatomic, retain) IBOutlet UIImageView *third;
@property (nonatomic, retain) IBOutlet UIImageView *fourth;
@property (nonatomic, retain) IBOutlet UIButton *bfirst;
@property (nonatomic, retain) IBOutlet UIButton *bsecond;
@property (nonatomic, retain) IBOutlet UIButton *bthird;
@property (nonatomic, retain) IBOutlet UIButton *bfourth;
@property (nonatomic, retain) IBOutlet UIButton *bdelete;

@property (nonatomic, retain) IBOutlet UIButton *btn_gallery;
@property (nonatomic, retain) IBOutlet UIButton *btn_photobooth;
@property (nonatomic, retain) IBOutlet UIButton *btn_settings;


//  actions...
-(IBAction) photo_selected: (id)sender;
-(IBAction) delete_all:(id)sender;
-(IBAction) btn_settings:(id)sender;

@end
