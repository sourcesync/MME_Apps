//
//  SettingsLeftViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/1/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsLeftViewController : UITableViewController <UISplitViewControllerDelegate>


@property (retain, nonatomic) UIPopoverController *popover;

//  table stuff...
@property (nonatomic, retain) IBOutlet UITableViewCell *selected;

//  chromakey stuff...
@property (nonatomic, retain) IBOutlet UILabel *label_chroma_value;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_chroma;

@property (nonatomic, retain) IBOutlet UITableViewCell *cell_sharing;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_printing;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_offline;
@property (nonatomic, retain) IBOutlet UITableViewCell *cell_photobooth;


-(void) select_chroma;

@end
