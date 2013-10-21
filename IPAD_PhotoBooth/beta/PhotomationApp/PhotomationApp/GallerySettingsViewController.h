//
//  GallerySettingsViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 10/21/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "SubstitutableDetailViewController.h"

@interface GallerySettingsViewController : UIViewController <SubstitutableDetailViewController>



/// Things for IB
@property (nonatomic, retain) IBOutlet UIToolbar *toolbar;
@property (nonatomic, retain) IBOutlet UILabel *lbl_title;

/// SubstitutableDetailViewController
@property (nonatomic, retain) UIBarButtonItem *navigationPaneBarButtonItem;
@property (nonatomic, retain) NSString *navigationTitle;

@property (nonatomic, retain) IBOutlet UIBarButtonItem *flex;
@property (nonatomic, retain) IBOutlet UIBarButtonItem *doneButton;

@property (nonatomic, retain) IBOutlet UIButton *btn_clear_gallery;

-(IBAction) btn_action_launch: (id)sender;
-(IBAction) btn_action_clear_gallery: (id)sender;

-(void) changeView:(int)i;

@end
