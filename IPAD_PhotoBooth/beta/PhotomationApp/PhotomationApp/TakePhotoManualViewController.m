//
//  TakePhotoManualViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "TakePhotoManualViewController.h"

#import "AppDelegate.h"
#import "UIImage+Resize.h"


@implementation TakePhotoManualViewController

UIInterfaceOrientation current_orientation;


- (void)didReceiveMemoryWarning
{
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
    [ super didReceiveMemoryWarning];
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
    [super viewDidLoad];


    //  Initialize state...
    self.allow_snap = NO;
    self.state = 0;
    self.zoomScale = 1.0f;
    self.bCancelAutoNext = NO;
    self.AutoNextScheduled = NO;
    
    //  Initialize ui...
    self.preview_parent.hidden = YES;
    self.camera_normal_view.hidden = YES;
    self.camera_snapshot_view.hidden = YES;
    
    
    //
    //  The camera view object...
    //
    self.camera_view = [[ [ CameraView alloc] init ] autorelease];
    self.camera_view.camera_normal_view = self.camera_normal_view;
    self.camera_snapshot_view = self.camera_snapshot_view;
    self.camera_view.preview_parent = self.preview_parent;
    self.camera_view.del = self;
    [ self.camera_view viewDidLoad];
    
    
    //  Play selection sound...
    [ self playselection ];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  setup camera view
    [ self.camera_view viewWillAppear];
   
    //  Initialize ui...
    self.preview_parent.hidden = YES;
    self.camera_normal_view.hidden = YES;
    self.camera_snapshot_view.hidden = YES;
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation duration:0 zoomScale:self.zoomScale];
    
    //  Reset start orientation...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( !app.have_start_orientation )
    {
        app.start_orientation = uiorientation;
        
        if (uiorientation==UIInterfaceOrientationPortrait)
            app.start_orientation_mask = UIInterfaceOrientationMaskPortrait;
        else if (uiorientation==UIInterfaceOrientationLandscapeLeft)
            app.start_orientation_mask = UIInterfaceOrientationMaskLandscapeLeft;
        else if ( uiorientation==UIInterfaceOrientationLandscapeRight)
            app.start_orientation_mask = UIInterfaceOrientationMaskLandscapeRight;
        else
            app.start_orientation_mask = UIInterfaceOrientationMaskPortrait;
    }
    
    //  Make sure to allow rotations again...
    app.lock_orientation = NO;
    
    //  Delay finalization of init because it takes camera a little while to start...
    //  TODO: should be performed via a 'done' delegate on chromavideo...
    [ self performSelector:@selector(finishInit) withObject:self afterDelay:1 ];
}


-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    [ self.camera_view viewWillDisappear];
    
    //[self.vImagePreview.layer addSublayer:app.captureVideoPreviewLayer];
    //[ self stopChroma ];
    //[ self.session stopRunning ];
}



#pragma button actions...


-(IBAction) btnaction_takepic: (id)sender
{
    if (!self.allow_snap) return;
    
    //  Lock the orientation to current one...
    AppDelegate *app =
        ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    //  If simulator then fake it...
    if ( app.is_simulator)
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        self.fake_data = UIImageJPEGRepresentation(test, 1.0f);
        [ self PictureTaken:self.fake_data];
    }
    else
    {
    
        app.lock_orientation = YES;
        app.taken_pic_orientation = current_orientation;
        if ( current_orientation == UIInterfaceOrientationPortrait )
            app.take_pic_supported_orientations = UIInterfaceOrientationMaskPortrait;
        else if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
            app.take_pic_supported_orientations = UIInterfaceOrientationMaskLandscapeLeft;
        else if ( current_orientation == UIInterfaceOrientationLandscapeRight )
            app.take_pic_supported_orientations = UIInterfaceOrientationMaskLandscapeRight;
        else
            app.take_pic_supported_orientations = UIInterfaceOrientationMaskAll;
    
        //  Cancel any currently scheduled activity to automatically goto next view...
        [ self cancelAutoNext ];
    
        //  Show the preview, hide the snapshot...
        self.camera_snapshot_view.hidden = YES;
        self.camera_normal_view.hidden = NO;
    
        //  Take the pic...
        [ self captureNow ];
    
        //  Play get-ready, and initiate the take pic sequence...
        // [ self getready ];
    }
}

