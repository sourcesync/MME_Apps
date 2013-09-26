//
//  ContentManager.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/5/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AVFoundation/AVFoundation.h>

#import "ContentManagerDelegate.h"

enum ConfigStatus {
    ConfigStatusUnknown = 0,
    InvalidLocalConfig,
    LocalConfigComplete,
    SyncingConfig
    };

enum SettingsStatus {
    SettingsStatusUnknown = 0,
    InvalidLocalSettings,
    LocalSettingsComplete,
    SyncingSettings
};

@interface ContentManager : NSObject

@property (assign) enum ConfigStatus cstatus;
@property (assign) enum SettingsStatus sstatus;
@property (assign) id<ContentManagerDelegate> cmdel;
@property (assign) bool config_syncing;
@property (assign) bool sync_settings_after_config;
@property (assign) bool local_file;

@property (nonatomic, retain) NSString *remote;
@property (nonatomic, retain) NSString *local;
@property (nonatomic, retain) NSString *name;
@property (nonatomic, retain) NSDictionary *config;
@property (atomic, retain) NSDictionary *content;
@property (nonatomic, retain) NSString *str_cstatus;
@property (nonatomic, retain) NSString *str_sstatus;

-(id)       init:(NSString *)name;
-(bool)     sync;
-(NSString *)get_setting_string:(NSString *)key;
-(int)      get_setting_int:(NSString *)key;
-(bool)     is_syncing;
-(bool)     is_complete;
-(bool)     config_sync:(bool)sync_settings;
-(void)     lowmemory;
-(UIImage *) get_setting_image:(NSString *)key;
-(AVAudioPlayer *) get_setting_sound:(NSString *)key;

@end
