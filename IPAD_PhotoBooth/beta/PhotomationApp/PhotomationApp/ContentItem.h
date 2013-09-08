//
//  ContentItem.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/6/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContentItem : NSObject


@property (assign) bool syncing;
@property (assign) Class type;
@property (nonatomic, retain) NSURL *remote;
@property (nonatomic, retain) NSString *local;
@property (nonatomic,retain) id data;

@end