-(IBAction) btnaction_swapcam: (id)sender
{
    if (!self.allow_snap) return;
    
    [ self cancelAutoNext ];
    
    self.camera_snapshot_view.hidden = YES;
    self.camera_normal_view.hidden = NO;
    
    [ self.camera_view switch_cam];
}

-(IBAction) btnaction_zoomin: (id)sender
{
    if (!self.allow_snap) return;
    
    [ self cancelAutoNext ];
    
    self.camera_snapshot_view.hidden = YES;
    self.camera_normal_view.hidden = NO;
    
    float testZoom = self.zoomScale*1.02;
    if ( testZoom>=1.0)
        [ self scaleBy:1.02];
    
}

-(IBAction) btnaction_zoomout: (id)sender
{
    if (!self.allow_snap) return;
    
    [ self cancelAutoNext ];
    
    self.camera_snapshot_view.hidden = YES;
    self.camera_normal_view.hidden = NO;
    
    float testZoom = self.zoomScale*0.98;
    if ( testZoom>=1.0)
        [ self scaleBy:0.98];
}

-(IBAction) btnaction_flash: (id)sender
{
    if (!self.allow_snap) return;
    
    [ self cancelAutoNext ];
    
    self.camera_snapshot_view.hidden = YES;
    self.camera_normal_view.hidden = NO;
    
    [ AppDelegate ErrorMessage:@"I don't know how to do this yet :)"] ;
}


-(IBAction) btnaction_gallery: (id)sender
{
    if (!self.allow_snap) return;
    
    [ self cancelAutoNext ];
    
    AppDelegate *app =
        ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [ app goto_gallery ];
    
}

-(IBAction) btnaction_photobooth: (id)sender
{
    if (!self.allow_snap) return;
    
    [ self cancelAutoNext ];
    
}

-(IBAction) btnaction_settings: (id)sender
{
    if (!self.allow_snap) return;
    
    [ self cancelAutoNext ];
    
    //[ AppDelegate NotImplemented:@""] ;
    
    AppDelegate *app =
        ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    if (app.config.mode==0)
        [ app goto_settings:self ];
     
}

#pragma main funcs...

-(void) cancelAutoNext
{
    if ( self.AutoNextScheduled)
    {
        self.bCancelAutoNext = YES;
        self.AutoNextScheduled = NO;
    }
}

-(void) goto_yourphoto
{
    //  Check that this operation has been canceled...
    if ( self.bCancelAutoNext )
    {
        self.bCancelAutoNext = NO;
        self.AutoNextScheduled = NO;
        return;
    }
    
    self.AutoNextScheduled = NO;
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [app goto_yourphoto ];
    
}


-(void) scaleBy: (float)factor
{
    self.zoomScale *= factor;
    
    [ self.camera_view willRotateToInterfaceOrientation:current_orientation
                                               duration:0
                                              zoomScale:self.zoomScale ];
    
}

-(void) playselection
{
    self.state = 0;
    AppDelegate * app =
        ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [ app.config PlaySound:@"snd_selection" del:nil];
}


-(void) getready
{
    //
    //  Show the video preview...
    //
    self.camera_view.camera_normal_view.hidden = NO;
    self.camera_view.camera_snapshot_view.hidden = YES;
    
    self.state = 1;
    AppDelegate * app =
        ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [ app.config PlaySound:@"snd_getready" del:self];
}

-(void) countdown
{
    self.state = 2;
    AppDelegate * app =
        ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [app.config PlaySound:@"snd_countdown" del:self];
}


-(void) captureNow
{
    //
    //  Take the pic...
    //
    AppDelegate * app = ( AppDelegate *)
        [[UIApplication sharedApplication ] delegate ];
    [ app.chroma_video take_pic:0 ];
    
}


- (void) finishInit
{
    //AppDelegate * app =
      //  ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    //
    //  start the sequence...
    //
    self.state = 0;
    
    self.camera_view.preview_parent.hidden = NO;
    self.camera_view.camera_normal_view.hidden = NO;
    self.camera_view.camera_snapshot_view.hidden = YES;
    
    //  allow pics...
    self.allow_snap = YES;
}


#pragma audio...


