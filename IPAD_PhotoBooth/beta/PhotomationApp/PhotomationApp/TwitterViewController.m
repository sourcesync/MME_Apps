//
//  TwitterViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/25/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//
#import <Accounts/Accounts.h>
#import <Social/Social.h>
#import <Twitter/Twitter.h>

#import "TwitterViewController.h"

#import "AppDelegate.h"
#import "UIImage+SubImage.h"
#import "UIImage+Resize.h"

#import "OAToken.h"
#import "MGTwitterRequestTypes.h"
#import "OAMutableURLRequest.h"
#import "MGTwitterHTTPURLConnection.h"


//  plainoauth
#import "OAuth.h"
#import "SBJson.h"
#import "OAuthConsumerCredentials.h"
#import "NSString+URLEncoding.h"


NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
NSString *kGetUserInfoStep = @"kGetUserInfoStep";
NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
NSString *kUploadImageStep = @"kUploadImageStep";


@implementation TwitterViewController

@synthesize oAuth;

UIInterfaceOrientation current_orientation;

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
    	
}

- (void)viewDidUnload
{
    [ super viewDidUnload];
    
    self.flickrRequest = nil;
    self.webview.delegate = nil;
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppDelegate *app = [ AppDelegate sharedDelegate ];
    [ app clearRequest];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [ super viewDidDisappear:animated];
    
    [ self.flickrRequest cancel ];
    self.flickrRequest.delegate = nil;
    self.flickrRequest = nil;
    
    self.webview.delegate = nil;
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
    
    AppDelegate *app = [ AppDelegate sharedDelegate ];
    [ app clearRequest];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    UIImage *img = [ AppDelegate GetActivePhoto ];
    self.imgview_template.image = img;
    
    //  Initialize orientation...
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
    
    //  initialize web view...
    self.webview.hidden = YES;
    
    //  Initialize label...
    self.lbl_message.text = @"Contacting Twitter...";
    self.lbl_message.hidden = NO;
    
    //  Initialize notification for auth...
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authUpdate:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    [ self authorizeAction];
}



-(void) done
{
    self.webview.delegate = nil;
    
    [ [ AppDelegate sharedDelegate ] goto_sharephoto:nil ];
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
    
    UIImage *rot = [ UIImage imageWithCGImage:result.CGImage
                                        scale:1.0 orientation:UIImageOrientationUp ];
    
    self.imgview_template.image = rot;
}




-(IBAction)cancelPressed:(id)sender
{
    //[[AppDelegate sharedDelegate] goto_sharephoto:nil ];
    [ self done ];
}

#pragma oauth/flickr

-(NSString *) get_message
{
    AppDelegate *app = [ AppDelegate sharedDelegate ];
    NSString *message = [ NSString stringWithFormat:@"%@", app.config.twitter_post_message ];
    if ( self.append_hash_tag )
    {
        if ( [ app.config.hash_tag hasPrefix:@"#" ] )
            message = [ NSString stringWithFormat:@"%@ #%@", message, app.config.hash_tag ];
        else
            message = [ NSString stringWithFormat:@"%@ %@", message, app.config.hash_tag ];
    }
    return message;
}

-(void)rawTweetWithPic
{
    NSString *kDMPostStatusWithMediaURL =
        @"https://api.twitter.com/1.1/statuses/update_with_media.json";
    

    //gw
    oAuth = [ [ OAuth alloc] initWithConsumerKey:OBJECTIVE__TWITTER_SAMPLE_API_KEY andConsumerSecret:OBJECTIVE__TWITTER_SAMPLE_API_SHARED_SECRET ];
    oAuth.oauth_token = self.flickrRequest.context.OAuthToken;
    oAuth.oauth_token_secret = self.flickrRequest.context.OAuthTokenSecret;
    
    oAuth.oauth_token_authorized = YES;
    NSString *header = [oAuth oAuthHeaderForMethod:@"POST"
                                            andUrl:kDMPostStatusWithMediaURL
                                         andParams:nil];
    //NSLog( @"%@", header);
    //gw
    
    //gw
    // Just some random text that will never occur in the body
    NSString *boundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    //NSData *imageData = UIImageJPEGRepresentation( self.imgview_template.image, 0.8);
    
    //gw
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:kDMPostStatusWithMediaURL]
                                                          cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData
                                                      timeoutInterval:7.0f];
    [request setHTTPMethod:@"POST"];
    [request setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary]
    forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *myRequestData = [NSMutableData data];
    
    
    // media part
    [myRequestData appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"   Content-Disposition: form-data; name=\"media[]\"; filename=\"1.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"Content-Type: application/octet-stream\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //gw
    //[myRequestData appendData:[[NSString stringWithString:[UIImageJPEGRepresentatio(imageData, 1.0) base64EncodedString]] dataUsingEncoding:NSUTF8StringEncoding]];
    NSData *dt = UIImageJPEGRepresentation(self.imgview_template.image,0.8);
    [myRequestData appendData:dt];
    //gw
    
    //  Get the twitter message...
    NSString *message = [ self get_message ];
    NSString *fmt_message = [ NSString stringWithFormat:@"%@\r\n", message ];
    
    //status part
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"Content-Disposition: form-data; name=\"status\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    //gw [myRequestData appendData:[@"Photomation Rocks\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[fmt_message dataUsingEncoding:NSUTF8StringEncoding]];
    
    [myRequestData appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];    // add it to body
    
    [request addValue:header forHTTPHeaderField:@"Authorization"];
    
    [request setHTTPBody:myRequestData];
    
    NSHTTPURLResponse *response = nil;
    NSError *error = nil;
    
    NSData *responseData = [NSURLConnection sendSynchronousRequest:request
                                                 returningResponse:&response
                                                             error:&error];
    
    NSString *responseString = [[NSString alloc] initWithData:responseData
                                                     encoding:NSUTF8StringEncoding];
    NSLog(@"%@", responseString);
    
    [ self done];
}

