//
//  CMSViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/5/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"

#import "ContentManager.h"
#import "ContentManagerDelegate.h"
 
@interface CMSViewController : UIViewController
    < UITableViewDelegate, UITableViewDataSource, ContentManagerDelegate,
    SubstitutableDetailViewController>



@property (nonatomic, retain) IBOutlet UITableView *tv;

@property (nonatomic, retain) NSArray *content_keys;
@property (nonatomic, retain) NSDictionary *content;
@property (nonatomic, retain) ContentManager *cm;

@property (nonatomic, retain) IBOutlet UITextField *fld_url;
@property (nonatomic, retain) IBOutlet UILabel *lbl_status;
@property (nonatomic, retain) IBOutlet UILabel *lbl_skin;
@property (nonatomic, retain) IBOutlet UIButton *btn_sync;
@property (nonatomic, retain) IBOutlet UIButton *btn_launch;
@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;

@property (nonatomic, retain) IBOutlet UIImageView *img_preview;

@property (nonatomic, retain) UITapGestureRecognizer *tap;

-(IBAction) btn_action_sync: (id)sender;

-(IBAction) btn_action_launch: (id)sender;

-(IBAction) img_tapped: (id)sender;


/// Things for IB
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
/// SubstitutableDetailViewController
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;


@property (nonatomic, retain) IBOutlet UIBarButtonItem *flex;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) AVAudioPlayer *current_audio;

@end
