//
//  ChromaViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/1/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//


#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVCaptureSession.h>
#import <AVFoundation/AVCaptureVideoPreviewLayer.h>
#import <AVFoundation/AVCaptureDevice.h>
#import <AVFoundation/AVCaptureInput.h>
#import <AVFoundation/AVAnimation.h>
#import <AVFoundation/AVMediaFormat.h>
#import <AVFoundation/AVMetadataFormat.h>
#import <AVFoundation/AVVideoSettings.h>

#import "AppDelegate.h"
#import "ChromaViewController.h"

#define TOLERANCE  10
#define BR_TOLERANCE  100

@interface ChromaViewController ()

@end

@implementation ChromaViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}
-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
   // [ self.navigationController setNavigationBarHidden:NO ];
   // self.navigationController.navigationBarHidden = NO;
   // self.navigationItem.title = @"Chroma Key";
    
}
/*
-(void) show_popup
{
    [ AppDelegate show_popover ];
}
 */

- (void)viewDidLoad
{
    [super viewDidLoad];
   
    //  nav bar...
    UIBarButtonItem *b = [ [ UIBarButtonItem alloc ]
                          initWithTitle:@"Done" style:UIBarButtonItemStyleDone target:self action:@selector(done:) ];
    self.navigationItem.rightBarButtonItem = b;
    
    
    self.sensitivity = TOLERANCE;
    self.br_sensitivity = BR_TOLERANCE;
    //self.touch_x = 0;
    //self.touch_y = 0;
    //self.touch_bl = 0;
    //self.touch_bh = 0;
    //self.touch_gl = 0;
    //self.touch_gh = 0;
    //self.touch_rl = 0;
    //self.touch_rh = 0;
    
    self.chroma_started = NO;
    //self.new_touch = NO;
    
    //  init the hue slider...
    self.slider_sensitivity.value = (float)self.sensitivity;
    [ self.slider_sensitivity addTarget:self action:@selector(sliderValueChanged:)
           forControlEvents:UIControlEventValueChanged];
    
    self.slider_br_sensitivity.value = (float)self.br_sensitivity;
    [ self.slider_br_sensitivity addTarget:self action:@selector(sliderBrValueChanged:)
                       forControlEvents:UIControlEventValueChanged];
    
    //  single finger preview...
    UITapGestureRecognizer *singleFingerTap =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleCamPreviewTap:)];
    [self.camPreview addGestureRecognizer:singleFingerTap];
    [singleFingerTap release];
    
    //  single finger practive...
    UITapGestureRecognizer *singleFingerTapPractice =
        [[UITapGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handlePracticeTap:)];
    [self.img_practice_source addGestureRecognizer:singleFingerTapPractice];
    [singleFingerTapPractice release];

    
    //  long finger...
    UILongPressGestureRecognizer *longFingerTap =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                            action:@selector(handleCamPreviewLongPress:)];
    [self.camPreview addGestureRecognizer:longFingerTap];
    [longFingerTap release];
   
    //gw analyze
    self.queue = [dispatch_queue_create("cameraQueue", NULL) autorelease];
}

-(IBAction)sliderValueChanged:(UISlider *)sender
{
    
    AppDelegate *app = ( AppDelegate *)
        [ [ UIApplication sharedApplication] delegate ];
    
    int toler = self.slider_sensitivity.value;
    NSLog(@"toler %d\n", toler);
    
    app.chroma_video.touch_hue_l = MAX( app.chroma_video.touch_hue-toler, 0 );
    app.chroma_video.touch_hue_h = MIN( app.chroma_video.touch_hue+toler, 255 );
}


-(IBAction)sliderBrValueChanged:(UISlider *)sender
{
    
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];
    
    int toler = self.slider_br_sensitivity.value;
    NSLog(@"br toler %d\n", toler);
    
    app.chroma_video.touch_brightness_l = MAX( app.chroma_video.touch_brightness-toler, 0 );
    app.chroma_video.touch_brightness_h = MIN( app.chroma_video.touch_brightness+toler, 255 );
}

- (void) done: (id)sender
{
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [ app settings_go_back ];
}

- (void) startChroma
{
    if ( self.chroma_started ) return;
    self.chroma_started = YES;
    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [app.chroma_video.captureOutput setSampleBufferDelegate:self queue:self.queue];
    
    //dispatch_release(self.queue);

}

- (void) stopChroma
{
    if ( !self.chroma_started ) return;
    self.chroma_started = NO;

    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    [app.chroma_video.captureOutput setSampleBufferDelegate:nil queue:nil];
    
}

- (void) getCamParams:(id)obj
{
}


- (void) finishInit
{
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    if ( app.chroma_video.have_chroma )
    {
        [ self startChroma ];
    }
}