- (void)authUpdate:(NSNotification *)notification
{
    if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length])
    {
        self.webview.hidden = YES;
        self.lbl_message.hidden = NO;
        self.lbl_message.text = @"Uploading photo...";
        
        [ self performSelector:@selector( rawTweetWithPic ) withObject:self afterDelay:0.01 ];
        
    }
    else
    {
    }
}

- (IBAction)authorizeAction
{
    // if there's already OAuthToken, we want to reauthorize
    if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length]) {
        [[AppDelegate sharedDelegate] setAndStoreFlickrAuthToken:nil secret:nil];
    }
    
    self.flickrRequest.sessionInfo = kFetchRequestTokenStep;
    [self.flickrRequest fetchOAuthRequestTokenWithCallbackURL:[NSURL URLWithString:SRCallbackURLBaseString]];
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didObtainOAuthRequestToken:(NSString *)inRequestToken secret:(NSString *)inSecret
{
    // these two lines are important
    [AppDelegate sharedDelegate].flickrContext.OAuthToken = inRequestToken;
    [AppDelegate sharedDelegate].flickrContext.OAuthTokenSecret = inSecret;
    
    NSURL *authURL = [[AppDelegate sharedDelegate].flickrContext userAuthorizationURLWithRequestToken:inRequestToken requestedPermission:OFFlickrWritePermission];
    
    //gw - code used to launch in external browser...
    // launch externally
    //[[UIApplication sharedApplication] openURL:authURL];
    //gw
    
    
    //
    //  Form request and launch in the uiwebview...
    //
    
    //  Form the request object...
    NSURLRequest *request = [NSURLRequest requestWithURL:authURL ];
    
    //  Flush all cached data to ensure login every time...
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies])
    {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
    
    //  Load the request...
    [ self.webview loadRequest:request ];
    self.webview.delegate = self;
    
}


- (OFFlickrAPIRequest *)flickrRequest
{
    if (!flickrRequest) {
        flickrRequest = [[OFFlickrAPIRequest alloc] initWithAPIContext:[AppDelegate sharedDelegate].flickrContext];
        flickrRequest.delegate = self;
		flickrRequest.requestTimeoutInterval = 60.0;
    }
    
    return flickrRequest;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSString *URLString = [ request.URL absoluteString ];
    NSLog(@"startload url-->%@", URLString);
    
    //  borrowed code alert - do we need this anymore ?
    if ([request.URL.scheme isEqualToString:@"itms-apps"]) {
        [[UIApplication sharedApplication] openURL:request.URL];
        return NO;
    }
    
    //  check if user hit the cancel button in the twitter auth page...
    if ([URLString rangeOfString:@"denied="].location != NSNotFound)
    {
        [ self done ];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *URLString = [[self.webview.request URL] absoluteString];
    NSLog(@"didfinish url--> %@", URLString);
    
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound)
    {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
    }
    
    //  Control visibility of webview while initial handshake is occurring...
    if ( [URLString compare:@"https://api.twitter.com/oauth/authorize" ] == NSOrderedSame )
    {
        //self.webview.hidden = YES;
    }
    
    //  Make sure webview is showing...
    self.webview.hidden = NO;
    
    //  Make sure lbl is hidden...
    self.lbl_message.hidden = YES;
}

