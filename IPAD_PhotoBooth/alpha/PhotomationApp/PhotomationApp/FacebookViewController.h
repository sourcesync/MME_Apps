//
//  FacebookViewController.h
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/25/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <FacebookSDK/FacebookSDK.h>

#import "ASIFormDataRequest.h"
#import "ASIHTTPRequestDelegate.h"

@interface FacebookViewController : UIViewController
    <FBLoginViewDelegate, UIWebViewDelegate, ASIHTTPRequestDelegate>

//  controls...
@property (nonatomic, retain) IBOutlet UIButton *btn_cancel;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_template;
@property (nonatomic, retain) IBOutlet UIImageView *imgview_bg;
@property (nonatomic, retain) UIImage *image_facebook;
@property (nonatomic, retain) IBOutlet UIWebView *webview;
@property (nonatomic, retain) IBOutlet UILabel *lbl_message;

//  state...
@property (nonatomic, retain) NSString *accessToken;
@property (nonatomic, retain) ASIFormDataRequest *asi_request;

//  actions...
-(IBAction)cancelPressed:(id)sender;

@end
