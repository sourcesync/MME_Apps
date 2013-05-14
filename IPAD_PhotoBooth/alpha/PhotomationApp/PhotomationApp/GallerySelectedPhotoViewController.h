//
//  GallerySelectedPhotoViewController.h
//  PhotomationApp
//
//  Created by Cuong Williams on 3/18/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GallerySelectedPhotoViewController : UIViewController

//@property (nonatomic,retain) NSString *selected_fname;

@property (nonatomic,retain) IBOutlet UIImageView *selected;

-(IBAction) btn_delete:(id)sender;

-(IBAction) btn_goto_gallery:(id)sender;

-(IBAction) btn_goto_takephoto:(id)sender;

-(IBAction) btn_settings: (id)sender;

-(IBAction) btn_efx: (id)sender;

-(IBAction) btn_share: (id)sender;

@end
