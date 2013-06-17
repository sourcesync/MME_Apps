//
//  Configuration.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Configuration : NSObject

//  max take photos...
@property (nonatomic, assign) int max_take_photos;

//  make gallery photos...
@property (nonatomic, assign) int max_gallery_photos;


//
//  sounds...
//
@property (nonatomic, retain) NSURL *snd_selection;
@property (nonatomic, retain) NSURL *snd_getready;
@property (nonatomic, retain) NSURL *snd_countdown;

//
//  takephoto...
//

//  backgrounds...
@property (nonatomic, retain) UIImage *bg_takephoto_auto_vert;
@property (nonatomic, retain) UIImage *bg_takephoto_auto_horiz;
@property (nonatomic, retain) UIImage *bg_takephoto_manual_vert;
@property (nonatomic, retain) UIImage *bg_takephoto_manual_horiz;

//  buttons...
@property (nonatomic, assign) CGPoint pt_btn_flash_vert;
@property (nonatomic, assign) CGPoint pt_btn_takepic1_vert;
@property (nonatomic, assign) CGPoint pt_btn_takepic2_vert;
@property (nonatomic, assign) CGPoint pt_btn_swapcam_vert;
@property (nonatomic, assign) CGPoint pt_btn_zoomin_vert;
@property (nonatomic, assign) CGPoint pt_btn_zoomout_vert;

@property (nonatomic, assign) CGPoint pt_btn_flash_horiz;
@property (nonatomic, assign) CGPoint pt_btn_takepic1_horiz;
@property (nonatomic, assign) CGPoint pt_btn_takepic2_horiz;
@property (nonatomic, assign) CGPoint pt_btn_swapcam_horiz;
@property (nonatomic, assign) CGPoint pt_btn_zoomin_horiz;
@property (nonatomic, assign) CGPoint pt_btn_zoomout_horiz;

//  camera view...
@property (nonatomic, assign) CGRect rect_preview_vert;
@property (nonatomic, assign) CGRect rect_preview_horiz;

@property (nonatomic, assign) CGRect rect_preview_size_vert;
@property (nonatomic, assign) CGRect rect_preview_size_horiz;

@property (nonatomic, assign) CGPoint pt_preview_vert;
@property (nonatomic, assign) CGPoint pt_preview_horiz;

@property (nonatomic, assign) CGRect  rect_layer_preview_size_horiz;
@property (nonatomic, assign) CGPoint pt_layer_preview_vert;
@property (nonatomic, assign) CGPoint pt_layer_preview_horiz;

//  functions...
-(NSURL *)default_sound:(NSString *)name;

@end
