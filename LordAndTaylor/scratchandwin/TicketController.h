//
//  TicketController.h
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TicketController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *scratch_iv;
@property (nonatomic, retain) IBOutlet UIImageView *winner_iv;
@property (nonatomic, retain) IBOutlet UIImageView *results_iv;

@property (assign) int  state; 
@property (assign) BOOL mouseSwiped;
@property (assign) BOOL firstTouch;
@property (assign) BOOL winner;
@property (assign) BOOL canceled;
@property (assign) BOOL blink_state;
@property (assign) BOOL scratch_started;

@property (nonatomic, retain) IBOutlet UIImageView *drawImage;
@property (assign) CGPoint lastPoint;
@property (nonatomic, retain) UIImage *img;

@property (assign) BOOL redeem_timer_started;

-(void) blink: (id)obj;

-(IBAction) home:(id)sender;


-(IBAction) my_coupons:(id)sender;

-(IBAction) redeem:(id)sender;

-(void) start_redeem_timer;

@end
