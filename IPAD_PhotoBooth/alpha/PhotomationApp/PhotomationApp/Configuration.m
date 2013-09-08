//
//  Configuration.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <AVFoundation/AVAudioPlayer.h>
#import <AVFoundation/AVFoundation.h>

#import "Configuration.h"

@implementation Configuration


-(UIImage *) guiimage: (NSString *)path
{
    UIImage *img = [ UIImage imageNamed:path ];
    if (img==nil) NSLog(@"invalid img pag->%@",path);
    assert(img!=nil);
    return img;
}

-(AVAudioPlayer *) guiaudio: (NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: path] autorelease];
    AVAudioPlayer *audio = [[AVAudioPlayer alloc] 
                            initWithContentsOfURL:fileURL error:NULL];
    [ audio prepareToPlay ];
    assert(audio!=nil);
    return audio;
}

-(id) init
{
    //
    //  Private member initialization...
    //
    
    //  images...
    self.images = [ [ NSMutableDictionary alloc ]
            initWithObjectsAndKeys:
                   //   start
                [ self guiimage:@"00-Photomation-iPad-Start-Screen-Vertical.jpg"],
                   @"start_p",
                [ self guiimage:@"00-Photomation-iPad-Start-Screen-Horizontal.jpg"],
                   @"start_l",
                   //   email
                [ self guiimage:@"03-Photomation-iPad-Enter-Email-Screen-Vertical.jpg"],
                   @"email_p",
                [ self guiimage:@"03-Photomation-iPad-Entyer-Email-Horizontal.jpg"],
                   @"email_l",
                   //   take photo
                [ self guiimage:@"04-Photomation-iPad-TakePhoto-Manual-Screen-Vertical.jpg"],
                   @"take_mp",
                [ self guiimage:@"04-Photomation-iPad-TakePhoto-Manual-Screen-Horizontal.jpg"],
                   @"take_ml",
                [ self guiimage:@"04-Photomation-iPad-TakePhoto-Auto-Screen-Vertical2.jpg"],
                   @"take_ap",
                [ self guiimage:@"04-Photomation-iPad-TakePhoto-Auto-Screen-Horizontal.jpg"],
                   @"take_al",
                   //   your/favorite photo
                [ self guiimage:@"5b-Photomation-iPad-Your-Photo-Screen-Manual-4Up-Vertical.jpg"],
                   @"your_mp",
                [ self guiimage:@"05-Photomation-iPad-Select-Photo-Screen-Manual-4up-Horizontal.jpg"],
                   @"your_ml",
                [ self guiimage:@"5-Photomation-iPad-Your-Photo-Screen-Vertical.jpg"],
                   @"your_ap",
                [ self guiimage:@"5-Photomation-iPad-your-Photo-Screen-Horizontal.jpg"],
                   @"your_al",
                   //   efx
                [ self guiimage:@"6-Photomation-iPad-EFX-Photo-Screen-Vertical.jpg"],
                   @"efx_p",
                [ self guiimage:@"6-Photomation-iPad-EFX-Photo-Screen-Horizontal.jpg"],
                   @"efx_l",
                   //   share
                [ self guiimage:@"7-Photomation-iPad-SHARE-Photo-Screen-Vertical.jpg"],
                   @"share_p",
                [ self guiimage:@"7-Photomation-iPad-SHARE-Photo-Screen-Horizontal.jpg"],
                   @"share_l",
                   //   twitter
                [ self guiimage:@"7a-Photomation-iPad-Enter-Twitter-Login-Screen-Vertical.jpg"],
                   @"twitter_p",
                [ self guiimage:@"07a-Photomation-iPad-Enter-Twitter-Login-Horizontal.jpg"],
                   @"twitter_l",
                   //   fackebook
                [ self guiimage:@"7b-Photomation-iPad-Enter-FB-Login-Screen-Vertical.jpg"],
                   @"facebook_p",
                [ self guiimage:@"07b-Photomation-iPad-Enter-FB-Login-Horizontal.jpg"],
                   @"facebook_l",
                   //   flickr
                [ self guiimage:@"7c-Photomation-iPad-Enter-Flickr-Login-Screen-Vertical.jpg"],
                   @"flickr_p",
                [ self guiimage:@"07c-Photomation-iPad-Enter-Flickr-Login-Horizontal.jpg"],
                   @"flickr_l",
                   //   gallery
                [ self guiimage:@"8-Photomation-iPad-Gallery-Main-Screen-Vertical.jpg"],
                   @"gallery_p",
                [ self guiimage:@"8-Photomation-iPad-Gallery-Main-Screen-Horizontal.jpg"],
                   @"gallery_l",
                   //   gallery select image
                [ self guiimage:@"8-Photomation-iPad-Gallery-Single-Pic-Screen-Vertical.jpg"],
                   @"gal_sel_p",
                [ self guiimage:@"8-Photomation-iPad-Gallery-Single-Pic-Screen-Horizontal.jpg"],
                   @"gal_sel_l",
                   //   thanks
                [ self guiimage:@"9-Photomation-iPad-Thank-You-Vertical.jpg"],
                   @"thx_p",
                [ self guiimage:@"9-Photomation-iPad-Thank-You-Screen-Horizontal.jpg"],
                   @"thx_l",
                   //   email
                [ self guiimage:@"email_vert_1200x1800.jpg"],
                   @"em_p",
                [ self guiimage:@"email_horiz_1800x1200.png"],
                   @"em_l",
                   //   watermark
                [ self guiimage:@"watermark400x600.png"],
                   @"wm_p",
                [ self guiimage:@"watermark600x400.png"],
                   @"wm_l",
              nil ];
    
    //  sounds..
    self.sounds = [ [ NSMutableDictionary alloc ]
              initWithObjectsAndKeys:
                   [ self guiaudio:@"selection"], @"snd_selection",
                   [ self guiaudio:@"picked"], @"snd_picked",
                   [ self guiaudio:@"selection"], @"snd_welcome",
                   [ self guiaudio:@"enteremail"], @"snd_email",
                   [ self guiaudio:@"getready"], @"snd_getready",
                   [ self guiaudio:@"countdown"], @"snd_countdown",
                   [ self guiaudio:@"pickfavorite"], @"snd_pickfavorite",
                   [ self guiaudio:@"selection"], @"snd_share",
                   [ self guiaudio:@"selection"], @"snd_efx",
                   [ self guiaudio:@"thanks"], @"snd_thanks",

                   nil ];
    
    //
    //  Setup defaults for everything...
    //
    
    //  mode...
    self.mode = 1; // app/manual mode = 0, scripted/experience = 1
    
    //
    //  Start...
    //
    
    //
    //  Email...
    //
    self.email_timeout = 10;
    
    //
    //  TakePhoto...
    //
    
    //  max photo...
    self.max_take_photos = 4;
    
    //  max gallery photos...
    self.max_gallery_photos = 16;
    
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

    
    self.rect_preview_vert = CGRectMake(248, 275, 272, 333);
    self.rect_preview_horiz = CGRectMake(269, 136, 485, 396);
    self.rect_preview_size_vert = CGRectMake(0, 0, 272, 333);
    self.rect_preview_size_horiz = CGRectMake(0, 0, 485, 396);
    self.pt_preview_vert = CGPointMake(248, 275);
    self.pt_preview_horiz = CGPointMake(269, 136);
    self.rect_layer_preview_size_horiz = CGRectMake(0, 0, 396, 485);
    self.pt_layer_preview_vert = CGPointMake(202-64, 228-62);
    self.pt_layer_preview_horiz = CGPointMake(269-71, 136+107);
    
    /*
    self.rect_preview_vert = CGRectMake(188, 243, 390, 477);
    self.rect_preview_horiz = CGRectMake(269, 136, 485, 396);
    self.rect_preview_size_vert = CGRectMake(0, 0, 390, 477);
    self.rect_preview_size_horiz = CGRectMake(0, 0, 485, 396);
    self.pt_preview_vert = CGPointMake(188, 243);
    self.pt_preview_horiz = CGPointMake(269, 136);
    self.rect_layer_preview_size_horiz = CGRectMake(0, 0, 396, 485);
    self.pt_layer_preview_vert = CGPointMake(188 + 7, 243 - 4);
    self.pt_layer_preview_horiz = CGPointMake(269-71, 136+107);
    */
    
    //
    //  Thanks view...
    //
    self.thanksview_timeout = 10;
    
    //
    //  Select Fav view...
    //
    self.selectfavview_timeout = 10;
    
    //
    //  EFX view...
    //
    self.efxview_timeout = 10;
    
    //
    //  Share view...
    //
    self.shareview_timeout = 10;
    
    //
    //  Facebook stuff...
    //
    self.facebook_post_message = @"Photomation Rocks!";
    
    //
    //  Twitter stuff...
    //
    self.twitter_post_message = @"Photomation Rocks!";
    
    //
    //  Hash tag stuff...
    //
    self.hash_tag = @"PhotomationPhotobooth";
    
    return self;
}

