//
//  DownloadItem.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/5/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "DownloadItem.h"

@implementation DownloadItem

-(id)init
{
    self = [super init];
    return self;
}

-(void)dealloc
{
    
    self.data = nil;
    self.key = nil;
    
    [ super dealloc];
} 

@end
