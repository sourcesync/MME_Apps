//
//  TruckSettingsView.h
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TruckSettingsView : UIViewController

@property (nonatomic, retain) IBOutlet UILabel *dist;
@property (nonatomic, retain) IBOutlet UISlider *slider;


-(IBAction) go_home:(id)obj;

-(IBAction)go_rewards:(id)obj;

-(IBAction)go_settings:(id)sender;

@end
