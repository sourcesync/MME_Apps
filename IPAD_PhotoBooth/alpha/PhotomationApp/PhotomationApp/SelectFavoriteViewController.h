//
//  SelectFavoriteViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectFavoriteViewController : UIViewController <AVAudioPlayerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *first;
@property (nonatomic, retain) IBOutlet UIImageView *second;
@property (nonatomic, retain) IBOutlet UIImageView *third;
@property (nonatomic, retain) IBOutlet UIImageView *fourth;

@property (nonatomic, retain) IBOutlet UIButton *bfirst;
@property (nonatomic, retain) IBOutlet UIButton *bsecond;
@property (nonatomic, retain) IBOutlet UIButton *bthird;
@property (nonatomic, retain) IBOutlet UIButton *bfourth;

-(IBAction) photo_selected: (id)sender;

-(IBAction) delete_all:(id)sender;

-(IBAction) btn_settings:(id)sender;

@end