-(UIImage *) GetImage: (NSString *)key
{
    UIImage *img = [ self.images objectForKey:key ];
    assert(img!=nil);
    return img;
}


-(BOOL) PlaySound:(NSString *)name  del:(id<AVAudioPlayerDelegate>)del
{
    AVAudioPlayer *audio =
        (AVAudioPlayer *)[ self.sounds objectForKey:name ];
    assert(audio!=nil);
    
    audio.delegate = del;
    [ audio setCurrentTime:0.0];
    [ audio play];
    
    return YES;
}


-(BOOL) StopSound:(NSString *)name 
{
    AVAudioPlayer *audio =
    (AVAudioPlayer *)[ self.sounds objectForKey:name ];
    if ( !audio ) { assert("nil audio"); return NO; }
    
    [ audio pause ];
    
    return YES;
}


-(BOOL) SetSoundDelegate:(NSString *)name  del:(id<AVAudioPlayerDelegate>)del
{
    AVAudioPlayer *audio =
    (AVAudioPlayer *)[ self.sounds objectForKey:name ];
    if ( !audio ) { assert("nil audio"); return NO; }
    
    audio.delegate = del;
    
    return YES;
}

-(void) ParseCoreConfig
{
    //  facebook message...
    NSString *sval = (NSString *)[ self.configjson objectForKey:@"fb_post" ];
    if (sval) self.facebook_post_message = sval;
    
    //  twitter message...
    sval = (NSString *)[ self.configjson objectForKey:@"tw_post" ];
    if (sval) self.twitter_post_message = sval;
    
    //  hash tag...
    sval = (NSString *)[ self.configjson objectForKey:@"hash_tag" ];
    if (sval) self.hash_tag = sval;
    
    //  take photo times...
    NSNumber *ival = (NSNumber *)[ self.configjson objectForKey:@"tp_times" ];
    if (ival)
    {
        int iv = [ ival intValue ];
        if ( (iv>0)&&(iv<=4)) self.max_take_photos = iv;
    }
}

