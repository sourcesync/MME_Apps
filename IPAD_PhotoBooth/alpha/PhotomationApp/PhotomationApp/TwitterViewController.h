//
//  TwitterViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/25/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TwitterViewController : UIViewController


@property (nonatomic, strong) ACAccountStore *accountStore;

@property (nonatomic, retain) IBOutlet UIButton *btn_tweet;
@property (nonatomic, retain) IBOutlet UIButton *btn_done;

@property (nonatomic, retain) IBOutlet UIImageView *imgview_template;

-(IBAction)donePressed:(id)sender;

- (IBAction)tweetClick:(UIButton *)sender;

@end
