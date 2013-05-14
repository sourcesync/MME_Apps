//
//  TakePhotoAutoViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "TakePhotoAutoViewController.h"

#import "AppDelegate.h"

@interface TakePhotoAutoViewController ()

@end

@implementation TakePhotoAutoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma more view stuff


-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    //  Turn off status...
    [[ UIApplication sharedApplication ] setStatusBarHidden:YES ];
    
    //self.state = 0;
    //self.camera_ready = NO;
    //self.allow_rotation = YES;
    //self.allow_settings = YES;
    //self.chroma_started = NO;
    //self.chromaView.hidden = YES;
    //self.bgView.hidden = YES;
    
    AppDelegate *app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    
    //  Setup chroma video...
	app.chroma_video.captureVideoPreviewLayer.frame = self.camera_normal_view.bounds;
    [self.camera_normal_view.layer addSublayer:app.chroma_video.captureVideoPreviewLayer];
    
    //  Flip based on camera...
    if (app.chroma_video.is_front)
        self.camera_normal_view.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
    self.zoomScale = 1.0f;
    
    [ app.chroma_video set_delegate:self ];
    
    //  Delay finalization of init because it takes camera a little while to start...
    [ self performSelector:@selector(finishInit) withObject:self afterDelay:1 ];
    
}

#pragma chroma stuff...


-(void) PictureTaken:(NSData *)imageData
{
    
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
    
    // Change background to just lights on...
    self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightson_768_955.png"];
    
    // Increment count...
    self.count += 1;
    
    // Decide what to do now...
    if (self.count== MAX_PHOTOS)
    {
        // Show bg with lights off...
        self.img_bg.image = [ UIImage imageNamed:@"bg_takephoto_lightsoff_768_955.png"];
        
        // Goto select-favorite view after small delay...
        [ self performSelector:@selector(goto_selectfavorite) withObject:self afterDelay:1 ];
    }
    else
    {
        [ self performSelector:@selector(getready) withObject:self afterDelay:1 ];
    }
    
     */
    
}




#pragma rotation stuff


- (BOOL)shouldAutorotate
{
    return NO;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
    {
        return YES;
    }
    else
    {
        return NO;
    }
    //return self.allow_rotation;
}



@end
