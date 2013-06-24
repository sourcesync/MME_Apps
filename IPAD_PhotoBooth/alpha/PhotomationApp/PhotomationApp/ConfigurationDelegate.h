//
//  ConfigurationDelegate.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 6/22/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConfigurationDelegate <NSObject>

- (void) GotConfiguration: (NSData *)imageData;

@end