- (void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    //[self.navigationItem setHidesBackButton:YES animated:NO];
    

    self.chroma_started = NO;
    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    //CGRect b = self.camPreview.bounds;
	app.chroma_video.captureVideoPreviewLayer.frame = self.camPreview.bounds;
    
    [self.camPreview.layer addSublayer:app.chroma_video.captureVideoPreviewLayer];
    
    //  Flip based on camera...
    if (app.chroma_video.is_front)
        self.camPreview.transform = CGAffineTransformMakeScale(-1.0f, 1.0f);
        
    //  determine locked...    
    BOOL locked = [ ChromaVideo isLocked:app.chroma_video.device ];
    if (locked)
    {
        self.btn_cam_lock.hidden = NO;
        //self.btn_cam_lock.titleLabel.text = @"UnLock";
    }
    else
    {
        self.btn_cam_lock.hidden = YES;
    }
    
    
    
    if (app.chroma_video.have_chroma)
    {
        self.label_coverage.hidden = NO;
        self.label_sensitivity.hidden = NO;
        self.slider_sensitivity.hidden = NO;
        self.label_br_sensitivity.hidden = NO;
        self.slider_br_sensitivity.hidden = NO;
        self.btn_practice.hidden = NO;
    }
    else
    {
        self.label_coverage.hidden = YES;
        self.label_sensitivity.hidden = YES;
        self.slider_sensitivity.hidden = YES;
        self.label_br_sensitivity.hidden = YES;
        self.slider_br_sensitivity.hidden = YES;
        self.btn_practice.hidden = YES;

    }
    
    self.practicing = NO;
    self.activity_practice.hidden = YES;
    [self.activity_practice stopAnimating];
    self.lbl_please_wait.hidden = YES;
    self.btn_capture.enabled = YES;
    self.lbl_practice.hidden = YES;
    self.lbl_cam.hidden = NO;
    
    if (self.practicing)
    {
        self.btn_practice.titleLabel.text = @"Stop  Practice";
    }
    else
    {
        self.btn_practice.titleLabel.text = @"Practice Image";
    }
    
    
    //  Delay finalization of init because it takes camera a little while to start...
    [ self performSelector:@selector(finishInit) withObject:self afterDelay:1 ];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    
    [ self stopChroma ];

    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    [ app.chroma_video.captureVideoPreviewLayer removeFromSuperlayer ];
    
}

- (UIColor *) colorOfPoint:(CGPoint)point
{
    
    unsigned char pixel[4] = {0};
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(pixel, 1, 1, 8, 4,colorSpace,
                                                 kCGBitmapAlphaInfoMask );
    
                                                 //gw XCODE 5kCGImageAlphaPremultipliedLast);
    
    CGContextTranslateCTM(context, -point.x, -point.y);
    
    [self.camPreview.layer renderInContext:context];
    
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    
    UIColor *color =
        [UIColor colorWithRed:pixel[0]/255.0 green:pixel[1]/255.0 blue:pixel[2]/255.0 alpha:pixel[3]/255.0];
    
    return color;
}


- (void)handleCamPreviewTap:(UITapGestureRecognizer *)recognizer
{
    
    if (self.rendering) return;
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    
    AppDelegate * app = ( AppDelegate *)[[UIApplication sharedApplication ] delegate ];
    
    app.chroma_video.touch_x = location.x;
    app.chroma_video.touch_y = location.y;
    app.chroma_video.new_touch = YES;
    
    NSLog(@"tap %d %d", app.chroma_video.touch_x, app.chroma_video.touch_y);
}

- (UIColor*)getRGBPixelColorAtPoint:(CGPoint)point rr:(UInt8 *)rr gg:(UInt8 *)gg bb:(UInt8* )bb
{
    UIColor* color = nil;
    
    UIImage *img = [ self.img_practice_source image ];
    CGImageRef cgImage = [img CGImage];
    size_t width = CGImageGetWidth(cgImage);
    size_t height = CGImageGetHeight(cgImage);
    
    //gw NSUInteger x = (NSUInteger)floor(point.x);
    //NSUInteger y = height - (NSUInteger)floor(point.y);
    //gw NSUInteger y = (NSUInteger)floor(point.y);
    
    float xx = (float)(point.x*1.0/(272-1));
    float yy = (float)(point.y*1.0/(363-1));
    
    //rot
    float nxx = 1.0 - yy;
    float nyy = xx;
    
    
    //rot
    xx = nxx;
    yy = nyy;
    
    //rot x = (int)(xx*width);
    //rot y = (int)(yy*height);
    NSUInteger x = width - (int)(xx*width);
    NSUInteger y = height - (int)(yy*height);
    
    NSLog(@"XY AND frac %d %d - %f %f - %f %f\n",x,y, xx,yy, nxx,nyy);
    
    
    if ((xx >=0.0) && (xx <= 1.0) && (yy>=0.0)&&(yy <=1.0))
    {
    	CGDataProviderRef provider = CGImageGetDataProvider(cgImage);
    	CFDataRef bitmapData = CGDataProviderCopyData(provider);
    	const UInt8* data = CFDataGetBytePtr(bitmapData);
        
        //rot
    	//size_t offset = ((width * y) + x) * 4;
        size_t offset = ((width * y) + x) * 4;
        if ( offset>= height*width*4 )
        {
            NSLog(@"offset too great!\n");
            offset = 0;
        }
        
        NSLog(@"offset %ld %zd\n", height*width*4, offset);
        
        
        UInt8 red = data[offset];
        *rr = red;
        
        UInt8 green = data[offset+1];
        *gg = green;
        
        UInt8 blue = data[offset+2];
        *bb = blue;
        UInt8 alpha = data[offset+3];
    	CFRelease(bitmapData);
    	color = [UIColor colorWithRed:red/255.0f green:green/255.0f blue:blue/255.0f alpha:alpha/255.0f];
    }
    
    return color;
}

