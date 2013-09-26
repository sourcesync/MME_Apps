//
//  ContentManager.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/5/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <Foundation/NSJSONSerialization.h>
#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "ContentManager.h"
#import "ContentItem.h"
#import "DownloadItem.h"

#define kBgQueue dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0) //1

@implementation ContentManager

-(void)dealloc
{
    NSLog(@"Content Item dealloc");
    
    self.remote = nil;
    self.name = nil;
    self.config = nil;
    self.content = nil;
    self.str_cstatus = nil;
    self.str_sstatus = nil;
    
    
    [super dealloc];
}

-(void) lowmemory
{
    if (self.config)
    {
        //  Prep settings via this config...
        NSDictionary *config_settings = [ self.config objectForKey:@"settings" ];
        for ( NSString *key in config_settings )
        {
            //NSString *val = [ config_settings objectForKey:key ];
            
            if ( [ key hasPrefix:@"img_"] )
                [ self free_setting_data:key ];
            else if ( [ key hasPrefix:@"snd_"] )
                [ self free_setting_data:key ];
            
            //else if ( [ key hasPrefix:@"int_"] ) [ self set_settings_int:key val:val];
            //else if ( [ key hasPrefix:@"str_"] ) [ self set_settings_str:key val:val];
        }
    }
}

-(NSString *)get_setting_string:(NSString *)key
{
    ContentItem *item = [ self.content objectForKey:key ];
    NSString *val = item.data;
    return val;
}

-(void)free_setting_data:(NSString *)key
{
    ContentItem *item = [ self.content objectForKey:key ];
    item.data = nil;
}

-(int) get_setting_int:(NSString *)key
{
    ContentItem *item = [ self.content objectForKey:key ];
    NSNumber *num = item.data;
    int val = [ num intValue ];
    return val;
}

-(UIImage *) get_setting_image:(NSString *)key
{
    ContentItem *item = [ self.content objectForKey:key ];
    if (item.data )  // cached...
    {
        UIImage *img = item.data;
        NSLog(@"CACHED KEY=%@ PATH=%@", key, item.fpath);
        return img;
    }
    else if ( item.local_file && item.fpath ) // dynamic loading...
    {
        NSLog(@"KEY=%@ PATH=%@", key, item.fpath);
        UIImage *img = [ UIImage imageWithContentsOfFile:item.fpath];
        item.data = img;
        [ self.content setValue:item forKey:key];
        return img;
    }
    else return nil;
}


-(AVAudioPlayer *) get_setting_sound:(NSString *)key
{
    ContentItem *item = [ self.content objectForKey:key ];
    if (item.data) // cached...
    {
        AVAudioPlayer *snd = item.data;
        return snd;
    }
    else if ( item.local_file && item.fpath ) // dynamic loading...
    {
        NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: item.fpath] autorelease];
        AVAudioPlayer *audio = [[[AVAudioPlayer alloc]
                                 initWithContentsOfURL:fileURL error:NULL] autorelease];
        [ audio prepareToPlay ];
        item.data = audio;
        return audio;
    }
    else return nil;
}

-(bool) set_settings_img:(NSString *)key val:(NSString *)val
{
    //  Form local path...
    NSString *subpath = [ NSString stringWithFormat:@"Documents/Events/%@/%@", self.name, val ];
    NSString  *fpath = [NSHomeDirectory() stringByAppendingPathComponent:subpath];
    //UIImage *img = nil;
    
    bool local_file = NO;
    BOOL isdir = NO;
    BOOL exists = [ [ NSFileManager defaultManager] fileExistsAtPath:fpath isDirectory:&isdir];
    if (exists)  local_file = YES;
        //img = [ UIImage imageWithContentsOfFile:local ];

    //  Form remote path...
    NSString *remote_path = [ NSString stringWithFormat:@"%@/ipad_%@/%@",
                             self.remote,
                             self.name, val ];
    
    //  Commit the content item...
    //gw analyze
    ContentItem *item = [ [ [ ContentItem alloc ] init ] autorelease ];
    item.data = nil; //img;
    item.type = [ UIImage class ];
    item.syncing = NO;
    item.remote = [ NSURL URLWithString:remote_path ];
    item.fpath = fpath;
    item.local_file = local_file;
    item.subpath = subpath;
    
    [ self.content setValue:item forKey:key ];
    
    return YES;
}

