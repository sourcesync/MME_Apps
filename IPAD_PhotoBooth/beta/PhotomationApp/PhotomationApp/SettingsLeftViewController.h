//
//  SettingsLeftViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/1/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SubstitutableDetailViewController.h"

@interface SettingsLeftViewController : UITableViewController <UISplitViewControllerDelegate>



@property (nonatomic, retain) UIBarButtonItem *navigationPaneButtonItem;
// Holds a reference to the popover that will be displayed
// when the navigation button is pressed.
@property (nonatomic, retain) UIPopoverController *navigationPopoverController;

//  table stuff...
@property (nonatomic, retain) IBOutlet UITableViewCell *selected;

//  chromakey stuff...
@property (nonatomic, retain) IBOutlet UILabel *label_chroma_value;

@property (nonatomic, retain) IBOutlet UITableViewCell *cell_config;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_chroma;

@property (nonatomic, retain) IBOutlet UITableViewCell *cell_sharing;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_printing;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_offline;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_photobooth;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_done;
 
@property (nonatomic, retain) IBOutlet UILabel *lbl_social_value;
@property (nonatomic, retain) IBOutlet UILabel *lbl_print_value;
@property (nonatomic, retain) IBOutlet UILabel *lbl_offline_value;
@property (nonatomic, retain) IBOutlet UILabel *lbl_photobooth_value;

@property (nonatomic, retain) IBOutlet UIButton *btn_photobooth_value;

@property (nonatomic, retain) IBOutlet UITableView *tv;

@property (assign) int current_page;
@property (assign) int initialized;

@property (nonatomic, assign) UIViewController<SubstitutableDetailViewController> *detailViewController;

-(void) select_chroma;

-(void) reset;
@end
