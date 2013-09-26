//
//  ContentItem.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/6/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "ContentItem.h"

@implementation ContentItem

-(void)dealloc
{
    NSLog(@"Content Item dealloc");
    
    self.type = nil;
    self.remote = nil;
    self.subpath = nil;
    self.fpath = nil;
    self.data = nil;
    
    [super dealloc];
}

-(id) init
{
    self = [ super init ];
    self.local_file = NO;
    self.syncing = NO;
    return self;
}


@end
