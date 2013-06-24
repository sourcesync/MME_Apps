//
//  TakePhotoAutoViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "TakePhotoAutoViewController.h"

#import "AppDelegate.h"


@implementation TakePhotoAutoViewController

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
    self.camera_view = [ [ CameraView alloc] init ];
    self.camera_view.camera_normal_view = self.camera_normal_view;
    self.camera_snapshot_view = self.camera_snapshot_view;
    self.camera_view.preview_parent = self.preview_parent;
    self.camera_view.del = self;
    [ self.camera_view viewDidLoad ];
    
    
    //  play intro sound...
    //[ self playselection ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma more view stuff

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    
    //  Position everything...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation duration:0 zoomScale:1.0];
    
    
    //  Delay finalization of init because it takes camera a little while to start...
    //  TODO: should be performed via a 'done' delegate on chromavideo...
    [ self performSelector:@selector(finishInit) withObject:self afterDelay:1 ];
    
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
    
    [ self playSound: @"selection" usedel:NO];
}

-(void) getready
{
    //
    //  Show the video preview...
    //
    self.camera_view.camera_normal_view.hidden = NO;
    self.camera_view.camera_snapshot_view.hidden = YES;
    
    self.state = 1;
    
    [ self playSound: @"getready" usedel:YES];
}

-(void) countdown
{
    self.state = 2;
    
    [ self playSound: @"countdown" usedel:YES];
}



- (void) finishInit
{
    
    //
    //  start the sequence...
    //
    self.state = 0;
    //[ self playSound:@"getready"  usedel:YES ];
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
    
    // Identify the home directory and file name
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",self.count];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    
    //  Possibly deal with scaling...
    if (self.zoomScale!=1.0)
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
        
        //  Set the thumbnail...
        thumb.hidden = NO;
        thumb.image = subImage;
    }
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
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.img_bg.image = [ app.config GetImage:@"take_ap"];
        
        self.preview_parent.frame = CGRectMake(202, 228, 366, 430);
        self.camera_normal_view.frame = CGRectMake(0, 0, 366, 430);
        self.camera_snapshot_view.frame = CGRectMake(0, 0, 366, 430);
        
        
        [ self.camera_view
            willRotateToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration
                                                  zoomScale:zoomScale];
         
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ app.config GetImage:@"take_al"];
        
        self.preview_parent.frame = CGRectMake(269, 136, 485, 396);
        self.camera_normal_view.frame = CGRectMake(0, 0, 485, 396);
        self.camera_snapshot_view.frame = CGRectMake(0, 0, 485, 396);
        
        
        [ self.camera_view
            willRotateToInterfaceOrientation:toInterfaceOrientation
                                            duration:duration
                                                  zoomScale:zoomScale];
        
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