-(bool) set_settings_snd:(NSString *)key val:(NSString *)val
{
    //  Form local path...
    NSString *subpath = [ NSString
                         stringWithFormat:@"Documents/Events/%@/%@", self.name, val ];
    NSString  *fpath = [NSHomeDirectory() stringByAppendingPathComponent:subpath];
    //AVAudioPlayer *audio = nil;
    bool local_file = NO;
    BOOL isdir = NO;
    BOOL exists = [ [ NSFileManager defaultManager]
                   fileExistsAtPath:fpath isDirectory:&isdir];
    if (exists) local_file = YES;
    //{
    //    NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: local] autorelease];
    //    //gw analyze
    //    audio = [[[AVAudioPlayer alloc]
    //              initWithContentsOfURL:fileURL error:NULL] autorelease];
    //    [ audio prepareToPlay ];
    //
    //}
    
    //  Form remote path...
    NSString *remote_path = [ NSString stringWithFormat:@"%@/ipad_%@/%@",
                      self.remote,
                      self.name, val ];
    
    //  Commit the content item...
    
    //gw analyze
    ContentItem *item = [ [ [ ContentItem alloc ] init ] autorelease ];
    item.data = nil; //audio;
    item.type = [ AVAudioPlayer class ];
    item.syncing = NO;
    item.remote = [ NSURL URLWithString:remote_path ];
    item.subpath = subpath;
    item.fpath = fpath;
    item.local_file = local_file;
    
    [ self.content setValue:item forKey:key ];
    
    return YES;
}

-(bool) set_settings_int:(NSString *)key val:(NSString *)val
{
    int ii = [ val intValue ];
    NSNumber *num = [ NSNumber numberWithInt:ii ];
    
    //  Commit the content item...
    //gw analyze
    ContentItem *item = [ [ [ ContentItem alloc ] init ] autorelease];
    item.data = num;
    item.type = [ NSNumber class ];
    item.syncing = NO;
    item.remote = nil;
    item.subpath = nil;
    item.fpath = nil;
    [ self.content setValue:item forKey:key ];
    
    return YES;
}


-(bool) set_settings_str:(NSString *)key val:(NSString *)val
{
    
    //  Commit the content item...
    //gw analyze
    ContentItem *item = [ [ [ ContentItem alloc ] init ] autorelease ];
    item.data = val;
    item.type = [ NSNumber class ];
    item.syncing = NO;
    item.remote = nil;
    item.subpath = nil;
    item.fpath = nil;
    [ self.content setValue:item forKey:key ];
    
    return YES;
}


-(id)init:(NSString *)name
{
    
    //  basic init...
    ContentManager *obj = [ super init ];
    obj.local = @"events";
    obj.name = name; 
    
    //gw analyze
    obj.content = [[ [ NSMutableDictionary alloc ] init ]autorelease];
    obj.cstatus = ConfigStatusUnknown;
    obj.sstatus = SettingsStatusUnknown;
    obj.config_syncing = NO;
    obj.sync_settings_after_config = NO;
    obj.str_sstatus = @"Unknown";
    obj.str_cstatus = @"Unknown";
    NSString *cstr = obj.str_cstatus;
    NSLog(@"%@",cstr);
    NSString *sstr = obj.str_sstatus;
    NSLog(@"%@",sstr);
    
    //
    //  Get/determine the remote url...
    //
    obj.remote = [[NSUserDefaults standardUserDefaults] stringForKey:@"mainURL"];
    if (obj.remote==nil)
    {
        NSString *model = [[UIDevice currentDevice] model];
        if ([model isEqualToString:@"iPad Simulator"])
        {
            //device is simulator
            [[NSUserDefaults standardUserDefaults] setObject:@"http://127.0.0.1/events"
                                                      forKey:@"mainURL"];
            
            //[[NSUserDefaults standardUserDefaults]
            //    setObject:@"http://photomation.mmeink.com/event"
              //                                        forKey:@"mainURL"];
        }
        else
        {
            [[NSUserDefaults standardUserDefaults] setObject:@"http://photomation.mmeink.com/event"
                                                      forKey:@"mainURL"];
        }
        obj.remote = [[NSUserDefaults standardUserDefaults] stringForKey:@"mainURL"];
    }
    
    //  Get local config if any...
    obj.config = [ self config_get ];
    if (obj.config != nil )
    {
        //  Prep settings via this config...
        NSDictionary *config_settings = [ obj.config objectForKey:@"settings" ];
        for ( NSString *key in config_settings )
        {
            NSString *val = [ config_settings objectForKey:key ];
            
            if ( [ key hasPrefix:@"img_"] ) [ self set_settings_img:key val:val];
            else if ( [ key hasPrefix:@"snd_"] ) [ self set_settings_snd:key val:val];
            else if ( [ key hasPrefix:@"int_"] ) [ self set_settings_int:key val:val];
            else if ( [ key hasPrefix:@"str_"] ) [ self set_settings_str:key val:val];
        }
    }
    
    [ self compute_status ];
    
    return obj;
}

