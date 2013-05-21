//
//  FavoritePhotoViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/15/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPhotoViewController : UIViewController
    <AVAudioPlayerDelegate>


@property (nonatomic, retain) IBOutlet UIImageView *img_bg;
@property (nonatomic, retain) IBOutlet UIImageView *selected;

@property (nonatomic, assign) IBOutlet UIButton *btn_save;
@property (nonatomic, assign) IBOutlet UIButton *btn_trash;
@property (nonatomic, assign) IBOutlet UIButton *btn_efx;
@property (nonatomic, assign) IBOutlet UIButton *btn_share;
@property (nonatomic, assign) IBOutlet UIButton *btn_print;

@property (nonatomic, assign) IBOutlet UIButton *btn_gallery;
@property (nonatomic, assign) IBOutlet UIButton *btn_settings;
@property (nonatomic, assign) IBOutlet UIButton *btn_photobooth;

-(IBAction) btnaction_print:(id)sender;

-(IBAction) btnaction_delete:(id)sender;

-(IBAction) btnaction_save:(id)sender;

-(IBAction) btnaction_gallery:(id)sender;

-(IBAction) btnaction_efx: (id)sender;

-(IBAction) btnaction_share: (id)sender;

-(IBAction) btnaction_settings:(id)sender;

-(IBAction) btnaction_photobooth:(id)sender;

@end
