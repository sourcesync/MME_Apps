//
//  FacebookViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/25/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "FacebookViewController.h"
#import "AppDelegate.h"
#import "UIImage+SubImage.h"
#import "UIImage+Resize.h"

#import <FacebookSDK/FBSessionTokenCachingStrategy.h>
#import <FacebookSDK/FBSession.h>
#import <FacebookSDK/FBAccessTokenData.h>
#import "FBSessionManualTokenCachingStrategy.h"

#import "ASIFormDataRequest.h"


UIInterfaceOrientation current_orientation;


@implementation FacebookViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.webview.delegate = self;

}


-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    //  Initialize orientation...
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fullPath = nil;
    if ( app.current_photo_path && app.current_filtered_path )
    {
        fullPath = app.current_filtered_path;
    }
    else if (app.current_photo_path )
    {
        fullPath = app.current_photo_path;
    }
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:fullPath ] autorelease];
        float width = image.size.width;
        float height = image.size.height;
        
        if ( width > height )
        {
            self.image_facebook =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:NO ];
        }
        else
        {
            self.image_facebook =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:YES ];
        }
        self.imgview_template.image = self.image_facebook;

    }    
    
    //
    //  Initialize orientation...
    //
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
            [ self orientElements:uiorientation  duration:0];
    
    //
    //  UIWebView init...
    //
    
    //  create a facebook login request...
    NSString *urlstr =
        @"https://www.facebook.com/dialog/oauth/?client_id=452798101456639&redirect_uri=http://photomation.mmeink.com/&state=mme&response_type=token&scope=publish_actions";
    NSURL *url = [ NSURL URLWithString:urlstr ];
    NSURLRequest *request = [ NSURLRequest requestWithURL:url ];
    
    // Prepare the web view - flush all caches/cookies
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    self.webview.hidden = YES;
    
    //  make the request...
    self.webview.delegate = self;
    [ self.webview loadRequest:request ];
    
    //
    //  Initialize the label...
    //
    self.lbl_message.text = @"Contacting Facebook...";
    self.lbl_message.hidden = NO;
}

#pragma genera functions


-(void) done
{
    self.webview.delegate = nil;
    
    //if ( self.asi_request!=nil)
    //    [ self.asi_request cancel ];
    //self.asi_request = nil;
    
    [ [ AppDelegate sharedDelegate ] goto_sharephoto:nil ];
}

- (void)showAlert:(NSString *)message
           result:(id)result
            error:(NSError *)error {
    
    NSString *alertMsg;
    NSString *alertTitle;
    if (error) {
        alertTitle = @"Error";
        if (error.fberrorShouldNotifyUser ||
            error.fberrorCategory == FBErrorCategoryPermissions ||
            error.fberrorCategory == FBErrorCategoryAuthenticationReopenSession) {
            alertMsg = error.fberrorUserMessage;
        } else {
            alertMsg = @"Operation failed due to a connection problem, retry later.";
        }
    } else {
        NSDictionary *resultDict = (NSDictionary *)result;
        alertMsg = [NSString stringWithFormat:@"Successfully posted '%@'.", message];
        NSString *postId = [resultDict valueForKey:@"id"];
        if (!postId) {
            postId = [resultDict valueForKey:@"postId"];
        }
        if (postId) {
            alertMsg = [NSString stringWithFormat:@"%@\nPost ID: %@", alertMsg, postId];
        }
        alertTitle = @"Success";
    }
    
    UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:alertTitle
                                                        message:alertMsg
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles:nil];
    [alertView show];
}


-(IBAction)cancelPressed:(id)sender
{
    [ self done ];
}


-(void) processTemplate:(UIImage *)insert
{
    //  Load the template...
    UIImage *template = [ UIImage imageNamed:@"email.jpg" ];
    
    // Resize the template to the final res...
    CGSize sz = CGSizeMake(400,600);
    UIImage *rsize_template = [ template
                               resizedImage:sz interpolationQuality:kCGInterpolationHigh ];
    
    //  Resize the insert...
    //CGSize isz = CGSizeMake(240, 320);
    CGSize isz = CGSizeMake(320, 427);
    UIImage *rsize_insert = [ insert
                             resizedImage:isz interpolationQuality:kCGInterpolationHigh ];
    
    //  Place the insert...
    //CGRect rect = CGRectMake(80, 140, 240, 320);
    CGRect rect = CGRectMake(40, 70, 320, 427);
    UIImage *result = [ rsize_template pasteImage:rsize_insert bounds:rect ];
    
    UIImage *rot = [ UIImage imageWithCGImage:result.CGImage scale:1.0 orientation:UIImageOrientationUp ];
    
    self.imgview_template.image = rot;
}



- (void)requestStarted:(ASIHTTPRequest *)request
{
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    [ self done ];
}

- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    [ self done ];
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    NSLog( @"error: %@", [ request.error description ] );
    [ self done ];
}
- (void)requestRedirected:(ASIHTTPRequest *)request
{
    
}

-(void) postImageNow
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  get the access token...
    NSString *access_token = self.accessToken;
    
    //  get the message...
    //gw NSString *message = [NSString stringWithFormat:@"Photomation Rocks!"];
    NSString *message = app.config.facebook_post_message;
    
    //  Form path to file to upload....
    NSString *fullPath = nil;
    
    if ( app.current_photo_path && app.current_filtered_path )
    {
        fullPath = app.current_filtered_path;
    }
    else if (app.current_photo_path )
    {
        fullPath = app.current_photo_path;
    }
    
    
    //  Make a form request object...
    NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
    self.asi_request = [ASIFormDataRequest requestWithURL:url];
    [self.asi_request  addFile:fullPath forKey:@"file"];
    [self.asi_request  setPostValue:message forKey:@"message"];
    [self.asi_request  setPostValue:access_token forKey:@"access_token"];
    [self.asi_request  setDidFinishSelector:@selector(sendToPhotosFinished:)];
    [self.asi_request  setDelegate:self];
    
    //  Make the request...
    [self.asi_request  startSynchronous];
    
}

-(void)sendToPhotosFinished
{
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma oauth/sdk stuff


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:
    (NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *URLString = [ request.URL absoluteString ];
    //NSLog(@"start-->%@", URLString);
    
    //  Got access token ?
    if ( (URLString!=nil) && ([URLString rangeOfString:@"access_token="].location
                              != NSNotFound))
    {
     
        //  Parse out the access token...
        NSString *accessTokenBegin =
            [[URLString componentsSeparatedByString:@"="] objectAtIndex:1];
        NSString *accessToken =
        [[accessTokenBegin componentsSeparatedByString:@"&"] objectAtIndex:0];
        self.accessToken = accessToken;
        //NSLog(@"access token=%@", accessToken);
        
        //  Parse out the expiration date...
        int idx = [ [URLString componentsSeparatedByString:@"="] count ] - 2;
        NSString *expirationBegin =
            [[URLString componentsSeparatedByString:@"="] objectAtIndex:idx];
        NSString *expiration =
            [[expirationBegin componentsSeparatedByString:@"&"] objectAtIndex:0];
        
        //  Store into defaults...
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:FBTokenInformationTokenKey];
        [defaults setObject:expiration forKey:FBTokenInformationExpirationDateKey];
        [defaults synchronize];
        
        //  Update the ui...
        self.webview.hidden = YES;
        self.lbl_message.text = @"Uploading photo...";
        self.lbl_message.hidden = NO;
        
        //  Schedule posting of image...
        [ self performSelector:@selector( postImageNow ) withObject:self afterDelay:0.01];
        
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *URLString = [[self.webview.request URL] absoluteString];
    //NSLog(@"finish--> %@", URLString);
    
    //  Is there an access token ? ...
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound)
    {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
    }
    
    //  Make sure web view is visible...
    self.webview.hidden = NO;
    
}

#pragma rotation stuff



- (NSUInteger)supportedInterfaceOrientations
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    if ( app.lock_orientation )
    {
        return app.take_pic_supported_orientations;
    }
    else
    {
        NSUInteger orientations = UIInterfaceOrientationMaskAll;
        return orientations;
    }
}

- (BOOL)shouldAutorotate
{
    return YES;
    
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

{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    current_orientation = toInterfaceOrientation;
    
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ UIImage imageNamed:
                                 @"7b-Photomation-iPad-Enter-FB-Login-Screen-Vertical.jpg" ];
        
        self.webview.frame = CGRectMake(44, 216, 680, 711);
        
        self.btn_cancel.frame = CGRectMake( 651, 953, 73, 44 );
        
        
        self.lbl_message.frame =
            CGRectMake( 295, 401, 179, 21 );
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ UIImage imageNamed:
                                 @"07b-Photomation-iPad-Enter-FB-Login-Horizontal.jpg" ];
        
        self.webview.frame = CGRectMake(46, 136, 931, 561);
        
        
        self.btn_cancel.frame = CGRectMake( 904, 713, 73, 44 );
        
        
        self.lbl_message.frame =
            CGRectMake( 423, 237, 179, 21 );
    }
    
    
    //  Depending on current orientation, change the mode for the imageview
    //  to aspect fill...
    if ( current_orientation == UIInterfaceOrientationPortrait )
    {
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
    {
    }
    else if ( current_orientation == UIInterfaceOrientationLandscapeRight )
    {
    }
    else
    {
    }
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        [self orientElements:toInterfaceOrientation duration:duration ];
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        [self orientElements:toInterfaceOrientation duration:duration ];
    }
}





@end
