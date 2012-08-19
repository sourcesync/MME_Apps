//
//  HomeView.h
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeView : UIViewController <UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
//CIContext *context;
NSMutableArray *filters;
CIImage *beginImage;
UIScrollView *filtersScrollView;
UIView *selectedFilterView;
UIImage *finalImage;
}

-(IBAction)go_deals:(id)sender;
-(IBAction)go_rewards:(id)sender;
-(IBAction)go_signup:(id)sender;
-(IBAction)go_truckfinder:(id)sender;
-(IBAction)go_settings:(id)sender;


-(IBAction) takePicture:(id) sender;

@end
