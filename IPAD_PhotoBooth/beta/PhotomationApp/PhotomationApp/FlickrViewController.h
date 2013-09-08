//
//  FlickrViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 6/16/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ObjectiveFlickr.h"

@class OAuth;

@interface FlickrViewController : UIViewController
    < UIWebViewDelegate, OFFlickrAPIRequestDelegate >
{
    OFFlickrAPIRequest *flickrRequest;
    UIWebView *webview;
}

//  controls...
@property (nonatomic, retain) IBOutlet UIButton *btn_cancel;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_bg;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_template;
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) IBOutlet UILabel *lbl_message;

//  state...
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, retain) OAuth *oAuth;

//  button actions...
-(IBAction)cancelPressed:(id)sender;

@end
