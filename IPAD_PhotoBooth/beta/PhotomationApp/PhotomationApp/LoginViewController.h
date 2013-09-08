//
//  SecondViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LoginViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

//  Table view...
@property (strong, nonatomic) IBOutlet UITableView *tv;

//  Table view cell for name...
@property (strong, nonatomic) IBOutlet UITableViewCell *cell_name;

//  Table view cell for password...
@property (strong, nonatomic) IBOutlet UITableViewCell *cell_pass;

//  Field for name...
@property (strong, nonatomic) IBOutlet UITextField *field_name;

//  Field for password...
@property (strong, nonatomic) IBOutlet UITextField *field_pass;

//  Nav item..
@property (strong, nonatomic) IBOutlet UINavigationItem *nav;

@property (nonatomic, retain) IBOutlet UIActivityIndicatorView *activity;


@property (assign) bool logging_in;

- (IBAction) nav_back;

- (IBAction) btn_submit;

@end