-(void)imageDump:(UIImage *)image
{
    //UIImage* image = [UIImage imageNamed:file];
    CGImageRef cgimage = image.CGImage;
    
    size_t width  = CGImageGetWidth(cgimage);
    size_t height = CGImageGetHeight(cgimage);
    
    size_t bpr = CGImageGetBytesPerRow(cgimage);
    size_t bpp = CGImageGetBitsPerPixel(cgimage);
    size_t bpc = CGImageGetBitsPerComponent(cgimage);
    //size_t bytes_per_pixel = bpp / bpc;
    
    CGBitmapInfo info = CGImageGetBitmapInfo(cgimage);
    
    NSLog(
          @"\n"
          "===== %@ =====\n"
          "CGImageGetHeight: %d\n"
          "CGImageGetWidth:  %d\n"
          "CGImageGetColorSpace: %@\n"
          "CGImageGetBitsPerPixel:     %d\n"
          "CGImageGetBitsPerComponent: %d\n"
          "CGImageGetBytesPerRow:      %d\n"
          "CGImageGetBitmapInfo: 0x%.8X\n"
          "  kCGBitmapAlphaInfoMask     = %s\n"
          "  kCGBitmapFloatComponents   = %s\n"
          "  kCGBitmapByteOrderMask     = %s\n"
          "  kCGBitmapByteOrderDefault  = %s\n"
          "  kCGBitmapByteOrder16Little = %s\n"
          "  kCGBitmapByteOrder32Little = %s\n"
          "  kCGBitmapByteOrder16Big    = %s\n"
          "  kCGBitmapByteOrder32Big    = %s\n",
          @"",
          (int)width,
          (int)height,
          CGImageGetColorSpace(cgimage),
          (int)bpp,
          (int)bpc,
          (int)bpr,
          (unsigned)info,
          (info & kCGBitmapAlphaInfoMask)     ? "YES" : "NO",
          (info & kCGBitmapFloatComponents)   ? "YES" : "NO",
          (info & kCGBitmapByteOrderMask)     ? "YES" : "NO",
          (info & kCGBitmapByteOrderDefault)  ? "YES" : "NO",
          (info & kCGBitmapByteOrder16Little) ? "YES" : "NO",
          (info & kCGBitmapByteOrder32Little) ? "YES" : "NO",
          (info & kCGBitmapByteOrder16Big)    ? "YES" : "NO",
          (info & kCGBitmapByteOrder32Big)    ? "YES" : "NO"
          );
    
    CGDataProviderRef provider = CGImageGetDataProvider(cgimage);
    NSData* data = (id)CGDataProviderCopyData(provider);
    [data autorelease];
    //const uint8_t* bytes = [data bytes];
    
    /*
    printf("Pixel Data:\n");
    for(size_t row = 0; row < height; row++)
    {
        for(size_t col = 0; col < width; col++)
        {
            const uint8_t* pixel =
            &bytes[row * bpr + col * bytes_per_pixel];
            
            printf("(");
            for(size_t x = 0; x < bytes_per_pixel; x++)
            {
                printf("%.2X", pixel[x]);
                if( x < bytes_per_pixel - 1 )
                    printf(",");
            }
            
            printf(")");
            if( col < width - 1 )
                printf(", ");
        }
        
        printf("\n");
    }
     */
}


