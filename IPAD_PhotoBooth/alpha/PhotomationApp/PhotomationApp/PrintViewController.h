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

@property (nonatomic, retain) IBOutlet UIImageView *imgview_selected;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_template;

@property (nonatomic, retain) IBOutlet UIImageView *imgview_selected_watermark;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_template_watermark;

@property (nonatomic, retain) UIImage *selected_image;
@property (nonatomic, retain) UIImage *templated_image;

@property (nonatomic, assign) UIInterfaceOrientation start_orientation;
           
@end
