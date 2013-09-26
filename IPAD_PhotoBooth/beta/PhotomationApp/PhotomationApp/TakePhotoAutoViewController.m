//
//  TakePhotoAutoViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "TakePhotoAutoViewController.h"

#import "AppDelegate.h"

#import "UIImage+Resize.h"

@implementation TakePhotoAutoViewController


UIInterfaceOrientation current_orientation;


- (void)didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ];
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
    }
    return self;
}

- (void)viewDidLoad
{
    //AppDelegate *app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];

    [super viewDidLoad];

    //
    //  The camera view object...
    //
    //gw analyze
    self.camera_view = [[ [ CameraView alloc] init ] autorelease];
    self.camera_view.camera_normal_view = self.camera_normal_view;
    self.camera_view.camera_snapshot_view = self.camera_snapshot_view;
    self.camera_view.preview_parent = self.preview_parent;
    self.camera_view.del = self;
    [ self.camera_view viewDidLoad ];
    
    //  state init...
    self.zoomScale = 1.0f;
}


#pragma more view stuff

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    //  setup camera view
    [ self.camera_view viewWillAppear];
    
    //  Initialize ui...
    self.preview_parent.hidden = YES;
    self.camera_normal_view.hidden = YES;
    self.camera_snapshot_view.hidden = YES;
    
    //  Position everything...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation duration:0 zoomScale:1.0];
    
    //  Disable some things in experience mode...
    AppDelegate * app = ( AppDelegate *)
        [[UIApplication sharedApplication ] delegate ];
    if ( app.config.mode == 1 )
    {
        self.btn_gallery.enabled = NO;
        self.btn_photobooth.enabled = NO;
        self.btn_settings.enabled = NO;
    }
    
    //  Delay finalization of init because it takes camera a little while to start...
    //  TODO: should be performed via a 'done' delegate on chromavideo...
    [ self performSelector:@selector(finishInit) withObject:self afterDelay:1 ];
    
}


-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
    
    //  Position everything...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation duration:0 zoomScale:1.0];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    [ self.camera_view viewWillDisappear];
    
}

#pragma main funcs...


-(void) captureNow
{
    //
    //  Take the pic...
    //
    AppDelegate * app = ( AppDelegate *)
        [[UIApplication sharedApplication ] delegate ];
    [ app.chroma_video take_pic:self.count ];
    
}


-(void) playselection
{
    self.state = 0;
    
    [ self playSound: @"snd_selection" usedel:NO];
}


-(void) showvideo: (id)obj
{
    //
    //  Show the video preview...
    //
    self.camera_view.preview_parent.hidden = NO;
    self.camera_view.camera_normal_view.hidden = NO;
    self.camera_view.camera_snapshot_view.hidden = YES;
    
    AppDelegate * app = ( AppDelegate *)
        [[UIApplication sharedApplication ] delegate ];
    app.chroma_video.captureVideoPreviewLayer.hidden = NO;
}


-(void) showsnapshot: (UIImage *)image
{
    AppDelegate * app = ( AppDelegate *)
        [[UIApplication sharedApplication ] delegate ];
    app.chroma_video.captureVideoPreviewLayer.hidden = YES;
    
    //self.camera_snapshot_view.backgroundColor = [ UIColor redColor ];
    //UIImage *img = [ UIImage imageNamed:@"testphoto640x480.png"];
    self.camera_snapshot_view.image = image;
    //self.test_view.image = image;
    
    self.camera_view.preview_parent.hidden = NO;
    self.camera_view.camera_normal_view.hidden = YES;
    self.camera_view.camera_snapshot_view.hidden = NO;
    
}

-(void) getready
{
    
    [ self performSelectorOnMainThread:@selector(showvideo:)
                            withObject:self waitUntilDone:YES];
    
    self.state = 1;
    
    [ self playSound: @"snd_getready" usedel:YES];
}

-(void) countdown
{
    self.state = 2;
    
    [ self playSound: @"snd_countdown" usedel:YES];
}



- (void) finishInit
{
    self.count = 0;
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    app.take_count = 0;
    
    
    self.camera_view.preview_parent.hidden = NO;
    self.camera_view.camera_normal_view.hidden = NO;
    self.camera_view.camera_snapshot_view.hidden = YES;
    
    //
    //  start the sequence...
    //
    self.state = 0;
    [ self getready ];
}



#pragma audio


- (void) playSound:(NSString *)name usedel:(BOOL)usedel
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if (usedel)
        [ app.config PlaySound:name del:self ];
    else
        [ app.config PlaySound:name del:nil];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    if ( self.state==0 )
    {
        //  play getready...
        [ self getready ];
    }
    else if (self.state==1) // getready done...
    {
        //  play countdown...
        [ self countdown ];
    }
    else if (self.state==2) // countdown done...
    {
        //  snap pic...
        [ self captureNow ];
    }
    
}

#pragma actions...