- (void)handlePracticeTap:(UITapGestureRecognizer *)recognizer
{
    if (self.rendering) return;
    
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];
    
    self.rendering = YES;
    self.activity_practice.hidden = NO;
    [self.activity_practice startAnimating];
    self.lbl_please_wait.hidden = NO;
    self.slider_br_sensitivity.enabled = NO;
    self.slider_sensitivity.enabled = NO;
    self.btn_practice.enabled = NO;
    self.btn_cam_lock.enabled = NO;
    
    CGPoint location = [recognizer locationOfTouch:0 inView:self.img_practice_source];
    NSLog(@"loc1 %f %f\n", location.x, location.y);

    app.chroma_video.touch_x = location.x;
    app.chroma_video.touch_y = location.y;
    app.chroma_video.new_touch = YES;
    
    if (app.chroma_video.new_touch) // signal to get the chroma color at touch pixel...
    {
        app.chroma_video.new_touch = NO;
        
        //gw analyze
        UInt8 bc = 0;
        UInt8 gc = 0;
        UInt8 rc = 0;
        CGPoint location = CGPointMake(app.chroma_video.touch_x, app.chroma_video.touch_y);
        UIColor *touch_color = [ self getRGBPixelColorAtPoint:location rr:&rc gg:&gc bb:&bc ];
        
        app.chroma_video.h_toler = self.slider_sensitivity.value;
        //NSLog(@"toler %d %d %d %d\n", toler, rc, gc, bc);
        
        
        uint8_t touch_b = bc; //addr[0];
        app.chroma_video.touch_bl =
            MAX( touch_b - app.chroma_video.h_toler, 0 );
        app.chroma_video.touch_bh =
            MIN( touch_b + app.chroma_video.h_toler, 255 );
        
        uint8_t touch_g = gc; //addr[1]; 
        app.chroma_video.touch_gl = MAX( touch_g-app.chroma_video.h_toler, 0 );
        app.chroma_video.touch_gh = MIN( touch_g+app.chroma_video.h_toler, 255 );
        
        uint8_t touch_r = rc; //addr[2];
        app.chroma_video.touch_rl = MAX( touch_r-app.chroma_video.h_toler, 0 );
        app.chroma_video.touch_rh = MIN( touch_r+app.chroma_video.h_toler, 255 );
        
        NSLog(@" RGB  B %d %d G %d %d R %d %d",
              app.chroma_video.touch_bl, app.chroma_video.touch_bh,
              app.chroma_video.touch_gl, app.chroma_video.touch_gh,
              app.chroma_video.touch_rl, app.chroma_video.touch_rh
              );
        
        CGFloat hue, brightness, saturation, alpha;
            [ touch_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ];
        app.chroma_video.touch_hue = (uint8_t) (hue * 0xFF);
        app.chroma_video.touch_hue_l = MAX(
                app.chroma_video.touch_hue-app.chroma_video.h_toler, 0 );
        app.chroma_video.touch_hue_h = MIN( app.chroma_video.touch_hue+
                                           app.chroma_video.h_toler, 255 );
        
        app.chroma_video.br_toler = self.slider_br_sensitivity.value;
        app.chroma_video.touch_brightness = (uint8_t)( brightness * 0xFF );
        app.chroma_video.touch_brightness_l =
            MAX( app.chroma_video.touch_brightness-
                app.chroma_video.br_toler, 0 );
        app.chroma_video.touch_brightness_h = MIN(
                app.chroma_video.touch_brightness+app.chroma_video.br_toler, 255 );
        
        app.chroma_video.touch_saturation = (uint8_t)( saturation * 0xFF );
        
        NSLog(@" HSB %d %d %d", app.chroma_video.touch_hue,
              app.chroma_video.touch_saturation, app.chroma_video.touch_brightness );
        
        [self.colorPreview performSelectorOnMainThread:@selector(setBackgroundColor:)
                                            withObject:touch_color waitUntilDone:YES];
        app.chroma_video.have_chroma = YES;
        
        
        [ self performSelector:@selector(_handlePracticeTap:) withObject:self afterDelay:0.5 ];
    }
    
    
}

void callbackFunc(void *info, const void *data, size_t size)
{
    free( (void *)data);
}


