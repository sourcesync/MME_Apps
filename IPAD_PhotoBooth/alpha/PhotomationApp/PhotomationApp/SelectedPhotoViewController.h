//
//  FavoritePhotoViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/15/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SelectedPhotoViewController : UIViewController

@property (nonatomic, retain) IBOutlet UIImageView *selected;

@property (nonatomic, assign) int selected_id;

@property (nonatomic, assign) int take_count;

-(IBAction) delete_photo:(id)sender;

-(IBAction) btn_save:(id)sender;

-(IBAction) btn_gallery:(id)sender;


-(IBAction) btn_efx: (id)sender;

-(IBAction) btn_share: (id)sender;

-(IBAction) btn_settings:(id)sender;

@end
