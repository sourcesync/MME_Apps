//
//  DownloadController.h
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DownloadController : UIViewController

@property (assign) BOOL canceled;
@property (assign) BOOL winner;

@property (nonatomic, retain) NSString *strurl;

@property (assign) BOOL fake;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil;



-(void) show_ticket: (id)sender;

-(IBAction) home:(id)sender;


-(IBAction) my_coupons:(id)sender;

@end