/*
- (void)_startUpload:(UIImage *)image
{
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData]
                        suggestedFilename:@"Snap and Run Demo" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
    //[self updateUserInterface:nil];
}
 */

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didCompleteWithResponse:(NSDictionary *)inResponseDictionary
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inResponseDictionary);
    
	if (inRequest.sessionInfo == kUploadImageStep) {
        
        //gw
		//snapPictureDescriptionLabel.text = @"Setting properties...";
        //gw
        
        NSLog(@"%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        
        flickrRequest.sessionInfo = kSetImagePropertiesStep;
        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID, @"photo_id", @"Snap and Run", @"title", @"Uploaded from my iPhone/iPod Touch", @"description", nil]];
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep) {
		
        //[self updateUserInterface:nil];
		
        //gw snapPictureDescriptionLabel.text = @"Done";
        
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        
    }
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest didFailWithError:(NSError *)inError
{
    NSLog(@"%s %@ %@", __PRETTY_FUNCTION__, inRequest.sessionInfo, inError);
	if (inRequest.sessionInfo == kUploadImageStep) {
		
        //gw[self updateUserInterface:nil];
		
        //gw snapPictureDescriptionLabel.text = @"Failed";
		[UIApplication sharedApplication].idleTimerDisabled = NO;
        
		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
        
	}
	else {
		[[[[UIAlertView alloc] initWithTitle:@"API Failed" message:[inError description] delegate:nil cancelButtonTitle:@"Dismiss" otherButtonTitles:nil] autorelease] show];
	}
}

- (void)flickrAPIRequest:(OFFlickrAPIRequest *)inRequest imageUploadSentBytes:(NSUInteger)inSentBytes totalBytes:(NSUInteger)inTotalBytes
{
	if (inSentBytes == inTotalBytes)
    {
		//gw snapPictureDescriptionLabel.text = @"Waiting for Flickr...";
	}
	else
    {
		//gw snapPictureDescriptionLabel.text = [NSString stringWithFormat:@"%u/%u (KB)", inSentBytes / 1024, inTotalBytes / 1024];
	}
}


#pragma - orientation stuff


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
                                 @"7a-Photomation-iPad-Enter-Twitter-Login-Screen-Vertical.jpg" ];
        
        self.webview.frame = CGRectMake(44, 216, 680, 711);
        
        self.btn_cancel.frame = CGRectMake( 651, 953, 73, 44 );
        
        
        self.lbl_message.frame =
            CGRectMake( 295, 401, 179, 21 );

        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ UIImage imageNamed:
            @"07a-Photomation-iPad-Enter-Twitter-Login-Horizontal.jpg" ];
        
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





@synthesize flickrRequest;
@synthesize webview;

@end


/*
 
 
 - (void)showTweetSheet
 {
 //  Create an instance of the Tweet Sheet
 SLComposeViewController *tweetSheet = [SLComposeViewController
 composeViewControllerForServiceType:
 SLServiceTypeTwitter];
 
 // Sets the completion handler.  Note that we don't know which thread the
 // block will be called on, so we need to ensure that any UI updates occur
 // on the main queue
 tweetSheet.completionHandler = ^(SLComposeViewControllerResult result) {
 switch(result) {
 //  This means the user cancelled without sending the Tweet
 case SLComposeViewControllerResultCancelled:
 break;
 //  This means the user hit 'Send'
 case SLComposeViewControllerResultDone:
 break;
 }
 
 //  dismiss the Tweet Sheet
 dispatch_async(dispatch_get_main_queue(), ^{
 [self dismissViewControllerAnimated:NO completion:^{
 NSLog(@"Tweet Sheet has been dismissed.");
 }];
 });
 };
 
 //  Set the initial body of the Tweet
 [tweetSheet setInitialText:@"just setting up my twttr"];
 
 //  Adds an image to the Tweet.  For demo purposes, assume we have an
 //  image named 'larry.png' that we wish to attach
 if (![tweetSheet addImage:[UIImage imageNamed:@"larry.png"]]) {
 NSLog(@"Unable to add the image!");
 }
 
 //  Add an URL to the Tweet.  You can add multiple URLs.
 if (![tweetSheet addURL:[NSURL URLWithString:@"http://twitter.com/"]]){
 NSLog(@"Unable to add the URL!");
 }
 
 //  Presents the Tweet Sheet to the user
 [self presentViewController:tweetSheet animated:NO completion:^{
 NSLog(@"Tweet sheet has been presented.");
 }];
 }
 */