-(void) compute_config_status
{
    if (self.config==nil) self.cstatus = InvalidLocalConfig;
    else if (self.config_syncing ) self.cstatus = SyncingConfig;
    else self.cstatus = LocalConfigComplete;
    
    enum ConfigStatus cstatus = self.cstatus;
    switch (cstatus)
    {
        case ConfigStatusUnknown:
            self.str_cstatus = [ NSString stringWithFormat:@"Config Status Unknown"];
            break;
        case InvalidLocalConfig:
            self.str_cstatus = [ NSString stringWithFormat:@"No or Invalid Config"];
            break;
        case LocalConfigComplete:
            self.str_cstatus = [ NSString stringWithFormat:@"Local Config Complete"];
            break;
        case SyncingConfig:
            self.str_cstatus = [ NSString stringWithFormat:@"Syncing Config"];
            break;
        default:
            self.str_cstatus = [ NSString stringWithFormat:@"Error"];
            break;
    }
    
    NSString *cstr = self.str_cstatus;
    NSLog(@"%@",cstr);
    NSString *sstr = self.str_sstatus;
    NSLog(@"%@",sstr);

}

-(void) compute_settings_status
{
    if ( self.content == nil ) self.sstatus = InvalidLocalSettings;
    else if ( [ self.content count ] == 0 ) self.sstatus = InvalidLocalSettings;
    else
    {
        self.sstatus = LocalSettingsComplete; // assume complete
        for ( NSString *key in self.content )
        {
            ContentItem *val = [ self.content objectForKey:key ];
            if (val.syncing)
            {
                self.sstatus = SyncingSettings;
                break;
            }
            else if ( !val.data && !val.local_file )
            {
                self.sstatus = InvalidLocalSettings;
                break;
            }
            else
            {
                NSLog(@"No setting");
            }
                
        }
        
    }
    
    switch (self.sstatus)
    {
        case SettingsStatusUnknown:
            self.str_sstatus = [ NSString stringWithFormat:@"Settings Status Unknown"];
            break;
        case InvalidLocalSettings:
            self.str_sstatus = [ NSString stringWithFormat:@"No or Invalid Settings"];
            break;
        case LocalSettingsComplete:
            self.str_sstatus = [ NSString stringWithFormat:@"Local Settings Complete"];
            break;
        case SyncingSettings:
            self.str_sstatus = [ NSString stringWithFormat:@"Syncing Settings"];
            break;
        default:
            self.str_sstatus = [ NSString stringWithFormat:@"Error"];
            break;
    }
    
    NSString *cstr = self.str_cstatus;
    NSLog(@"%@",cstr);
    NSString *sstr = self.str_sstatus;
    NSLog(@"%@",sstr);
}

-(void) compute_status
{
    [ self compute_config_status ];
    
    [ self compute_settings_status ];
    
    if ( self.sync_settings_after_config )
    {
        
    
        if ( self.cmdel!=nil) [ self.cmdel ContentStatusChanged ];
    }
}

-(bool) is_syncing
{
    if ( self.cstatus == SyncingConfig ) return true;
    else if (self.sstatus == SyncingSettings ) return true;
    else return false;
}


-(bool) is_complete
{
    if ( ( self.cstatus ==  LocalConfigComplete ) &&
         ( self.sstatus == LocalSettingsComplete ) ) return true;
    else return false;
}

-(bool) sync
{
    self.sync_settings_after_config = YES;
    
    if (! [ self config_sync:YES ] ) return false;
    else return true;
    //return [ self settings_sync ];
}

