//
//  EmailViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EmailViewController : UIViewController


@property (nonatomic, retain) IBOutlet UIButton *btn_send;
@property (nonatomic, retain) IBOutlet UIButton *btn_cancel;
@property (nonatomic, retain) IBOutlet UIButton *btn_me;
@property (nonatomic, retain) IBOutlet UIButton *btn_done;

@property (nonatomic, retain) IBOutlet UITextField *fld_email;

@property (nonatomic, retain) IBOutlet UIImageView *imageview_selected;

@property (nonatomic, assign) int selected_id;

-(IBAction) btn_fillemail:(id)sender;

-(IBAction) btn_send:(id)sender;

-(IBAction) btn_cancel:(id)sender;

@end