-(IBAction) btnaction_swapcam: (id)sender
{
    //if (!self.allow_snap) return;
    //[ self cancelAutoNext ];
    
    self.camera_snapshot_view.hidden = YES;
    self.camera_normal_view.hidden = NO;
    
    [ self.camera_view switch_cam];
}



#pragma chroma stuff...

-(void) goto_selectfavorite:(id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_selectfavorite ];
}

-(void) PictureTaken:(NSData *)imageData
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  Form uiimage from data...
    UIImage  *image= [[[UIImage alloc] initWithData:imageData] autorelease];
    
    //  Possibly deal with rotation...
    NSString *fname;
    bool is_portrait;
    NSString  *jpgPath;
    //NSString *tname;
    //NSString *tPath;
    
    if ( UIInterfaceOrientationIsLandscape(current_orientation) )
    {
        //  front camera...
        if (app.chroma_video.is_front)
        {
            if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
            {
                image =
                [ UIImage
                 imageWithCGImage:image.CGImage scale:1.0
                 orientation:UIImageOrientationUp ];
            }
            else
            {
                image =
                [ UIImage imageWithCGImage:image.CGImage scale:1.0
                               orientation:UIImageOrientationDown ];
            }
        }
        else
        {
            if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
            {
                image =
                [UIImage
                 imageWithCGImage:image.CGImage scale:1.0
                 orientation:UIImageOrientationDown ];
            }
            else
            {
                image =
                [ UIImage imageWithCGImage:image.CGImage scale:1.0
                               orientation:UIImageOrientationUp ];
            }
        }
        
        
        // Identify the home directory and file name
        fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",self.count];
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
        
        //gw analyze
        //gw tname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.txt",self.count];
        //gw tPath = [NSHomeDirectory() stringByAppendingPathComponent:tname];
        
        is_portrait = NO;
    }
    else
    {
        
        // Identify the home directory and file name
        fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",self.count];
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
        
        //gw analyze
        //tname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.txt",self.count];
        //gw tPath = [NSHomeDirectory() stringByAppendingPathComponent:tname];
        
        is_portrait = YES;
    }
    
    //  Possibly deal with scaling...
    //if (self.zoomScale!=1.0)
    
    //  The following code will save out the picture in the current and right orientation
    {
        int width = image.size.width;
        int rwidth = width * self.zoomScale;
        int height = image.size.height;
        int rheight = (int)image.size.height * self.zoomScale;
        UIImage *resized = [ image resizedImage:CGSizeMake(rwidth,rheight)
                           interpolationQuality:kCGInterpolationHigh ];
        
        int woffset = (int)( (rwidth - width)/2.0 );
        int hoffset = (int)( (rheight - height)/2.0 );
        CGRect fromRect = CGRectMake(woffset, hoffset, width, height); // or whatever rectangle
        CGImageRef drawImage = CGImageCreateWithImageInRect(resized.CGImage, fromRect);
        UIImage *subImage = [UIImage imageWithCGImage:drawImage];
        CGImageRelease(drawImage);
        
        //  TODO: Need to rotate the same as non-zoomed !
        //UIImage *ii = [ UIImage imageWithCGImage:subImage.CGImage
        //                                   scale:1.0 orientation:UIImageOrientationRight ];
        
        NSData *imageData = UIImageJPEGRepresentation(subImage, 1.0);
        
        //  Write the file...
        [imageData writeToFile:jpgPath atomically:YES];
        
        image = subImage;
    }
    
    //  Globally set the selected photo (and path)...
    app.selected_id = 0;
    app.current_photo_path = jpgPath;
    app.current_filtered_path = nil;
    app.is_portrait = is_portrait;
    [ AppDelegate DeleteCurrentFilteredPhoto];
    
    
    // Set the snapshot image...
    self.camera_snapshot_view.image = image;
    
    [ self performSelectorOnMainThread:@selector(showsnapshot:)
                            withObject:image waitUntilDone:YES];
    
    //  Show the snapshot view...
    //self.camera_snapshot_view.hidden = NO;
    
    //  Hide the camera preview...
    //self.camera_normal_view.hidden = YES;

    
    // Increment count...
    self.count += 1;
    app.take_count +=1;
    
    
    // Decide what to do now...
    if (self.count== app.config.max_take_photos)
    {
        // Show bg with lights off...
        //self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightsoff_768_955.png"];
        
        // Goto select-favorite view after small delay...
        [ self performSelector:@selector(goto_selectfavorite:) withObject:self afterDelay:1 ];
    }
    else
    {
        [ self performSelector:@selector(getready) withObject:self afterDelay:1 ];
    }

    
}




