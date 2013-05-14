//
//  UIImage+SubImage.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/19/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "UIImage+SubImage.h"

@implementation UIImage (SubImage)


void _callbackFunc(void *info, const void *data, size_t size)
{
    free( (void *)data);
}


- (UIImage *)pasteImage:(UIImage *)insert bounds:(CGRect)bounds
{
    
    //  Get pointers into the insert image...
    CGImageRef iRef = insert.CGImage;
    CGDataProviderRef iprovider = CGImageGetDataProvider(iRef);
    CFDataRef ibitmapData = CGDataProviderCopyData(iprovider);
    const UInt8* ibaseAddress = CFDataGetBytePtr(ibitmapData);
    size_t iwidth = CGImageGetWidth(iRef);
    //size_t iheight = CGImageGetHeight(iRef);
    
    //  Get pointers into the original...
    CGImageRef rRef = self.CGImage;
    CGDataProviderRef rprovider = CGImageGetDataProvider(rRef);
    CFDataRef rbitmapData = CGDataProviderCopyData(rprovider);
    const UInt8* rbaseAddress = CFDataGetBytePtr(rbitmapData);
    size_t width = CGImageGetWidth(rRef);
    size_t height = CGImageGetHeight(rRef);
    
    //  Create a new cgimage the size of the original...
    
    //  create new buffer...
    GLubyte *wbuffer = malloc(width * height * 4);
    
    // make data provider from buffer
    CGDataProviderRef wprovider = CGDataProviderCreateWithData(NULL, wbuffer,
                                                               (width* height*4),
                                                               _callbackFunc);
    
    for ( int i=0;i<height;i++)
    {
        for (int k=0;k<width;k++)
        {
            
            uint8_t *waddr = ( (UInt8 *)wbuffer + ( i*(width*4) + (k)*4) );
            
            //  Default to the original image as source of pixel data...
            uint8_t *raddr = ( (UInt8 *)rbaseAddress + ( i*(width*4) + (k)*4) );
            uint8_t _r = raddr[0];
            uint8_t _g = raddr[1];
            uint8_t _b = raddr[2];
            //uint8_t _a = raddr[3];
            
            //  Else choose the insert...
            if ( (i>= bounds.origin.y) && (i<(bounds.origin.y+bounds.size.height)) &&
                 (k>= bounds.origin.x) && (k<(bounds.origin.x+bounds.size.width)) )
            {
                int ii = i- bounds.origin.y;
                int kk = k - bounds.origin.x;
                uint8_t *iaddr = ( (UInt8 *)ibaseAddress + ( ii*(iwidth*4) + (kk)*4) );
                _r = iaddr[0];
                _g = iaddr[1];
                _b = iaddr[2];
                //_a = iaddr[3];
            }
            
            waddr[0] = _r; //red
            waddr[1] = _g; //green
            waddr[2] = _b; //blue
            waddr[3] = 0xff;
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
    CGImageRef imageRef = CGImageCreate(width, height,
                                        bitsPerComponent, bitsPerPixel,
                                        bytesPerRow, colorSpaceRef,
                                        bitmapInfo, wprovider, NULL, NO,
                                        renderingIntent);
    
    
    // make UIImage from CGImage
    UIImage *newUIImage = [UIImage imageWithCGImage:imageRef scale:1.0 orientation:UIImageOrientationRight ];
    
    //  free up stuff...
    
    
    return newUIImage;
    
}

@end
