//
//  CMSViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/5/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "ContentManager.h"
#import "ContentManagerDelegate.h"
 
@interface CMSViewController : UIViewController
    < UITableViewDelegate, UITableViewDataSource, ContentManagerDelegate >

@property (nonatomic, retain) IBOutlet UITableView *tv;

@property (nonatomic, retain) NSArray *content_keys;
@property (nonatomic, retain) NSDictionary *content;
@property (nonatomic, retain) ContentManager *cm;

@property (nonatomic, retain) IBOutlet UITextField *fld_url;
@property (nonatomic, retain) IBOutlet UILabel *lbl_status;
@property (nonatomic, retain) IBOutlet UILabel *lbl_skin;
@property (nonatomic, retain) IBOutlet UIButton *btn_sync;
@property (nonatomic, retain) IBOutlet UIButton *btn_launch;

-(IBAction) btn_action_sync: (id)sender;

@end