-(void) fetchedConfig: (id)obj
{
    self.config_syncing = NO;
    
    NSData *data = obj;
    NSError *error = nil;
    
    if (data!=nil)
    {
        //  parse the json into a config...
        self.config = [NSJSONSerialization JSONObjectWithData:data
                options:NSJSONReadingAllowFragments error:&error];
    
        [ self config_save:data ];
        
        if (self.config)
        {
            //gw analyze
            self.content = nil;
            self.content = [[ [ NSMutableDictionary alloc ] init ] autorelease];
            
            //  Reset settings via this config...
            NSDictionary *config_settings = [ self.config objectForKey:@"settings" ];
            for ( NSString *key in config_settings )
            {
                NSString *val = [ config_settings objectForKey:key ];
            
                if ( [ key hasPrefix:@"img_"] )
                    [ self set_settings_img:key val:val];
                else if ( [ key hasPrefix:@"snd_"] )
                    [ self set_settings_snd:key val:val];
                else if ( [ key hasPrefix:@"int_"] )
                    [ self set_settings_int:key val:val];
                else if ( [ key hasPrefix:@"str_"] )
                    [ self set_settings_str:key val:val];
            }
            
            [ self.cmdel ConfigDownloadSucceeded ];
            
            [ self.cmdel ContentConfigChanged ];
            
            [ self compute_status ];
        }
        else // config == null
        {
            [ self.cmdel ConfigDownloadFailed ];
        }
        
        //  initiate settings sync...
        if (self.sync_settings_after_config)
            [ self settings_sync ];
    }
    else // data==null
    {
        [ self.cmdel ConfigDownloadFailed ];
    }
    
    [ self compute_status ];
    
}

-(bool) config_download: (NSURL *)url
{
    dispatch_async(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL:url];
        
        //  Invoke result in main thread...
        [self performSelectorOnMainThread:@selector(fetchedConfig:)
                               withObject:data waitUntilDone:YES];
    });
    
    self.config_syncing = YES;
    [ self compute_status ];
    
    return true;
}


-(bool) config_sync:(bool)sync_settings
{
    self.sync_settings_after_config = sync_settings;
    
    //  form remote path...
    NSString *path = [ NSString stringWithFormat:@"%@/ipad_%@/%@.json",
                      self.remote,
                      self.name, self.name ];
    NSURL *config_url = [ NSURL URLWithString:path ];
    
    return [ self config_download:config_url ];
    
    /*
    //  perform synchronous request...
    NSMutableURLRequest *request = [[[NSMutableURLRequest alloc] init] autorelease];
    [request setURL:config_url];
    [request setHTTPMethod:@"GET"];
    
    //  make the request...
    NSURLResponse* response;
    NSError* error = nil;
    NSData* result = [NSURLConnection sendSynchronousRequest:request
            returningResponse:&response error:&error];
    if ( error != nil ) return false;
    
    //  parse the json into a config...
    self.config = [NSJSONSerialization JSONObjectWithData:result options:NSJSONReadingAllowFragments error:&error];
    if (error !=nil ) return false;
    
    //  save config to file system...
    if (! [ self config_save:result ] ) return false;
    
     */
    
    return true;
    
}

-(NSDictionary *) config_get
{
    NSString *config_path = [ NSString stringWithFormat:@"Documents/Events/%@/%@.json", self.name, self.name ];
    NSString  *fpath = [NSHomeDirectory() stringByAppendingPathComponent:config_path];
    
    BOOL isdir = NO;
    BOOL exists = [ [ NSFileManager defaultManager] fileExistsAtPath:fpath isDirectory:&isdir];
    
    if (exists)
    {
        NSError *error = nil;
        NSData *data = [ NSData dataWithContentsOfFile:fpath ];
        NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data
                                                 options:kNilOptions
                                                   error:&error];
        data = nil;
        return json;
    }
    else
    {
        return false;
    }
}

-(bool) create_dirs: (NSString *)path isfile:(BOOL)isfile
{
    NSArray *parts = [ path componentsSeparatedByString:@"/"];
    if (isfile)
    {
        NSRange theRange;
        theRange.location = 0;
        theRange.length = [ parts count ] - 1;
        parts = [ parts subarrayWithRange:theRange ];
    }
    
    NSString *subpath = @"";
    for ( NSString *part in parts )
    {
        subpath = [ NSString stringWithFormat:@"%@/%@", subpath, part ];
        if ( [subpath hasPrefix:@"/"] )
        {
            NSRange theRange;
            theRange.location = 1;
            theRange.length = [ subpath length ] - 1;
            subpath = [ subpath substringWithRange:theRange ];
        }
        NSString  *local = [NSHomeDirectory() stringByAppendingPathComponent:subpath];
        BOOL isdir = NO;
        BOOL exists = [ [ NSFileManager defaultManager] fileExistsAtPath:local
                                                             isDirectory:&isdir];
        if ( !exists )
        {
            NSError *error = nil;
            if (![[NSFileManager defaultManager] createDirectoryAtPath:local
                                           withIntermediateDirectories:YES
                                                            attributes:nil
                                                                 error:&error])
            {
                return false;
            }
        }
    }
    
    return true;
}

