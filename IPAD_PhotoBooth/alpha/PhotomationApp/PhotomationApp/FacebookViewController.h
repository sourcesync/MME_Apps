//
//  FacebookViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/25/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

@interface FacebookViewController : UIViewController
    <FBLoginViewDelegate>

@property (nonatomic, retain) IBOutlet UIButton *btn_loginlogout;
@property (nonatomic, retain) IBOutlet UIButton *btn_post;
@property (nonatomic, retain) IBOutlet UIButton *btn_done;

@property (nonatomic, retain) IBOutlet UIImageView *imgview_template;

-(IBAction)donePressed:(id)sender;

- (IBAction)buttonClickHandler:(id)sender;

- (IBAction)postPhotoClick:(UIButton *)sender;

@end
