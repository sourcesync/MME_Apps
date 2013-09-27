//
//  RightViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/2/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"

@interface RightViewController : UIViewController <SubstitutableDetailViewController>


/// Things for IB
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *lbl_title;

/// SubstitutableDetailViewController
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;
@property (nonatomic, retain) NSString *navigationTitle;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *flex;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) IBOutlet UIButton *btn_launch;


-(IBAction) btn_action_launch: (id)sender;

-(void) changeView;

@end
