//
//  Configuration.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "Configuration.h"

@implementation Configuration


-(id) init
{
    //
    //  Setup defaults for everything...
    //
    
    //  max photo...
    self.max_take_photos = 1;
    
    //  max gallery photos...
    self.max_gallery_photos = 16;
    
    //  sounds...
    self.snd_getready =  [ self default_sound: @"getready" ];
    self.snd_countdown = [ self default_sound: @"countdown" ];
    self.snd_selection = [ self default_sound: @"selection" ];
    
    //
    //  takephoto...
    //
    
    //  backgrounds...
    self.bg_takephoto_auto_vert =
        [ UIImage
            imageNamed:@"04-Photomation-iPad-TakePhoto-Auto-Screen-Vertical.jpg" ];
    self.bg_takephoto_auto_horiz =
        [ UIImage
            imageNamed:@"04-Photomation-iPad-TakePhoto-Auto-Screen-Horizontal.jpg" ];
    self.bg_takephoto_manual_horiz =
        [ UIImage
            imageNamed:@"04-Photomation-iPad-TakePhoto-Manual-Screen-Horizontal.jpg" ];
    self.bg_takephoto_manual_vert =
        [ UIImage
            imageNamed:@"04-Photomation-iPad-TakePhoto-Manual-Screen-Vertical.jpg" ];
    
    //  buttons...
    self.pt_btn_flash_vert = CGPointMake(348, 96);
    self.pt_btn_takepic1_vert= CGPointMake( 27, 946);
    self.pt_btn_takepic2_vert= CGPointMake( 594, 946);
    self.pt_btn_swapcam_vert= CGPointMake(348, 827);
    self.pt_btn_zoomin_vert= CGPointMake(462, 861);
    self.pt_btn_zoomout_vert= CGPointMake(204, 861);
    
    self.pt_btn_flash_horiz= CGPointMake(43, 294);
    self.pt_btn_takepic1_horiz= CGPointMake(56, 690);
    self.pt_btn_takepic2_horiz= CGPointMake(821, 690);
    self.pt_btn_swapcam_horiz= CGPointMake(476, 632);
    self.pt_btn_zoomin_horiz= CGPointMake(890,234);
    self.pt_btn_zoomout_horiz= CGPointMake(885, 402);
    
    //
    //  camera view...
    //
    
    //  preview sizes...
    self.rect_preview_vert = CGRectMake(188, 243, 390, 477);
    self.rect_preview_horiz = CGRectMake(269, 136, 485, 396);
    
    self.rect_preview_size_vert = CGRectMake(0, 0, 390, 477);
    self.rect_preview_size_horiz = CGRectMake(0, 0, 485, 396);
    
    self.pt_preview_vert = CGPointMake(188, 243);
    self.pt_preview_horiz = CGPointMake(269, 136);
    
    self.rect_layer_preview_size_horiz = CGRectMake(0, 0, 396, 485);
    self.pt_layer_preview_vert = CGPointMake(188 + 7, 243 - 4);
    self.pt_layer_preview_horiz = CGPointMake(269-71, 136+107);
    
    return self;
}

-(NSURL *)default_sound:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    
    NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: path] autorelease];
     
    return fileURL;
}


@end
