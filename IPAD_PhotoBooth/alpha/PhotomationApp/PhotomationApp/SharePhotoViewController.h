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

//@property (nonatomic, retain) IBOutlet UIImageView *test;

@property (nonatomic, assign) int selected_id;

@property (nonatomic, assign) int take_count;

-(IBAction) btn_settings: (id)sender;
-(IBAction) btn_gallery: (id)sender;
-(IBAction) btn_takephoto: (id)sender;

-(IBAction) btn_share: (id)sender;
-(IBAction) btn_email: (id)sender;
-(IBAction) btn_print: (id)sender;

-(IBAction) btn_tweet: (id)sender;
-(IBAction) btn_facebook: (id)sender;

@end
