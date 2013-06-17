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
    
    self.accountStore = [[ACAccountStore alloc] init];
    
    //  oauth / twiter
    
	if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length])
    {
		//authorizeButton.enabled = NO;
	}
	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authUpdate:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
}

- (void)viewDidUnload
{
    self.flickrRequest = nil;
    //self.webview = nil;
    self.webview.delegate = nil;
    
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = app.fpath;
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fname];
    if (fileExists)
    {
        UIImage *image = [[[ UIImage alloc ] initWithContentsOfFile:fname ] autorelease];
        [ self processTemplate:image ];
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        [ self processTemplate:test ];
    }
    
    
    self.webview.hidden = YES;
    
    UIInterfaceOrientation uiorientation =
        [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
    
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    self.webview.hidden = NO;
    
    [ self authorizeAction];
}



-(void) done
{
    self.webview.delegate = nil;
    
    [ [ AppDelegate sharedDelegate ] goto_sharephoto:nil ];
}



- (void)postImage2:(UIImage *)image withStatus:(NSString *)status
{
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
}



- (void)postImage:(UIImage *)image withStatus:(NSString *)status
{
    //[ self showTweetSheet];
    [ self postImage2:image withStatus:status];
    return;
    
    ACAccountType *twitterType =
    [self.accountStore accountTypeWithAccountTypeIdentifier:ACAccountTypeIdentifierTwitter];
    
    SLRequestHandler requestHandler =
    ^(NSData *responseData, NSHTTPURLResponse *urlResponse, NSError *error) {
        if (responseData) {
            NSInteger statusCode = urlResponse.statusCode;
            if (statusCode >= 200 && statusCode < 300) {
                NSDictionary *postResponseData =
                [NSJSONSerialization JSONObjectWithData:responseData
                                                options:NSJSONReadingMutableContainers
                                                  error:NULL];
                NSLog(@"[SUCCESS!] Created Tweet with ID: %@", postResponseData[@"id_str"]);
            }
            else {
                NSLog(@"[ERROR] Server responded: status code %d %@", statusCode,
                      [NSHTTPURLResponse localizedStringForStatusCode:statusCode]);
            }
        }
        else {
            NSLog(@"[ERROR] An error occurred while posting: %@", [error localizedDescription]);
        }
    };
    
    ACAccountStoreRequestAccessCompletionHandler accountStoreHandler =
    ^(BOOL granted, NSError *error) {
        if (granted) {
            NSArray *accounts = [self.accountStore accountsWithAccountType:twitterType];
            NSURL *url = [NSURL URLWithString:@"https://api.twitter.com"
                          @"/1.1/statuses/update_with_media.json"];
            NSDictionary *params = @{@"status" : status};
            SLRequest *request = [SLRequest requestForServiceType:SLServiceTypeTwitter
                                                    requestMethod:SLRequestMethodPOST
                                                              URL:url
                                                       parameters:params];
            NSData *imageData = UIImageJPEGRepresentation(image, 1.f);
            [request addMultipartData:imageData
                             withName:@"media[]"
                                 type:@"image/jpeg"
                             filename:@"image.jpg"];
            [request setAccount:[accounts lastObject]];
            [request performRequestWithHandler:requestHandler];
        }
        else {
            NSLog(@"[ERROR] An error occurred while asking for user authorization: %@",
                  [error localizedDescription]);
        }
    };
    
    [self.accountStore requestAccessToAccountsWithType:twitterType
                                               options:NULL
                                            completion:accountStoreHandler];
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

- (IBAction)tweetClick:(UIButton *)sender
{
    UIImage *img = self.imgview_template.image;
    
    [ self postImage:img withStatus:@"stuff"];
}


#pragma oauth/flickr

-(void)rawTweetWithPic
{
    NSString *kDMPostStatusWithMediaURL =
        @"https://api.twitter.com/1.1/statuses/update_with_media.json";
    

    //gw
    //NSString *oauth_ehader = [super oAuthHeaderForMethod:@"POST"
    //                                            andUrl:kDMPostStatusWithMediaURL
    //                                         andParams:params
     //                                   andTokenSecret:self.oauth_token_secret];
    
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
    
    //status part
    [myRequestData appendData:[[NSString stringWithFormat:@"\r\n--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"Content-Disposition: form-data; name=\"status\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [myRequestData appendData:[@"Photomation Rocks\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
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
}

/*
-(IBAction)didPressPostImage:(id)sender
{
    
    NSString *url = @"http://api.twitpic.com/2/upload.json";
    
    NSMutableURLRequest *req = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    [req setValue:@"https://api.twitter.com/1/account/verify_credentials.json" forHTTPHeaderField:@"X-Auth-Service-Provider"];
    
    //gw
    oAuth = [ [ OAuth alloc] initWithConsumerKey:OBJECTIVE_FLICKR_SAMPLE_API_KEY andConsumerSecret:OBJECTIVE_FLICKR_SAMPLE_API_SHARED_SECRET ];
    oAuth.oauth_token = self.flickrRequest.context.OAuthToken;
    oAuth.oauth_token_secret = self.flickrRequest.context.OAuthTokenSecret;
    
    oAuth.oauth_token_authorized = YES;
    NSString *header = [oAuth oAuthHeaderForMethod:@"GET"
                                            andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                         andParams:nil];
    NSLog( @"%@", header);
    
    //gw
    
    [req setValue:[oAuth oAuthHeaderForMethod:@"GET"
                                       andUrl:@"https://api.twitter.com/1/account/verify_credentials.json"
                                    andParams:nil]
            forHTTPHeaderField:@"X-Verify-Credentials-Authorization"];
    
    NSData *imageData = UIImageJPEGRepresentation( self.imgview_template.image, 0.8);
    
    [req setHTTPMethod:@"POST"];
    
    // Image uploading and form construction technique with NSURLRequest: http://www.cocoanetics.com/2010/02/uploading-uiimages-to-twitpic/
    
    // Just some random text that will never occur in the body
    NSString *stringBoundary = @"0xKhTmLbOuNdArY---This_Is_ThE_BoUnDaRyy---pqo";
    
    // Header value
    NSString *headerBoundary = [NSString stringWithFormat:@"multipart/form-data; boundary=%@",
                                stringBoundary];
    
    // Set header
    [req addValue:headerBoundary forHTTPHeaderField:@"Content-Type"];
    
    NSMutableData *postBody = [NSMutableData data];
    
    // Twitpic API key
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"
                          //[NSString stringWithString:@"Content-Disposition: form-data; name=\"key\"\r\n\r\n"]
                          dataUsingEncoding:NSUTF8StringEncoding]];
    // Define this TWITPIC_API_KEY somewhere or replace with your own key inline right here.
    [postBody appendData:[  @"0ff365f69c73babb350c373e8a2d701c" //gw TWITPIC_API_KEY
                          dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // TwitPic API doc says that message is mandatory, but looks like
    // it's actually optional in practice as of July 2010. You may or may not send it, both work.
    
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[[NSString stringWithString:@"Content-Disposition: form-data; name=\"message\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[@"oh hai!!!" dataUsingEncoding:NSUTF8StringEncoding]];
     [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    
    // media part
    [postBody appendData:[[NSString stringWithFormat:@"--%@\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Disposition: form-data; name=\"media\"; filename=\"dummy.jpg\"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Type: image/jpeg\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    [postBody appendData:[@"Content-Transfer-Encoding: binary\r\n\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // add it to body
    [postBody appendData:imageData];
    [postBody appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
    
    // final boundary
    [postBody appendData:[[NSString stringWithFormat:@"--%@--\r\n", stringBoundary] dataUsingEncoding:NSUTF8StringEncoding]];
    
    [req setHTTPBody:postBody];
    
    NSHTTPURLResponse *response;
    NSError *error = nil;
    
    NSString *responseString = [[[NSString alloc] initWithData:[NSURLConnection sendSynchronousRequest:req returningResponse:&response error:&error] encoding:NSUTF8StringEncoding] autorelease];
    
    if (error) {
        NSLog(@"Error from NSURLConnection: %@", error);
    }
    NSLog(@"Got HTTP status code from TwitPic: %d", [response statusCode]);
    NSLog(@"Response string: %@", responseString);
    NSDictionary *twitpicResponse = [responseString JSONValue];
    if ( twitpicResponse==nil ) return;
    
    //gw textView.text = [NSString stringWithFormat:@"Posted image URL: %@", [twitpicResponse valueForKey:@"url"]];
    
}
*/

/*gw
- (NSString * ) _uploadImage:(UIImage *)image withStatus:(NSString *)status
                 accessToken:(OAToken*)_token requestType:(MGTwitterRequestType)requestType responseType:(MGTwitterResponseType)responseType
{
    NSURL *finalURL = [NSURL URLWithString:@"https://api.twitter.com/1.1/statuses/update_with_media.json"];
    if (!finalURL)
    {
        return nil;
    }
    
    OAMutableURLRequest *theRequest = [[[OAMutableURLRequest alloc] initWithURL:finalURL
                                                                       //gw consumer:self.consumer
                                                                       consumer:nil
                                                                          //gw token:_accessToken
                                        
                                                                          token:_token
                                                                          realm: nil
                                                              signatureProvider:nil] autorelease];
    NSData *imageData = UIImagePNGRepresentation(image);
    [theRequest setHTTPMethod:@"POST"];
    [theRequest setTimeoutInterval:120];
    [theRequest setHTTPShouldHandleCookies:NO];
    
    //gw
    // Set headers for client information, for tracking purposes at Twitter.
    //[theRequest setValue:_clientName    forHTTPHeaderField:@"X-Twitter-Client"];
    //[theRequest setValue:_clientVersion forHTTPHeaderField:@"X-Twitter-Client-Version"];
    //[theRequest setValue:_clientURL     forHTTPHeaderField:@"X-Twitter-Client-URL"];
    //gw
    
    NSString *boundary = @"--0246824681357ACXZabcxyz";
    NSString *contentType = [NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary];
    [theRequest setValue:contentType forHTTPHeaderField:@"content-type"];
    
    // NSMutableData *body = [NSMutableData dataWithLength:0];
    NSMutableData *body = [NSMutableData data];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    // status
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"status\"\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"%@",status] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    // media
    [body appendData:[[NSString stringWithFormat:@"--%@\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Disposition: form-data; name=\"media[]\"; filename=\"1.png\"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString stringWithFormat:@"Content-Type: application/octet-stream\r\n\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //[body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData  dataWithData:imageData]];
    [body appendData:[[NSString stringWithFormat:@"\r\n"] dataUsingEncoding:NSUTF8StringEncoding]];
    //
    [body appendData:[[NSString stringWithFormat:@"--%@--\r\n", boundary] dataUsingEncoding:NSUTF8StringEncoding]];    // --------------------------------------------------------------------------------
    // modificaiton from the base clase
    // our version "prepares" the oauth url request
    // --------------------------------------------------------------------------------
    [theRequest prepare];
    
    [theRequest setHTTPBody:body];
    
    NSLog(@"url is %@",theRequest.URL);
    // Create a connection using this request, with the default timeout and caching policy,
    // and appropriate Twitter request and response types for parsing and error reporting.
    MGTwitterHTTPURLConnection *connection;
    connection = [[MGTwitterHTTPURLConnection alloc] initWithRequest:theRequest
                                                            delegate:self
                                                         requestType:requestType
                                                        responseType:responseType];
    
    if (!connection) {
        return nil;
    } else {
        //[_connections setObject:connection forKey:[connection identifier]];
        [connection release];
    }
    
    return [connection identifier];
}
 */


- (void)authUpdate:(NSNotification *)notification
{
    if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length])
    {
        [ self rawTweetWithPic];
        [ self done ];
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
}


- (void)_startUpload:(UIImage *)image
{
    NSData *JPEGData = UIImageJPEGRepresentation(image, 1.0);
    
    self.flickrRequest.sessionInfo = kUploadImageStep;
    [self.flickrRequest uploadImageStream:[NSInputStream inputStreamWithData:JPEGData]
                        suggestedFilename:@"Snap and Run Demo" MIMEType:@"image/jpeg" arguments:[NSDictionary dictionaryWithObjectsAndKeys:@"0", @"is_public", nil]];
	
	[UIApplication sharedApplication].idleTimerDisabled = YES;
	
    //[self updateUserInterface:nil];
}

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
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ UIImage imageNamed:
            @"07a-Photomation-iPad-Enter-Twitter-Login-Horizontal.jpg" ];
        
        self.webview.frame = CGRectMake(46, 136, 931, 561);
        
        
        self.btn_cancel.frame = CGRectMake( 904, 713, 73, 44 );
        
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
