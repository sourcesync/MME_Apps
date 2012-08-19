//
//  ViewController.h
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (assign) BOOL mouseSwiped;

@property (nonatomic, retain) IBOutlet UIImageView *drawImage;

@property (assign) CGPoint lastPoint;

//  PUBLIC FUNCS...
-(IBAction) scan_now: (id) sender;


-(IBAction) my_coupons:(id)sender;

@end