- (void) playSound:(NSURL *)sound usedel:(BOOL)usedel
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if (usedel)
        [ app playSound:sound delegate:self];
    else
        [ app playSound:sound delegate:nil];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
    
    if ( self.state==0 )
    {
        //  done selection sound, nothing to
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


-(void) PictureTaken:(NSData *)imageData
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  Form uiimage from data...
    UIImage  *image= [[[UIImage alloc] initWithData:imageData] autorelease];
    
    //  Possibly deal with rotation...
    NSString *fname;
    bool is_portrait;
    NSString  *jpgPath;
    //gw analyze
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
        fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",0];
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
        
        //gw analyze
        //gw tname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.txt",0];
        //gw tPath = [NSHomeDirectory() stringByAppendingPathComponent:tname];
        
        is_portrait = NO;
    }
    else
    {
        
        // Identify the home directory and file name
        fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",0];
        jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
        
        //gw analyze
        //gw tname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.txt",0];
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
    
    //  Show the snapshot view...
    self.camera_snapshot_view.hidden = NO;
    
    //  Hide the camera preview...
    self.camera_normal_view.hidden = YES;
    
    
    /*
    // Decide what to do now...
    //if (self.count== app.config.max_photos)
    {
        // Show bg with lights off...
        //self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightsoff_768_955.png"];
        
        // Goto select-favorite view after small delay...
        //[ self performSelector:@selector(goto_selectfavorite) withObject:self afterDelay:1 ];
    }
    else
    {
        [ self performSelector:@selector(getready) withObject:self afterDelay:1 ];
    }
    */
    
    [ self performSelector:@selector(goto_yourphoto) withObject:self afterDelay:2 ];
    self.AutoNextScheduled = YES;
    
    self.allow_snap = YES;
    
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
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if ( app.lock_orientation) return NO;
    else return YES;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

- (void) reposition: (UIButton*)btn : (CGPoint)pt
{
    CGRect rect = CGRectMake( pt.x, pt.y, btn.frame.size.width, btn.frame.size.height );
    btn.frame = rect;
}

- (void)orientElements: (UIInterfaceOrientation)toInterfaceOrientation
              duration:(NSTimeInterval)duration
                zoomScale:(float)zoomScale
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    current_orientation = toInterfaceOrientation;
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        UIImage *img = [ app.config GetImage:@"take_mp"];
        self.img_bg.image = img;
        
        [ self reposition:self.btn_flash : app.config.pt_btn_flash_vert ];
        [ self reposition:self.btn_swapcam : app.config.pt_btn_swapcam_vert ];
        [ self reposition:self.btn_takepic1 : app.config.pt_btn_takepic1_vert ];
        [ self reposition:self.btn_takepic2 : app.config.pt_btn_takepic2_vert ];
        [ self reposition:self.btn_zoomin : app.config.pt_btn_zoomin_vert ];
        [ self reposition:self.btn_zoomout : app.config.pt_btn_zoomout_vert ];
        
        //  Tab bar buttons...
        self.btn_gallery.frame = CGRectMake(148,920,112,85);
        self.btn_photobooth.frame = CGRectMake(328,920,113,81);
        self.btn_settings.frame = CGRectMake(516,920,102,85);
        
        [ self.camera_view willRotateToInterfaceOrientation:toInterfaceOrientation
                                                   duration:duration
                                                  zoomScale:zoomScale];
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.img_bg.image = [ app.config GetImage:@"take_ml"];
        
        
        [ self reposition:self.btn_flash : app.config.pt_btn_flash_horiz ];
        [ self reposition:self.btn_swapcam : app.config.pt_btn_swapcam_horiz ];
        [ self reposition:self.btn_takepic1 : app.config.pt_btn_takepic1_horiz ];
        [ self reposition:self.btn_takepic2 : app.config.pt_btn_takepic2_horiz ];
        [ self reposition:self.btn_zoomin : app.config.pt_btn_zoomin_horiz ];
        [ self reposition:self.btn_zoomout : app.config.pt_btn_zoomout_horiz ];
        
        
        //  Tab bar buttons...
        self.btn_gallery.frame = CGRectMake(292,690,88,86);
        self.btn_photobooth.frame = CGRectMake(467,690,88,86);
        self.btn_settings.frame = CGRectMake(637,690,88,86);
        
        [ self.camera_view willRotateToInterfaceOrientation:toInterfaceOrientation
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
