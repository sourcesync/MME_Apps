//
//  ContentManagerDelegate.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/7/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

//#import "ContentManager.h"

@protocol ContentManagerDelegate <NSObject>

- (void) ContentStatusChanged;

- (void) ContentConfigChanged;

- (void) ConfigDownloadSucceeded;

- (void) ConfigDownloadFailed;

@end
