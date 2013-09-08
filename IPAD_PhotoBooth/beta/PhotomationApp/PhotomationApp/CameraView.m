//
//  CameraView.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 5/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "CameraView.h"

#import "AppDelegate.h"

@implementation CameraView

UIInterfaceOrientation current_orientation;
float zoomScale=1.0;

- (void) viewDidLoad
{
    AppDelegate *app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    
    //  Setup chroma video...
    [ app.chroma_video set_delegate:self.del];// self ];
    
    self.preview_parent.backgroundColor = [ UIColor blackColor ];
}

- (void) viewWillAppear
{
    AppDelegate *app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    //  Setup chroma video...
	app.chroma_video.captureVideoPreviewLayer.frame = self.camera_normal_view.bounds;
    [self.camera_normal_view.layer addSublayer:app.chroma_video.captureVideoPreviewLayer];
    
    self.camera_normal_view.backgroundColor = [ UIColor blackColor];
    
    
    //  Initialize zoom...
    self.zoomScale = 1.0f;
    
    //  Initialize rotation...
    self.camera_normal_view.transform = CGAffineTransformIdentity;
    self.camera_snapshot_view.transform = CGAffineTransformIdentity;
    
    //  Flip based on camera...
    if (app.chroma_video.is_front)
        self.camera_normal_view.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
}

- (void) viewWillDisappear
{
    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [ app.chroma_video.captureVideoPreviewLayer removeFromSuperlayer ];
}