-(void) DownloadFail
{
    if ( self.downloadMode==0) // its the config
    {
        NSLog(@"DownloadFail: Config");
    }
    else if ( self.downloadMode==1) // its an image
    {
        NSLog(@"DownloadFail: Image");
        
        //  Download next if there is one...
        self.downloadIDX++;
        int count = [ [ self.images allKeys ] count ];
    
        if ( self.downloadIDX < count )
        {
            NSString *key = (NSString *)[ [ self.images allKeys ] objectAtIndex:
                               self.downloadIDX ];
            
            [ self DownloadItem:key];
        }
    }
    else if ( self.downloadMode==2) // its a sound
    {
        NSLog(@"DownloadFail: Sound");
        
        //  Download next if there is one...
        self.downloadIDX++;
        int count = [ self.sounds count ];
        if ( self.downloadIDX < count )
        {
            NSString *key = (NSString *)[ [ self.sounds allKeys ] objectAtIndex:
                               self.downloadIDX ];
            [ self DownloadItem:key];
        }
        else // initiate sounds download...
        {
            //  initiate download of all the images in the config...
            [ self performSelector:@selector(DownloadConfigImages:) withObject:nil afterDelay:0.01];
        }
    }
    
}

-(void) ReceiveData: (NSData *)data
{
    if ( self.downloadMode==0) // its the config
    {
        NSError* jsonError = nil;
        self.configjson =
            [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        NSLog(@"CONFIG : \n%@\n--------\n", [self.configjson description]);
        
        //  Got something, try to parse it and initiate downloads....
        if (self.configjson!=nil)
        {
            //  get basic config...
            [ self ParseCoreConfig ];
            
            //  initiate download of all the images in the config...
            [ self performSelector:@selector(DownloadConfigSounds:) withObject:nil afterDelay:0.01];
        }
    }
    if ( self.downloadMode==1) // its an image
    {
        //  Set this item...
        UIImage *img = [ UIImage imageWithData:data ];
        
        NSString *key = (NSString *)[ [ self.images allKeys ]
                                     objectAtIndex: self.downloadIDX ];
        if ( img==nil)
        {
            NSLog(@"Cannot get image for %@", key);
            
            //NSData* dt = [[NSData alloc] initWithContentsOfURL:self.currentURL];
            
            NSError *error = nil;
            NSString* text = [NSString stringWithContentsOfURL:self.currentURL encoding:NSASCIIStringEncoding error:&error];
            if( text )
            {
                NSLog(@"Text=%@", text);
            }
            else 
            {
                NSLog(@"Error = %@", error);
            }
        }
        else
        {
            [ self.images setObject:img forKey:key ];
        
            //  Download next if there is one...
            self.downloadIDX++;
            int count = [ self.images count ];
            if ( self.downloadIDX < count )
            {
                key = (NSString *)[ [ self.images allKeys ] objectAtIndex:
                                     self.downloadIDX ];
                
                [ self DownloadItem:key];
            }
            else // initiate sounds download...
            {
                //  initiate download of all the images in the config...
                //[ self performSelector:@selector(DownloadConfigSounds::) withObject:nil afterDelay:0.01];
            }
        }
    }
    else if ( self.downloadMode==2) // its a sound
    {
        //  Set this item...
        NSError *err = nil;
        AVAudioPlayer *audio = [[AVAudioPlayer alloc] initWithData:data error:&err];
        NSString *key = (NSString *)[ [ self.sounds allKeys ]
                                     objectAtIndex: self.downloadIDX ];
        if ( (audio==nil)  || ( err!=nil) )
        {
            NSLog(@"Cannot get audio for %@", key);
            //NSData* dt = [[NSData alloc] initWithContentsOfURL:self.currentURL];
            
            NSError *error = nil;
            NSString* text = [NSString stringWithContentsOfURL:self.currentURL encoding:NSASCIIStringEncoding error:&error];
            if( text )
            {
                NSLog(@"Text=%@", text);
            }
            else
            {
                NSLog(@"Error = %@", error);
            }
        }
        else
        {
            [ self.sounds setObject:audio forKey:key ];
            
            //  Download next if there is one...
            self.downloadIDX++;
            int count = [ self.sounds count ];
            if ( self.downloadIDX < count )
            {
                key = (NSString *)[ [ self.sounds allKeys ] objectAtIndex:
                                   self.downloadIDX ];
                [ self DownloadItem:key];
            }
            else // initiate sounds download...
            {
                //  initiate download of all the images in the config...
                [ self performSelector:@selector(DownloadConfigImages:) withObject:nil afterDelay:0.01];
            }
        }
    }
}

-(BOOL) DownloadItem: (NSString *)key
{
    if ([ self.configjson objectForKey:key ]==nil)
    {
        NSLog(@"NO URL FOR KEY->%@", key);
        
        [ self performSelector:@selector(DownloadFail) withObject:nil afterDelay:0.01];
        return YES;
    }
    
    //  Form the path...
    NSString *path = (NSString *)[ self.configjson objectForKey:key ];
    if ( ! [ path hasPrefix:@"http" ] )
    {
        NSString *prefix = (NSString *)[ self.configjson objectForKey:@"prefix"];
        path = [ NSString stringWithFormat:@"%@%@", prefix, path ];
    }
    
    //  Form the request...
    NSLog(@"key=%@ path=%@", key, path);
    NSURL *url = [ NSURL URLWithString:path ];
    self.currentURL = url;
    NSURLRequest *req = [ NSURLRequest requestWithURL:url ];
    
    //  Check cache first...
    NSURLCache *cache = [ NSURLCache sharedURLCache ];
    
    //[ cache removeAllCachedResponses ];
    
    NSCachedURLResponse *resp = [ cache  cachedResponseForRequest:req ];
    NSData *rd = [ resp data ];
    if (!rd)
    {
        NSLog(@"!!!CACHE MISS->%@", path);
        //  Not in cache, make the request...
        self.connection =
            [[NSURLConnection alloc] initWithRequest:req delegate:self];
        if (!self.connection)
            return NO;
        else
            return YES;
    }
    else
    {
        NSLog(@"!!!CACHE HIT->%@", path);
        self.invokeData = [ NSMutableData alloc ];
        [ self.invokeData appendData:rd ];
        [ self performSelector:@selector(ReceiveData:) withObject:self.invokeData afterDelay:0.01];
        return YES;
    }
    
}

-(void) DownloadConfigImages:(id)obj
{
    self.downloadIDX = 0;
    self.downloadMode = 1;
    NSString *key = (NSString *)[ [ self.images allKeys ] objectAtIndex:
                          self.downloadIDX ];
    
    [ self DownloadItem:key];
    
}


-(void) DownloadConfigSounds:(id)obj
{
    self.downloadIDX = 0;
    self.downloadMode = 2;
    NSString *key = (NSString *)[ [ self.sounds allKeys ] objectAtIndex:
                                 self.downloadIDX ];
    
    [ self DownloadItem:key];
    
}


-(BOOL) DownloadConfiguration
{
    
    //NSURL *url = [ NSURL URLWithString:@"http://codetodesign.com/c2dweb_temp.png" ];
    
    self.downloadIDX = -1;
    self.downloadMode = 0;
    
    //  Form the request...
    NSURL *url = [ NSURL URLWithString:@"http://codetodesign.com/pm/config.json" ];
    NSURLRequest *req = [ NSURLRequest requestWithURL:url ];
    
    //  Try the cache first...
    NSURLCache *cache = [ NSURLCache sharedURLCache ];
    NSCachedURLResponse *resp = [ cache  cachedResponseForRequest:req ];
    NSData *rd = [ resp data];
    if (!rd)
    {
        self.connection=
            [[NSURLConnection alloc] initWithRequest:req delegate:self];
        if (!self.connection)
        {
            return NO;
        }
        else
        {
            return YES;
        }
    }
    else
    {
        self.invokeData = [ NSMutableData alloc ];
        [ self.invokeData appendData:rd ];
        [ self performSelector:@selector(ReceiveData:) withObject:self.invokeData afterDelay:0.01];
        return YES;
    }
}




-(NSURL *)default_sound:(NSString *)name
{
    NSString *path = [[NSBundle mainBundle] pathForResource:name ofType:@"wav"];
    
    NSURL *fileURL = [[[NSURL alloc] initFileURLWithPath: path] autorelease];
     
    return fileURL;
}

#pragma mark - NSURL delegate

-(void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [ self DownloadFail];
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    self.invokeData = [ NSMutableData alloc ];
    [ self.invokeData setLength:0 ];
    //NSLog(@"response");
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    //[ self ReceiveData:data ];
    [ self.invokeData appendData:data ];
}

- (void)connection:(NSURLConnection *)connection
{
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    //NSLog(@"loading");
    
    [ self ReceiveData:self.invokeData ];
}


@end