- (void)_handlePracticeTap:(UITapGestureRecognizer *)recognizer
{
    
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];
    
    NSLog(@"tap %d %d",
          app.chroma_video.touch_x,
          app.chroma_video.touch_y);
    

    if (app.chroma_video.have_chroma)
    {
        //  Copy original image...
        UIImage *img = [ self.img_practice_source image ];
        //[ self imageDump:img];
        CGImageRef cgImage = [img CGImage];
        CGDataProviderRef rprovider = CGImageGetDataProvider(cgImage);
        CFDataRef rbitmapData = CGDataProviderCopyData(rprovider);
        const UInt8* rbaseAddress = CFDataGetBytePtr(rbitmapData);
        size_t width = CGImageGetWidth(cgImage);
        size_t height = CGImageGetHeight(cgImage);
        
        //  create new buffer...
        GLubyte *wbuffer = malloc(width * height * 4);
        // make data provider from buffer
        CGDataProviderRef wprovider = CGDataProviderCreateWithData(NULL, wbuffer,
                                                                   (width* height*4),
                                                                   callbackFunc);
    
        self.activity_practice.hidden = NO;
        [self.activity_practice startAnimating];
        app.chroma_video.total_pix = 0;
        app.chroma_video.chroma_pix = 0;
        
        
        for ( int i=0;i<height;i++)
        {
            for (int k=0;k<width;k++)
            {
                uint8_t *raddr = ( (UInt8 *)rbaseAddress + ( i*(width*4) + (k)*4) );
                uint8_t _r = raddr[0];
                uint8_t _g = raddr[1];
                uint8_t _b = raddr[2];
                
                app.chroma_video.total_pix++;
                
                float outH, outS, outL;
                {
                    float r = _r/255.0f;
                    float g = _g/255.0f;
                    float b = _b/255.0f;
                    
                    float h,s, l, v, m, vm, r2, g2, b2;
                    
                    h = 0;
                    s = 0;
                    l = 0;
                    //gw analyze
                    l = l;
                    
                    v = MAX(r, g);
                    v = MAX(v, b);
                    m = MIN(r, g);
                    m = MIN(m, b);
                    
                    l = (m+v)/2.0f;
                    //gw analyze
                    l = l;
                    
                    if (l <= 0.0)
                    {
                        //if(outH)
                        outH = h;
                        //if(outS)
                        outS = s;
                        //if(outL)
                        outL = l;
                        
                        //return;
                    }
                    else
                    {
                        
                        vm = v - m;
                        s = vm;
                        
                        if (s > 0.0f)
                        {
                            s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
                            
                            {
                                r2 = (v - r)/vm;
                                g2 = (v - g)/vm;
                                b2 = (v - b)/vm;
                                
                                if (r == v){
                                    h = (g == m ? 5.0f + b2 : 1.0f - g2);
                                }else if (g == v){
                                    h = (b == m ? 1.0f + r2 : 3.0 - b2);
                                }else{
                                    h = (r == m ? 3.0f + g2 : 5.0f - r2);
                                }
                                
                                h/=6.0f;
                                
                                //if(outH)
                                outH = h;
                                //if(outS)
                                outS = s;
                                //if(outL)
                                outL = l;
                            }
                            
                            
                        }
                        else
                        {
                            //if(outH)
                            outH = h;
                            //if(outS)
                            outS = s;
                            //if(outL)
                            outL = l;
                            
                            //return;
                        }
                        
                    }
                    //gw analyze
                    l = l;
                    outS = outS;
                }
                
                uint8_t hh = (int)(outH * 0xFF);
                //uint8_t ss = (int)(outS * 0xFF);
                uint8_t bb = (int)(outL * 0xFF);
                
                uint8_t *waddr = ( (UInt8 *)wbuffer + ( i*(width*4) + (k)*4) );
                if ( ( hh >= app.chroma_video.touch_hue_l ) && ( hh <=app.chroma_video.touch_hue_h ) &&
                    ( bb >= app.chroma_video.touch_brightness_l ) && ( bb <=app.chroma_video.touch_brightness_h ) )
                {
                    
                    waddr[0] = 0x00; //red
                    waddr[1] = 0x00; //green
                    waddr[2] = 0x00; //blue
                    waddr[3] = 0x00;
                    app.chroma_video.chroma_pix++;
                }
                else
                {
                    waddr[0] = _r;
                    waddr[1] = _g; //green
                    waddr[2] = _b; //blue
                    waddr[3] = 0xff;
                }
            }
        }
              
            // set up for CGImage creation
            int bitsPerComponent = 8;
            int bitsPerPixel = 32;
            int bytesPerRow = 4 * width;
            CGColorSpaceRef colorSpaceRef = CGColorSpaceCreateDeviceRGB();
            //CGBitmapInfo bitmapInfo = kCGBitmapByteOrderDefault;
            CGBitmapInfo bitmapInfo =
                kCGBitmapByteOrderDefault | kCGImageAlphaLast;
            CGColorRenderingIntent renderingIntent = kCGRenderingIntentDefault;
            CGImageRef imageRef = CGImageCreate(width, height, bitsPerComponent, bitsPerPixel, bytesPerRow, colorSpaceRef, bitmapInfo, wprovider, NULL, NO, renderingIntent);
    
            // test for alpha
            //CGBitmapInfo info = CGImageGetAlphaInfo(imageRef);	// Note: Returns kCGImageAlphaNone
    
            // make UIImage from CGImage
            UIImage *newUIImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight ];
    
            //[ self.chromaPreview.image release];
            [ self.chromaPreview setImage:newUIImage ];
   
            /*We release some components*/
            CGColorSpaceRelease(colorSpaceRef);
            //[ newUIImage release ];
        
        
            //gw analyze...
            CFRelease(rbitmapData);
            CGImageRelease(imageRef);
        }

    
    self.activity_practice.hidden = YES;
    [self.activity_practice stopAnimating];
    self.lbl_please_wait.hidden = YES;
    self.rendering = NO;
    self.slider_br_sensitivity.enabled = YES;
    self.slider_sensitivity.enabled = YES;
    self.btn_cam_lock.enabled = NO;
    self.btn_practice.enabled = YES;
    

}


- (void)handleCamPreviewLongPress:(UITapGestureRecognizer *)recognizer
{
    
    if (self.rendering) return;
    
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];
    
    BOOL locked = [ ChromaVideo isLocked:app.chroma_video.device ];
    if (locked)
    {
        NSLog(@"already locked");
        return;
    }
    
    CGPoint location = [recognizer locationInView:recognizer.view];
    
    float xx = (float)location.x / (272 - 1);
    float yy = (float)location.y / (363 - 1);
    
    if (xx<0) xx = 0.0;
    else if (xx>1.0) xx = 1.0;
    
    if (yy<0) yy = 0.0;
    else if (yy>1.0) yy = 1.0;
    
    NSLog(@"long press %f %f", xx, yy);
    
    location.x = xx;
    location.y = yy;
    [ ChromaVideo setManualWithZone:app.chroma_video.device pt:location];
    
    if (locked)
    {
        self.btn_cam_lock.hidden = NO;
        //self.btn_cam_lock.titleLabel.text = @"Unlock";
    }
    else
    {
        self.btn_cam_lock.hidden = NO;
    }
    
}