-(bool) config_save: (NSData *)json
{
    
    //  Create the event dir as needed...
    NSString *event_dir = [ NSString stringWithFormat:@"Documents/Events/%@", self.name ];
    if (! [ self create_dirs:event_dir isfile:NO] ) return false;
    
    NSString *config_path = [ NSString stringWithFormat:@"%@/%@.json",
                            event_dir, self.name ];
    
    NSString *fpath = [NSHomeDirectory() stringByAppendingPathComponent:config_path];
    //NSLog(@"%@", config_path);
    
    BOOL success = [ json writeToFile:fpath atomically:YES];
    
    return success;
}

-(void) fetchedItem: (id)obj
{
    DownloadItem *item = (DownloadItem *)obj;
    if (item.data!=nil)
    {
        ContentItem *content = [ self.content objectForKey:item.key ];
        if (content)
        {
            content.syncing = NO;
            if ( content.fpath ) // sync to local file...
            {
                [ self create_dirs:content.subpath isfile:YES];
                
                //NSString *fpath = [NSHomeDirectory() stringByAppendingPathComponent:content.local];
                bool success = [ item.data writeToFile:content.fpath atomically:YES ];
                
                //NSLog(@"WARNING: wrote data to %@ %d %d", fpath, [item.data length],success);
                
                if (success) content.local_file = YES;
                else content.local_file = NO;
                
                    /*
                    if ( [ item.key hasPrefix:@"img_"] )
                    {
                        //TEST content.data = [ UIImage imageWithContentsOfFile:fpath ];
                        //content.data = nil;
                        //content.fpath = fpath;
                    }
                    else if ( [item.key hasPrefix:@"snd_"] )
                    {
                        NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: fpath] autorelease];
                        //gw analyze
                        AVAudioPlayer *audio = [[[AVAudioPlayer alloc]
                                                 initWithContentsOfURL:fileURL error:NULL] autorelease];
                        [ audio prepareToPlay ];
                        
                        //TEST content.data = audio;
                        content.data = nil;
                        content.fpath = fpath;
                    }
                    else
                    {
                        content.data = nil;
                        content.fpath = nil;
                    }
                     */
                //}
            }
        }
        else
        {
            NSLog(@"ERROR: ContentItem does not exist %@", item.key);
        }
    }
    else
    {
        //NSLog(@"WARNING: No data downloaded for %@", item.key);
        
        ContentItem *content = [ self.content objectForKey:item.key ];
        if (content)
        {
            content.syncing = NO;
        }
    }
    
    
    //  recompute status and invoke delegate...
    
    [ self compute_status ];
    
    [ item release ];
}


-(bool) item_download: (NSURL *)url key:(NSString *)key
{
    dispatch_async(kBgQueue, ^{
        
        NSData* data = [NSData dataWithContentsOfURL:url];
                
        //  Create the download item...
        //gw analyze
        DownloadItem *item = [ [ DownloadItem alloc ] init ]; // DO NOT AUTORELEASE !!
        item.data = data;
        item.key = key;
        
        //  Invoke result in main thread...
        [self performSelectorOnMainThread:@selector(fetchedItem:)
                               withObject:item waitUntilDone:YES];
    });
    
    return true;
}

-(bool) item_sync: (ContentItem *)item key:(NSString *)key
{
    if (item.remote) // only sync if there is a remote presence...
    {
        ContentItem *content = [ self.content objectForKey:key ];
        content.syncing = YES;
        return [ self item_download:item.remote  key:key];
    }
    return true;
}

-(bool) settings_sync
{
    //  Iterate all setting items and invoke sync...
    //NSDictionary *settings = [ self.content objectForKey:@"settings" ];
    for ( NSString *key in self.content )
    {
        ContentItem *item = [ self.content objectForKey:key ];
        
        [ self item_sync:item key:key];
    }
    
    [ self compute_status ];
    
    return true;
}


@end
