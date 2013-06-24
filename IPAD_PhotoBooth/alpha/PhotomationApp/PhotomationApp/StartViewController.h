//
//  StartViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 6/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

@interface StartViewController : UIViewController
    <AVAudioPlayerDelegate>

@property (nonatomic, retain) IBOutlet UIImageView *imgview_bg;

@end