-(IBAction)btn_action_practice:(id)sender
{
    
    if (self.rendering) return;
    
    self.practicing = !self.practicing;
    if (self.practicing)
    {
        [ self.btn_practice setTitle:@"Stop Practice" forState:UIControlStateNormal ];
        self.btn_cam_lock.hidden = YES;
        self.btn_capture.enabled = NO;
    }
    else
    {
        [ self.btn_practice setTitle:@"Practice Image" forState:UIControlStateNormal ];
        self.btn_cam_lock.hidden = NO;
        self.btn_capture.enabled = YES;
    }
    
    if (self.practicing)
    {
        //[self.session stopRunning];
        
        self.img_practice_source.hidden = NO;
        self.camPreview.hidden = YES;
        UIImage *img = [ UIImage imageNamed:@"forephoto1_sm_rotleft.png" ];
        UIImage *nimg = [ UIImage imageWithCGImage:img.CGImage scale:1.0 orientation:UIImageOrientationRight ];
        self.img_practice_source.image = nimg;
        
        self.btn_capture.enabled = NO;
        
        
        self.lbl_practice.hidden = NO;
        self.lbl_cam.hidden = YES;

    }
    else
    {
        //[self.session startRunning ];
        
        self.img_practice_source.hidden = YES;
        self.camPreview.hidden = NO;
        
        
        self.btn_capture.enabled = YES;

        
        self.lbl_practice.hidden = YES;
        self.lbl_cam.hidden = NO;
    }
}

