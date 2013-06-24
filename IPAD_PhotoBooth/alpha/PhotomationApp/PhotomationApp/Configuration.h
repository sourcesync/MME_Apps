//
//  Configuration.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

#import "ConfigurationDelegate.h"

@interface Configuration : NSObject
    <NSURLConnectionDelegate>
{
    //  Delegate to users of this class...
    id <ConfigurationDelegate> delegate;
}

//
//  State...
//
@property (nonatomic, retain) NSDictionary *configjson;
@property (nonatomic, assign) int mode;
@property (nonatomic, retain) NSMutableDictionary *images;
@property (nonatomic, retain) NSMutableDictionary *sounds;
@property (nonatomic, retain) NSMutableData *invokeData;
@property (nonatomic, retain) NSURLConnection *connection;
@property (nonatomic, retain) NSURL *currentURL;
@property (nonatomic, assign) int downloadIDX;

//
//  Start View
//
@property (nonatomic, assign) int startview_timeout;


//
//  Take Photo
//

//  global sounds...
@property (nonatomic, retain) NSURL *snd_selection;

//  max take photos...
@property (nonatomic, assign) int max_take_photos;

//  make gallery photos...
@property (nonatomic, assign) int max_gallery_photos;

//
//  Take Photo...
//

//  images...
@property (nonatomic, retain) UIImage *takephoto_bg_portrait;
@property (nonatomic, retain) UIImage *takephoto_bg_landscape;

//
//  sounds...
//
@property (nonatomic, retain) NSURL *snd_getready;
@property (nonatomic, retain) NSURL *snd_countdown;

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


-(UIImage *) GetImage: (NSString *)key;

-(BOOL) DownloadConfiguration;

-(BOOL) PlaySound:(NSString *)name  del:(id<AVAudioPlayerDelegate>)del;

-(BOOL) SetSoundDelegate:(NSString *)name  del:(id<AVAudioPlayerDelegate>)del;

@end