-(void) rotateView: (UIView *)v : (int)degrees
{
    // Rotate 90 degrees to hide it off screen
    CGAffineTransform rotationTransform = v.transform; // CGAffineTransformIdentity;
    rotationTransform =
        CGAffineTransformRotate(rotationTransform, degrees*(M_PI/180.0f) );
    v.transform = rotationTransform;
    //self.camera_snapshot_view.transform = rotationTransform;
    //self.camera_normal_view.transform = rotationTransform;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
                                zoomScale:(float)zoomScale
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    current_orientation = toInterfaceOrientation;
    self.zoomScale = zoomScale;
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        CGRect rec = app.config.rect_preview_vert;
        self.preview_parent.frame = rec;
        
        self.camera_normal_view.transform = CGAffineTransformIdentity;
        
        //  Flip based on camera...
        if (app.chroma_video.is_front)
        {
            
            self.camera_normal_view.transform = CGAffineTransformMakeScale(-1.0f*zoomScale,
                                                                           1.0f*zoomScale);
            rec = app.config.rect_preview_size_vert;
            int new_width = app.config.rect_preview_size_vert.size.width * zoomScale;
            rec.origin.x = rec.origin.x +
                (int)(new_width/2.0f) -
                (int)(app.config.rect_preview_size_vert.size.width/2.0f);
            
            int new_height = app.config.rect_preview_size_vert.size.height * zoomScale;
            rec.origin.y = rec.origin.y -
                (int)(new_height/2.0f) +
                (int)(app.config.rect_preview_size_vert.size.height/2.0f);
            
            //self.camera_normal_view.frame = app.config.rect_preview_size_vert;
            self.camera_normal_view.frame = rec;
            
            
            
            
            
        }
        else
        {
            self.camera_normal_view.transform = CGAffineTransformMakeScale(1.0f*zoomScale,
                                                                           1.0f*zoomScale);
        
            CGRect rec = app.config.rect_preview_size_vert;
            int new_width = app.config.rect_preview_size_vert.size.width * zoomScale;
            rec.origin.x = rec.origin.x -
                (int)(new_width/2.0f) +
                (int)(app.config.rect_preview_size_vert.size.width/2.0f);
        
            int new_height = app.config.rect_preview_size_vert.size.height * zoomScale;
            rec.origin.y = rec.origin.y -
                (int)(new_height/2.0f) +
                (int)(app.config.rect_preview_size_vert.size.height/2.0f);
        
            //self.camera_normal_view.frame = app.config.rect_preview_size_vert;
            self.camera_normal_view.frame = rec;
        }
        
        app.chroma_video.captureVideoPreviewLayer.bounds = app.config.rect_preview_size_vert;
        app.chroma_video.captureVideoPreviewLayer.position = app.config.pt_layer_preview_vert;
        app.chroma_video.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        
        self.preview_parent.frame = app.config.rect_preview_horiz;
        
        self.camera_normal_view.transform = CGAffineTransformIdentity;
        
        //  Flip based on camera...
        if (app.chroma_video.is_front)
        {
            self.camera_normal_view.transform = CGAffineTransformMakeScale(-1.0f*zoomScale,1.0f*zoomScale);
            
            //  Rotate the camera view...
            if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
                [ self rotateView: self.camera_normal_view: -90 ];
            else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft )
                [ self rotateView: self.camera_normal_view: 90 ];
       
            //  Translate the camera view...
            CGRect rec;
            if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                
                rec = app.config.rect_preview_size_horiz;
                int new_width = app.config.rect_preview_size_horiz.size.width * zoomScale;
                    rec.origin.x = rec.origin.x -
                    (int)(new_width/2.0f) +
                    (int)(app.config.rect_preview_size_horiz.size.width/2.0f);
                
                int new_height = app.config.rect_preview_size_horiz.size.height * zoomScale;
                    rec.origin.y = rec.origin.y -
                    (int)(new_height/2.0f) +
                    (int)(app.config.rect_preview_size_horiz.size.height/2.0f);
                 
            }
            else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                rec = app.config.rect_preview_size_horiz;
                
                int new_width = app.config.rect_preview_size_horiz.size.width * zoomScale;
                rec.origin.x = rec.origin.x +
                    (int)(new_width/2.0f) -
                    (int)(app.config.rect_preview_size_horiz.size.width/2.0f);
                
                int new_height = app.config.rect_preview_size_horiz.size.height * zoomScale;
                rec.origin.y = rec.origin.y +
                    (int)(new_height/2.0f) -
                    (int)(app.config.rect_preview_size_horiz.size.height/2.0f);
            }
            
            //self.camera_normal_view.frame = app.config.rect_preview_size_horiz;
            
            self.camera_normal_view.frame = rec;
        }
        else
        {
            self.camera_normal_view.transform = CGAffineTransformMakeScale(1.0f*zoomScale,
                                                                           1.0f*zoomScale);
            
            //  Rotate the camera view
            if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeRight )
                [ self rotateView: self.camera_normal_view: -90 ];
            else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft )
                [ self rotateView: self.camera_normal_view: 90 ];
            
            
            //  Translate the camera view...
            CGRect rec;
            if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeLeft)
            {
                
                rec = app.config.rect_preview_size_horiz;
                int new_width = app.config.rect_preview_size_horiz.size.width * zoomScale;
                rec.origin.x = rec.origin.x +
                    (int)(new_width/2.0f) -
                    (int)(app.config.rect_preview_size_horiz.size.width/2.0f);
                
                int new_height = app.config.rect_preview_size_horiz.size.height * zoomScale;
                rec.origin.y = rec.origin.y -
                    (int)(new_height/2.0f) +
                    (int)(app.config.rect_preview_size_horiz.size.height/2.0f);
            }
            else if ( toInterfaceOrientation == UIInterfaceOrientationLandscapeRight)
            {
                rec = app.config.rect_preview_size_horiz;
                
                int new_width = app.config.rect_preview_size_horiz.size.width * zoomScale;
                rec.origin.x = rec.origin.x -
                    (int)(new_width/2.0f) +
                    (int)(app.config.rect_preview_size_horiz.size.width/2.0f);
                
                int new_height = app.config.rect_preview_size_horiz.size.height * zoomScale;
                rec.origin.y = rec.origin.y +
                    (int)(new_height/2.0f) -
                    (int)(app.config.rect_preview_size_horiz.size.height/2.0f);
            }
            
            //self.camera_normal_view.frame = app.config.rect_preview_size_horiz;
            
            self.camera_normal_view.frame = rec;
        }
        
        
        
        
        app.chroma_video.captureVideoPreviewLayer.bounds = app.config.rect_layer_preview_size_horiz;
        app.chroma_video.captureVideoPreviewLayer.position = app.config.pt_layer_preview_horiz;
        app.chroma_video.captureVideoPreviewLayer.videoGravity = AVLayerVideoGravityResize;
        
        
    }
    
}

-(void)switch_cam
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app.chroma_video switch_cam:self.camera_normal_view ];
    
    [ self willRotateToInterfaceOrientation:current_orientation duration:0 zoomScale:self.zoomScale];
}

@end