#pragma mark -
#pragma mark AVCaptureSession delegate
- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
	   fromConnection:(AVCaptureConnection *)connection
{
    
    if ( !self.chroma_started)
    {
        NSLog(@"deny capture output in cvc");
        return;
    }
    
    NSLog(@"ok capture output in cvc");
    AppDelegate *app = ( AppDelegate *)
        [ [ UIApplication sharedApplication] delegate ];
    
    app.chroma_video.h_toler = self.slider_sensitivity.value;
    app.chroma_video.br_toler = self.slider_br_sensitivity.value;
    
    [ app.chroma_video vidCaptureOutput:captureOutput
                  didOutputSampleBuffer:sampleBuffer
                         fromConnection:connection
                          chromaPreview:self.chromaPreview
                            label_coverage:self.label_coverage
                            colorPreview:self.colorPreview ];
#if 0
    
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];
    
	/*We create an autorelease pool because as we are not in the main_queue our code is
	 not executed in the main thread. So we have to create an autorelease pool for the thread we are in*/
	
	NSAutoreleasePool * pool = [[NSAutoreleasePool alloc] init];
	
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    /*Lock the image buffer*/
    CVPixelBufferLockBaseAddress(imageBuffer,0);
    /*Get information about the image*/
    uint8_t *baseAddress = (uint8_t *)CVPixelBufferGetBaseAddress(imageBuffer);
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    /* convert to image/video dimensions */
    int xx = (int)self.touch_x* 480.0/ (272 - 1);
    int yy = (int)self.touch_y* 640.0/ (363 - 1);
   
    if (self.new_touch) // signal to get the chroma color at touch pixel...
    {
        self.new_touch = NO;
        
        uint8_t *addr = 0;
        
        if (self.is_front)
            addr = (baseAddress + ( xx *bytesPerRow + ( (yy)*4) ));
        else
            addr = (baseAddress + ( (480 - 1 - xx )*bytesPerRow + ( (yy)*4) ));
        
        int toler = self.slider_sensitivity.value;
        NSLog(@"toler %d\n", toler);
        
        uint8_t touch_b = addr[0];
        self.touch_bl = MAX( touch_b-toler, 0 );
        self.touch_bh = MIN( touch_b+toler, 255 );
        
        uint8_t touch_g = addr[1];
        self.touch_gl = MAX( touch_g-toler, 0 );
        self.touch_gh = MIN( touch_g+toler, 255 );
        
        uint8_t touch_r = addr[2];
        self.touch_rl = MAX( touch_r-toler, 0 );
        self.touch_rh = MIN( touch_r+toler, 255 );
        
        NSLog(@" RGB  B %d %d G %d %d R %d %d",
              self.touch_bl, self.touch_bh,
              self.touch_gl, self.touch_gh,
              self.touch_rl, self.touch_rh
              );
        
        
        UIColor *touch_color = [ UIColor colorWithRed:touch_r/255.0 green:touch_g/255.0
                                             blue:touch_b/255.0 alpha:1.0 ];
        
        
        CGFloat hue, brightness, saturation, alpha;
            [ touch_color getHue:&hue saturation:&saturation brightness:&brightness alpha:&alpha ];
        app.chroma_video.touch_hue = (uint8_t) (hue * 0xFF);
        app.chroma_video.touch_hue_l = MAX( app.chroma_video.touch_hue-toler, 0 );
        app.chroma_video.touch_hue_h = MIN( app.chroma_video.touch_hue+toler, 255 );
        
        int br_toler = self.slider_br_sensitivity.value;
        app.chroma_video.touch_brightness = (uint8_t)( brightness * 0xFF );
        app.chroma_video.touch_brightness_l = MAX( app.chroma_video.touch_brightness-br_toler, 0 );
        app.chroma_video.touch_brightness_h = MIN( app.chroma_video.touch_brightness+br_toler, 255 );
        
        app.chroma_video.touch_saturation = (uint8_t)( saturation * 0xFF );
        
        NSLog(@" HSB %d %d %d", app.chroma_video.touch_hue, app.chroma_video.touch_saturation,
              app.chroma_video.touch_brightness );
        
        [self.colorPreview performSelectorOnMainThread:@selector(setBackgroundColor:)
                                            withObject:touch_color waitUntilDone:YES];
        app.chroma_video.have_chroma = YES;
    }
    
    if (app.chroma_video.have_chroma )
    {
        self.total_pix = 0;
        self.chroma_pix = 0;
        for ( int i=0;i<480;i++)
        {
        for (int k=0;k<640;k++)
        {
            uint8_t *addr = (baseAddress + ( i*bytesPerRow + (k)*4) );
            uint8_t _b = addr[0];
            uint8_t _g = addr[1];
            uint8_t _r = addr[2];
            
            self.total_pix++;
            
            float outH, outS, outL;
            {
                float r = _r/255.0f;
                float g = _g/255.0f;
                float b = _b/255.0f;
                
                float h,s, l, v, m, vm, r2, g2, b2;
                
                h = 0;
                s = 0;
                l = 0;
                
                v = MAX(r, g);
                v = MAX(v, b);
                m = MIN(r, g);
                m = MIN(m, b);
                
                l = (m+v)/2.0f;
                
                if (l <= 0.0)
                {
                    //if(outH)
                        outH = h;
                    //if(outS)
                        outS = s;
                    //if(outL)
                        outL = l;
                    
                    //return;
                }
                else
                {
                
                    vm = v - m;
                    s = vm;
                
                    if (s > 0.0f)
                    {
                        s/= (l <= 0.5f) ? (v + m) : (2.0 - v - m);
                        
                        {
                            r2 = (v - r)/vm;
                            g2 = (v - g)/vm;
                            b2 = (v - b)/vm;
                            
                            if (r == v){
                                h = (g == m ? 5.0f + b2 : 1.0f - g2);
                            }else if (g == v){
                                h = (b == m ? 1.0f + r2 : 3.0 - b2);
                            }else{
                                h = (r == m ? 3.0f + g2 : 5.0f - r2);
                            }
                            
                            h/=6.0f;
                            
                            //if(outH)
                            outH = h;
                            //if(outS)
                            outS = s;
                            //if(outL)
                            outL = l;
                        }
                        
                        
                    }
                    else
                    {
                        //if(outH)
                        outH = h;
                        //if(outS)
                        outS = s;
                        //if(outL)
                        outL = l;
                        
                        //return;
                    }
                    
                }
            }
            
            uint8_t hh = (int)(outH * 0xFF);
            //uint8_t ss = (int)(outS * 0xFF);
            uint8_t bb = (int)(outL * 0xFF);
            
            
            if ( ( hh >= app.chroma_video.touch_hue_l ) && ( hh <=app.chroma_video.touch_hue_h ) &&
                ( bb >= app.chroma_video.touch_brightness_l ) && ( bb <=app.chroma_video.touch_brightness_h ) )
            {
                addr[0] = 0x00;
                addr[1] = 0x00;
                addr[2] = 0x00;
                addr[3] = 0x00;
                self.chroma_pix++;
            }
                    }
        }
    
    
        /*Create a CGImageRef from the CVImageBufferRef*/
        CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
        CGContextRef newContext = CGBitmapContextCreate(baseAddress, width, height, 8, bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
        CGImageRef newImage = CGBitmapContextCreateImage(newContext);
    
        /*We release some components*/
        CGContextRelease(newContext);
        CGColorSpaceRelease(colorSpace);
    
    
    /*We display the result on the custom layer. All the display stuff must be done in the main thread because
	 UIKit is no thread safe, and as we are not in the main thread (remember we didn't use the main_queue)
	 we use performSelectorOnMainThread to call our CALayer and tell it to display the CGImage.*/
	//[self.customLayer performSelectorOnMainThread:@selector(setContents:) withObject: (id) newImage waitUntilDone:YES];
	
	/*We display the result on the image view (We need to change the orientation of the image so that the video is displayed correctly).
	 Same thing as for the CALayer we are not in the main thread so ...*/
        UIImage *image=
            [UIImage imageWithCGImage:newImage scale:1.0 orientation:UIImageOrientationRight];
    //UIImage *image= [UIImage imageWithCGImage:newImage ];
	
        
	/*We relase the CGImageRef*/
        CGImageRelease(newImage);
	
        [self.chromaPreview performSelectorOnMainThread:@selector(setImage:) withObject:image waitUntilDone:NO];

        float coverage = (float)(self.chroma_pix*100.0/self.total_pix);
        NSString *text = [ NSString stringWithFormat:@"Coverage: %02.1f%%", coverage ];
        [self.label_coverage performSelectorOnMainThread:@selector(setText:)
                                              withObject:text waitUntilDone:NO];
	
        //[self.colorPreview performSelectorOnMainThread:@selector(setBackgroundColor:)
      //                                  withObject:touch_color waitUntilDone:YES];
    } // if have_chroma
    
    /*We unlock the  image buffer*/
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
	
    [pool drain];
    
#endif
}

