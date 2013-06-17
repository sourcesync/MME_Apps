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

//@property (nonatomic, retain) IBOutlet UIButton *btn_tweet;
@property (nonatomic, retain) IBOutlet UIButton *btn_cancel;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_bg;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_template;

//  auth stuff...
@property (nonatomic, retain) OFFlickrAPIRequest *flickrRequest;
@property (nonatomic, retain) OAuth *oAuth;

//  web view stuff...
@property (nonatomic, retain) IBOutlet UIWebView *webview;

//  button actions...
-(IBAction)cancelPressed:(id)sender;
//-(IBAction)tweetClick:(UIButton *)sender;

@end
