//
//  UIImage+SubImage.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/19/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (SubImage)

- (UIImage *)pasteImage:(UIImage *)insert bounds:(CGRect)bounds;

- (UIImage *)blendImage:(UIImage *)insert;

- (UIImage *)filterImageBlackAndWhite;
- (UIImage *)filterImageBlackAndWhiteBorder;

- (UIImage *)filterImageSepia;
- (UIImage *)filterImageSepiaBorder;

- (UIImage *)filterImageSepiaBorderHoriz;

- (UIImage *)filterImageOther;


- (UIImage *)filterImageToaster;

@end