#if 0
-(void) PictureTaken:(NSData *)imageData
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  Form uiimage from data...
    UIImage  *image= [[[UIImage alloc] initWithData:imageData] autorelease];
    
    // Set the snapshot image...
    self.camera_snapshot_view.image = image;
    self.camera_snapshot_view.hidden = NO;
    
    //  Hide the other views...
    self.camera_normal_view.hidden = YES;
    
    /*
    // Set the thumbnail...
    UIImageView *thumb =(UIImageView *) [
                                         [ NSArray arrayWithObjects:
                                          self.thumb1,self.thumb2,self.thumb3,self.thumb4,nil] objectAtIndex:self.count ];
    
    
    // Hide the video preview...
    self.vImagePreview.hidden = YES;
    
     */
    
    // Identify the home directory and file name
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",self.count];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    NSLog(@"%@", jpgPath);
    
    //  Possibly deal with scaling...
    //if (self.zoomScale!=1.0)
    {
        int width = image.size.width;
        int rwidth = (int)(width * self.zoomScale);
        int height = image.size.height;
        int rheight = (int)(image.size.height * self.zoomScale);
        UIImage *resized = [ image resizedImage:CGSizeMake(rwidth,rheight)
                           interpolationQuality:kCGInterpolationHigh ];
        
        int woffset = (int)( (rwidth - width)/2.0 );
        int hoffset = (int)( (rheight - height)/2.0 );
        CGRect fromRect = CGRectMake(woffset, hoffset, width, height); // or whatever rectangle
        CGImageRef drawImage = CGImageCreateWithImageInRect(resized.CGImage, fromRect);
        UIImage *subImage = [UIImage imageWithCGImage:drawImage];
        CGImageRelease(drawImage);
        
        //  TODO: Need to rotate the same as non-zoomed !
        
        //UIImage *ii = [ UIImage imageWithCGImage:subImage.CGImage
        //                                   scale:1.0 orientation:UIImageOrientationRight ];
        
        NSData *imageData = UIImageJPEGRepresentation(subImage, 1.0);
        
        //  Write the file...
        BOOL written = [imageData  writeToFile:jpgPath atomically:YES];
        written = written;
        //  Set the thumbnail...
        //thumb.hidden = NO;
        //thumb.image = subImage;
    }
    /*
    else
    {
        //  Set the thumbnail...
        thumb.hidden = NO;
        thumb.image = image;
        
        // Write the file...
        [imageData writeToFile:jpgPath atomically:YES];
    }
     */
    
    // Change background to just lights on...
    //self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightson_768_955.png"];
    
    // Increment count...
    self.count += 1;
    app.take_count +=1;
    
    
    // Decide what to do now...
    if (self.count== app.config.max_take_photos)
    {
        // Show bg with lights off...
        //self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightsoff_768_955.png"];
        
        // Goto select-favorite view after small delay...
        [ self performSelector:@selector(goto_selectfavorite:) withObject:self afterDelay:1 ];
    }
    else
    {
        [ self performSelector:@selector(getready) withObject:self afterDelay:1 ];
    }
    
    
}
#endif




#pragma rotation stuff


- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations =
        UIInterfaceOrientationMaskAll;
    return orientations;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
    {
        return YES;
    }
    else
    {
        return YES;
    }
}


- (void)orientElements: (UIInterfaceOrientation)toInterfaceOrientation
        duration:(NSTimeInterval)duration
             zoomScale:(float)zoomScale
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    current_orientation = toInterfaceOrientation;
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.img_bg.image =
            [ app.config GetImage:@"take_ap"];
        
        self.btn_switch.frame =
            CGRectMake(349,682,73,44);
        /*
        self.preview_parent.frame = CGRectMake(202, 228, 366, 430);
        self.camera_normal_view.frame = CGRectMake(0, 0, 366, 430);
        self.camera_snapshot_view.frame = CGRectMake(0, 0, 366, 430);
        */
        
        
        [ self.camera_view
            willRotateToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration
                                                  zoomScale:zoomScale];
        
        /*
        
        self.preview_parent.frame = CGRectMake(202, 228, 366, 430);
        self.camera_normal_view.frame = CGRectMake(0, 0, 366, 430);
        self.camera_snapshot_view.frame = CGRectMake(0, 0, 366, 430);
         */
         
         
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ app.config GetImage:@"take_al"];
        
        self.btn_switch.frame =
            CGRectMake(349,682,73,44);
        /*
        self.preview_parent.frame = CGRectMake(269, 136, 485, 396);
        self.camera_normal_view.frame = CGRectMake(0, 0, 485, 396);
        self.camera_snapshot_view.frame = CGRectMake(0, 0, 485, 396);
        */
        
        
        [ self.camera_view
            willRotateToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration
                                                  zoomScale:zoomScale];
         
        
        /*
        self.preview_parent.frame = CGRectMake(269, 136, 485, 396);
        self.camera_normal_view.frame = CGRectMake(0, 0, 485, 396);
        self.camera_snapshot_view.frame = CGRectMake(0, 0, 485, 396);
        */
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
                           
{
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        [self orientElements:toInterfaceOrientation duration:duration zoomScale:self.zoomScale];
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        [self orientElements:toInterfaceOrientation duration:duration zoomScale:self.zoomScale];
    }
}



@end
