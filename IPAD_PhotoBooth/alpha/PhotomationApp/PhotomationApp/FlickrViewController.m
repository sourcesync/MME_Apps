//
//  FlickrViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 6/16/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "FlickrViewController.h"

#import "AppDelegate.h"


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

@implementation FlickrViewController


static NSString *kFetchRequestTokenStep = @"kFetchRequestTokenStep";
//static NSString *kGetUserInfoStep = @"kGetUserInfoStep";
static NSString *kSetImagePropertiesStep = @"kSetImagePropertiesStep";
static NSString *kUploadImageStep = @"kUploadImageStep";

UIInterfaceOrientation current_orientation;

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

	
	[[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(authUpdate:) name:SnapAndRunShouldUpdateAuthInfoNotification object:nil];
}


- (void)viewDidUnload
{
    self.flickrRequest = nil;
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


#pragma general functions


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


#pragma mark - auth and api stuff


- (void)authUpdate:(NSNotification *)notification
{
    if ([[AppDelegate sharedDelegate].flickrContext.OAuthToken length])
    {
        [ self _flickrUpload:self.imgview_template.image];
    }
    else
    {
    }
}


- (void)authorizeAction
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
    
    //  check if user hit the no thanks button in the flickr app auth page...
    if ([URLString rangeOfString:@"http://m.flickr.com/#/home"].location != NSNotFound)
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
    
}


- (void)_flickrUpload:(UIImage *)image
{
    //  hide auth web view...
    self.webview.hidden = YES;
    
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
    
	if (inRequest.sessionInfo == kUploadImageStep)
    {
        self.webview.hidden = YES;
        
        NSLog(@"%@", inResponseDictionary);
        NSString *photoID = [[inResponseDictionary valueForKeyPath:@"photoid"] textContent];
        
        flickrRequest.sessionInfo = kSetImagePropertiesStep;
        [flickrRequest callAPIMethodWithPOST:@"flickr.photos.setMeta" arguments:[NSDictionary dictionaryWithObjectsAndKeys:photoID,
                        @"photo_id",
                        @"Photomation Rocks!",
                        @"title",
                        @"Uploaded from Photomation PhotoBooth",
                        @"description",
                        nil]];
	}
    else if (inRequest.sessionInfo == kSetImagePropertiesStep)
    {
		
		[UIApplication sharedApplication].idleTimerDisabled = NO;
     
        //  Image upload completed...
        [ self done ];
        
    }
    else // TODO: probably should not get here, err message ?
    {
        [ self done ];
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

#pragma ui actions

-(IBAction) cancelPressed:(id)sender
{
    [ self done];
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
                                 @"7c-Photomation-iPad-Enter-Flickr-Login-Screen-Vertical.jpg" ];
        
        self.webview.frame = CGRectMake(44, 216, 680, 711);
        
        self.btn_cancel.frame = CGRectMake( 651, 953, 73, 44 );
        
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imgview_bg.image = [ UIImage imageNamed:
                                 @"07c-Photomation-iPad-Enter-Flickr-Login-Horizontal.jpg" ];
        
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