-(IBAction)lock_camera:(id)sender
{
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];
    
    //  lock exposure...
    //[ self.session stopRunning ];
  //  [ self.session beginConfiguration];
    
    //  figure out if we are currently locked...
    BOOL locked = false;
    if (app.chroma_video.device.exposureMode == AVCaptureExposureModeLocked )
        locked = true;
    
    //  set the opposite...
    AVCaptureExposureMode emode = AVCaptureExposureModeLocked;
    //gw analyze
    //AVCaptureFocusMode fmode = AVCaptureFocusModeLocked;
    //AVCaptureWhiteBalanceMode wmode = AVCaptureWhiteBalanceModeLocked;
    if (locked)
    {
        emode =
        AVCaptureExposureModeContinuousAutoExposure;
        //emode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
        //fmode = AVCaptureFocusModeContinuousAutoFocus;
        //wmode = AVCaptureWhiteBalanceModeContinuousAutoWhiteBalance;
    }
    
    NSError *error;
    [ app.chroma_video.device lockForConfiguration:&error];
    
    if ([app.chroma_video.device isExposureModeSupported
         :AVCaptureExposureModeLocked])
         //:AVCaptureFocusModeLocked])
        app.chroma_video.device.exposureMode = emode;
    
    if ([app.chroma_video.device isWhiteBalanceModeSupported
         :AVCaptureWhiteBalanceModeLocked])
         //:AVCaptureFocusModeLocked])
        app.chroma_video.device.whiteBalanceMode = AVCaptureWhiteBalanceModeLocked;
    
    if ([app.chroma_video.device isFocusModeSupported:AVCaptureFocusModeLocked])
        app.chroma_video.device.focusMode = AVCaptureFocusModeLocked;
    
    [ app.chroma_video.device unlockForConfiguration];
    
    //[ self.session commitConfiguration ];
    //[ self.session startRunning ];
    
    // don't make any assumptions it worked...
    if (locked) [ self.btn_cam_lock setTitle:@"Lock it" forState:UIControlStateNormal];
    else [ self.btn_cam_lock setTitle:@"Unlock" forState:UIControlStateNormal];
}
-(IBAction) btn_capture: (id)sender
{
    AppDelegate *app = ( AppDelegate *)
    [ [ UIApplication sharedApplication] delegate ];

    BOOL locked = [ ChromaVideo isLocked:app.chroma_video.device ];
    if ( !locked )
    {
        [ AppDelegate ErrorMessage:@"You need to lock the camera settings by long pressing an area of the live preview" ];
        return;
    }
    
    NSURL *url = [ NSURL URLWithString:@"camera-shutter-click-01"];
    
    [ app playSound:url delegate:nil];
    
    if ( !self.chroma_started )
    {
        [ self startChroma ];
        app.chroma_video.have_chroma = YES;
    }
    
    
    if (app.chroma_video.have_chroma)
    {
        self.label_coverage.hidden = NO;
        self.label_sensitivity.hidden = NO;
        self.slider_sensitivity.hidden = NO;
        self.label_br_sensitivity.hidden = NO;
        self.slider_br_sensitivity.hidden = NO;
        self.btn_practice.hidden = NO;
    }
    else
    {
        self.label_coverage.hidden = YES;
        self.label_sensitivity.hidden = YES;
        self.slider_sensitivity.hidden = YES;
        self.label_br_sensitivity.hidden = YES;
        self.slider_br_sensitivity.hidden = YES;
        self.btn_practice.hidden = YES;

    }
    
    app.chroma_video.new_touch = YES;
    app.chroma_video.touch_x = (int)(self.bgPreview.bounds.size.width*1.0/2.0);
    app.chroma_video.touch_y = (int)(self.bgPreview.bounds.size.height*1.0/2.0);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        // Add the popover button to the left navigation item.
        [self.navigationBar.topItem setLeftBarButtonItem:navigationPaneBarButtonItem
                                                animated:NO];
        
        [_navigationPaneBarButtonItem release];
        _navigationPaneBarButtonItem = [navigationPaneBarButtonItem retain];
    }
}

@end
