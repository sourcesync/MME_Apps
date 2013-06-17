//
//  PrintViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PrintViewController : UIViewController
    <UIPrintInteractionControllerDelegate>


@property (nonatomic, retain) IBOutlet UIButton *btn_printSelected;
@property (nonatomic, retain) IBOutlet UIButton *btn_printTemplate;
@property (nonatomic, retain) IBOutlet UIButton *btn_done;

//@property (nonatomic, retain) IBOutlet UIImageView *imgview_selected;
//@property (nonatomic, retain) IBOutlet UIImageView *imgview_template;

@property (nonatomic, retain) IBOutlet UIImageView *imgview_selected_watermark;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_template_watermark;

@property (nonatomic, retain) UIImage *img_selected;
@property (nonatomic, retain) UIImage *img_template;


@property (nonatomic, assign) UIInterfaceOrientation start_orientation;


- (IBAction)btn_printSelected:(id)sender;
- (IBAction)btn_printTemplate:(id)sender;
- (IBAction)btn_donePressed:(id)sender;

@end
