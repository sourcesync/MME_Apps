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

@interface FacebookViewController ()

@end

@implementation FacebookViewController

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
    // Do any additional setup after loading the view from its nib.c
        
    [self updateView];
    
    AppDelegate *appDelegate = (AppDelegate  *)[[UIApplication sharedApplication]delegate];
    
    if (!appDelegate.session.isOpen)
    {
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
        {
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
    }


    /*
    // Create Login View so that the app will be granted "status_update" permission.
    FBLoginView *loginview = [[FBLoginView alloc] init];
    
    loginview.frame = CGRectOffset(loginview.frame, 5, 5);
    loginview.delegate = self;
    
    [self.view addSubview:loginview];
    
    [loginview sizeToFit];
     */

    self.webview.delegate = self;

}


-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = app.fpath; 
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fname];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:fname ] autorelease];
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
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];        
        [ self processTemplate:test ];
    }
    
    //b363dc52a740dc1a76878db6df1f86fc
    
    //  load the login page !
    NSString *urlstr =
        @"https://www.facebook.com/dialog/oauth/?client_id=452798101456639&redirect_uri=http://photomation.mmeink.com/&state=mme&response_type=token&scope=publish_actions";
    
    NSURL *url = [ NSURL URLWithString:urlstr ];
    
    NSURLRequest *request = [ NSURLRequest requestWithURL:url ];
    
    
    // Flush all cached data
    [[NSURLCache sharedURLCache] removeAllCachedResponses];
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (cookie in [storage cookies]) {
        [storage deleteCookie:cookie];
    }
    [[NSUserDefaults standardUserDefaults] synchronize];
     
    
    [ self.webview loadRequest:request ];
}


// UIAlertView helper for post buttons
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




-(IBAction)donePressed:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ app settings_go_back ];
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


// Convenience method to perform some action that requires the "publish_actions" permissions.
- (void) performPublishAction:(void (^)(void)) action
{
    
    AppDelegate *appDelegate = (AppDelegate  *)[[UIApplication sharedApplication]delegate];
    
    // we defer request for permission to post to the moment of post, then we check for the permission
    //if ([FBSession.activeSession.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    if ([appDelegate.session.permissions indexOfObject:@"publish_actions"] == NSNotFound)
    {
        // if we don't already have the permission, then we request it now
        //[FBSession.activeSession requestNewPublishPermissions:@[@"publish_actions"]
        [appDelegate.session requestNewPublishPermissions:@[@"publish_actions"]
                                              defaultAudience:FBSessionDefaultAudienceFriends
                                            completionHandler:^(FBSession *session, NSError *error) {
                                                if (!error) {
                                                    action();
                                                }
                                                //For this example, ignore errors (such as if user cancels).
                                            }];
    }
    else
    {
        action();
    }
    
}

/*
-(void)loginThenPost {
    NSArray *permissions = [NSArray arrayWithObjects:@"publish_actions",
                            @"user_photos",
                            nil];
    
    [FBSession  sessionOpenWithPermissions:permissions
                        completionHandler:^(FBSession *session,
                                            FBSessionState status,
                                            NSError *error) {
                            if(error) {
                                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Problem connecting with Facebook" delegate:nil cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                                [alert show];
                            } else {
                                [self postPhoto];
                            }
                        }];
}

////////////////////////////
// Step 2. Post that photo to FB.
////////////////////////////

-(void)postPhoto {
    // We're going to assume you have a UIImage named image_ stored somewhere.
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    // First request uploads the photo.
    FBRequest *request1 = [FBRequest
                           requestForUploadPhoto:self.imgview_template.image];
    [connection addRequest:request1
         completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
         }
     }
            batchEntryName:@"photopost"
     ];
    
    // Second request retrieves photo information for just-created
    // photo so we can grab its source.
    FBRequest *request2 = [FBRequest
                           requestForGraphPath:@"{result=photopost:$.id}"];
    [connection addRequest:request2
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             if (!error && result) {
                 NSString *ID = [result objectForKey:@"id"];
                 [self postDataWithPhoto:ID];
             }
         }
     ];
    
    [connection start];
}

////////////////////////////
// Step 3. Post message with linked photo to the user's wall.
// We're going to post to the open graph 'user/feed' stream.
// Go here https://developers.facebook.com/docs/reference/api/ and do a page find for
// '/PROFILE_ID/feed' to get extra information about the parameters accepted in this call.
////////////////////////////

-(void)postDataWithPhoto:(NSString*)photoID {
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params setObject:@"I'm totally posting on my own wall!" forKey:@"message"];
    
    if(photoID) {
        [params setObject:photoID forKey:@"object_attachment"];
    }
    
    [FBRequest startForPostWithGraphPath:@"me/feed"
                             graphObject:[NSDictionary dictionaryWithDictionary:params]
                       completionHandler:
     ^(FBRequestConnection *connection, id result, NSError *error) {
         if (!error) {
             [[[UIAlertView alloc] initWithTitle:@"Result"
                                         message:@"Your update has been posted to Facebook!"
                                        delegate:self
                               cancelButtonTitle:@"Sweet!"
                               otherButtonTitles:nil] show];
         } else {
             [[[UIAlertView alloc] initWithTitle:@"Error"
                                         message:@"Yikes! Facebook had an error.  Please try again!"
                                        delegate:nil
                               cancelButtonTitle:@"Ok" 
                               otherButtonTitles:nil] show]; 
         }
     }
     ];
}
 */

-(IBAction)postPhotoClick3:(UIButton *)sender
{
    
    UIImage *img = self.imgview_template.image;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"message" forKey:@"message"];
    [params setObject:img forKey:@"picture"];
    FBRequest *request = [FBRequest requestWithGraphPath:@"me/photos" parameters:params HTTPMethod:@"POST"];
    request = request;
}

- (void)requestStarted:(ASIHTTPRequest *)request
{
}
- (void)request:(ASIHTTPRequest *)request didReceiveResponseHeaders:(NSDictionary *)responseHeaders
{
    
}
- (void)request:(ASIHTTPRequest *)request willRedirectToURL:(NSURL *)newURL
{
    
}
- (void)requestFinished:(ASIHTTPRequest *)request
{
    
}
- (void)requestFailed:(ASIHTTPRequest *)request
{
    
}
- (void)requestRedirected:(ASIHTTPRequest *)request
{
    
}

-(void) postNow: (NSString *)access_token
{
    /*
    NSString *likeString;
        NSString *filePath = nil;
        if (_imageView.image == [UIImage imageNamed:@"angelina.jpg"]) {
            filePath = [[NSBundle mainBundle] pathForResource:@"angelina" ofType:@"jpg"];
            likeString = @"babe";
        } else if (_imageView.image == [UIImage imageNamed:@"depp.jpg"]) {
            filePath = [[NSBundle mainBundle] pathForResource:@"depp" ofType:@"jpg"];
            likeString = @"dude";
        } else if (_imageView.image == [UIImage imageNamed:@"maltese.jpg"]) {
            filePath = [[NSBundle mainBundle] pathForResource:@"maltese" ofType:@"jpg"];
            likeString = @"puppy";
        }
        if (filePath == nil) return;
        
        NSString *adjectiveString;
        if (_segControl.selectedSegmentIndex == 0) {
            adjectiveString = @"cute";
        } else {
            adjectiveString = @"ugly";
        }
     */
        
        NSString *message = [NSString stringWithFormat:@"I think this is it!"];
    
        NSURL *url = [NSURL URLWithString:@"https://graph.facebook.com/me/photos"];
        ASIFormDataRequest *request = [ASIFormDataRequest requestWithURL:url];
    
    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"testphoto640x480" ofType:@"png"];
    
        [request addFile:filePath forKey:@"file"];
     
    
        [request setPostValue:message forKey:@"message"];
        [request setPostValue:access_token forKey:@"access_token"];
     
        
        [request setDidFinishSelector:@selector(sendToPhotosFinished:)];
        
        [request setDelegate:self];
        //[request startAsynchronous];
    
        [request   startSynchronous ];

        
    
}

-(void)sendToPhotosFinished
{
    
}

- (IBAction)postPhotoClick2:(UIButton *)sender
{
    NSString *tok = [[NSUserDefaults standardUserDefaults] stringForKey:FBTokenInformationTokenKey];
    [ self postNow:tok ];
    
    return;
    
    /*
    UIImage *img = self.imgview_template.image;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"your custom message" forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(img) forKey:@"picture"];
    
    self.btn_post.enabled = false;
    self.btn_loginlogout.enabled = false;
    self.btn_done.enabled = false;
    
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //[FBSession setActiveSession:appDelegate.session];
    
     //FBSessionTokenCachingStrategy *strategy =
    
    FBSessionManualTokenCachingStrategy *strategy =
        [[[FBSessionManualTokenCachingStrategy alloc] initWithUserDefaultTokenInformationKeyName:nil] autorelease];
    strategy.accessToken = [[NSUserDefaults standardUserDefaults] stringForKey:FBTokenInformationTokenKey];         // use your own UserDefaults key
    strategy.expirationDate = [[NSUserDefaults standardUserDefaults] objectForKey:FBTokenInformationExpirationDateKey]; // use your own UserDefaults key
    
    
    FBSession *session = [[[FBSession alloc] initWithAppID:@"452798101456639"                                    // use your own appId
                                               permissions:nil
                                           urlSchemeSuffix:nil
                                        tokenCacheStrategy:strategy]
                          autorelease];
    FBAccessTokenData *dat = [ session accessTokenData ];
    
    [FBSession setActiveSession:session];
    
    FBRequestConnection *conn = [ [ FBRequestConnection alloc ] init ];
    
    [FBRequestConnection startWithGraphPath:@"me/photos"
                                 parameters:params
                                 HTTPMethod:@"POST"
                          completionHandler:^(FBRequestConnection *connection,
                                              id result,
                                              NSError *error)
     {
         if (error)
         {
             //showing an alert for failure
             //[self alertWithTitle:@"Facebook" message:@"Unable to share the photo please try later."];
             [self showAlert:@"Photo Post" result:result error:error];
         }
         else
         {
             //showing an alert for success
             //[UIUtils alertWithTitle:@"Facebook" message:@"Shared the photo successfully"];
             [ AppDelegate InfoMessage:@"Photo Posted To FaceBook!" ];
         }
         
         
         self.btn_post.enabled = true;
         self.btn_loginlogout.enabled = true;
         self.btn_done.enabled = true;
         //_shareToFbBtn.enabled = YES;
     }];
     */
}



// Post Photo button handler
- (IBAction)postPhotoClick:(UIButton *)sender
{
    self.btn_post.enabled = false;
    self.btn_loginlogout.enabled = false;
    self.btn_done.enabled = false;
    
    [ self postPhotoClick2:sender ];
    
    //AppDelegate *appDelegate =
    //    (AppDelegate *)[[UIApplication sharedApplication]delegate];
    //[ AppDelegate InfoMessage:@"Image Posted"];
    
    return;
    
    // Just use the icon image from the application itself.  A real app would have a more
    // useful way to get an image.
    UIImage *img = self.imgview_template.image;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [FBSession setActiveSession:appDelegate.session];
    
    [self performPublishAction:^{
        
        [FBRequestConnection startForUploadPhoto:img
                               completionHandler:^(FBRequestConnection *connection, id result, NSError *error)
                                {
                                   //[self showAlert:@"Photo Post" result:result error:error];
                                   //self.buttonPostPhoto.enabled = YES;
                               }];
        
        //self.buttonPostPhoto.enabled = NO;
    }];
    
}


// FBSample logic
// main helper method to update the UI to reflect the current state of the session.
- (void)updateView
{
    // get the app delegate, so that we can reference the session property
    //AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    self.btn_post.hidden = NO;
    
    /*
    if (appDelegate.session.isOpen)
    {
        //[ AppDelegate ErrorMessage:@"isopen"];
        
        // valid account UI is shown whenever the session is open
        [self.btn_loginlogout setTitle:@"Log out" forState:UIControlStateNormal];
        
        //[self.textNoteOrLink setText:[NSString
        // stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
        // appDelegate.session.accessTokenData.accessToken]];
        
        self.btn_post.hidden = NO;
        self.btn_post.frame = self.btn_loginlogout.frame;
        self.btn_loginlogout.hidden = YES;
    }
    else
    {
        //[ AppDelegate ErrorMessage:@"is not open"];
        // login-needed account UI is shown whenever the session is closed
        
        [self.btn_loginlogout setTitle:@"Log in" forState:UIControlStateNormal];
        
        //[self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
        
        self.btn_post.hidden = YES;
        self.btn_post.frame = self.btn_loginlogout.frame;
        self.btn_loginlogout.hidden = NO;
    }
     */
}


// FBSample logic
// handler for button click, logs sessions in or out
- (IBAction)buttonClickHandler:(id)sender {
    // get the app delegate so that we can access the session property
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    // this button's job is to flip-flop the session from open to closed
    if (appDelegate.session.isOpen)
    {
        
        //[ AppDelegate ErrorMessage:@"close and clear"];
        
        // if a user logs out explicitly, we delete any cached token information, and next
        // time they run the applicaiton they will be presented with log in UX again; most
        // users will simply close the app or switch away, without logging out; this will
        // cause the implicit cached-token login to occur on next launch of the application
        [appDelegate.session closeAndClearTokenInformation];
        
    }
    else
    {
        if (appDelegate.session.state != FBSessionStateCreated)
        {
            // Create a new, logged out session.
            appDelegate.session = [[FBSession alloc] init];
        }
        
        //[ AppDelegate ErrorMessage:@"open with handler now"];
        
        // if the session isn't open, let's open it now and present the login UX to the user
        [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                         FBSessionState status,
                                                         NSError *error) {
            // and here we make sure to update our UX according to the new session state
            [self updateView];
        }];
    }
}


#pragma mark - FBLoginViewDelegate

- (void)loginViewShowingLoggedInUser:(FBLoginView *)loginView
{
    // first get the buttons set for login mode
    //self.buttonPostPhoto.enabled = YES;
    //self.buttonPostStatus.enabled = YES;
    //self.buttonPickFriends.enabled = YES;
    //self.buttonPickPlace.enabled = YES;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged On)" forState:self.buttonPostStatus.state];
}

- (void)loginViewFetchedUserInfo:(FBLoginView *)loginView
                            user:(id<FBGraphUser>)user {
    // here we use helper properties of FBGraphUser to dot-through to first_name and
    // id properties of the json response from the server; alternatively we could use
    // NSDictionary methods such as objectForKey to get values from the my json object
    //self.labelFirstName.text = [NSString stringWithFormat:@"Hello %@!", user.first_name];
    
    // setting the profileID property of the FBProfilePictureView instance
    // causes the control to fetch and display the profile picture for the user
    //self.profilePic.profileID = user.id;
    //self.loggedInUser = user;
}

- (void)loginViewShowingLoggedOutUser:(FBLoginView *)loginView {
    // test to see if we can use the share dialog built into the Facebook application
    FBShareDialogParams *p = [[FBShareDialogParams alloc] init];
    p.link = [NSURL URLWithString:@"http://developers.facebook.com/ios"];
#ifdef DEBUG
    [FBSettings enableBetaFeatures:FBBetaFeaturesShareDialog];
#endif
    
    //BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    //BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
    //self.buttonPostStatus.enabled = canShareFB || canShareiOS6;
    //self.buttonPostPhoto.enabled = NO;
    //self.buttonPickFriends.enabled = NO;
    //self.buttonPickPlace.enabled = NO;
    
    // "Post Status" available when logged on and potentially when logged off.  Differentiate in the label.
    //[self.buttonPostStatus setTitle:@"Post Status Update (Logged Off)" forState:self.buttonPostStatus.state];
    
    //self.profilePic.profileID = nil;
    //self.labelFirstName.text = nil;
    //self.loggedInUser = nil;
}

- (void)loginView:(FBLoginView *)loginView handleError:(NSError *)error {
    // see https://developers.facebook.com/docs/reference/api/errors/ for general guidance on error handling for Facebook API
    // our policy here is to let the login view handle errors, but to log the results
    NSLog(@"FBLoginView encountered an error=%@", error);
}

#pragma mark -



- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma oauth/sdk stuff


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:
    (NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    
    NSString *URLString = [ request.URL absoluteString ];
    NSLog(@"start-->%@", URLString);
    
    if ( (URLString!=nil) && ([URLString rangeOfString:@"access_token="].location != NSNotFound))
    {
        
        NSString *accessTokenBegin =
            [[URLString componentsSeparatedByString:@"="] objectAtIndex:1];
        
        NSString *accessToken =
            [[accessTokenBegin componentsSeparatedByString:@"&"] objectAtIndex:0];
        
        int idx = [ [URLString componentsSeparatedByString:@"="] count ] - 2;
        NSString *expirationBegin =
            [[URLString componentsSeparatedByString:@"="] objectAtIndex:idx];
        NSString *expiration =
            [[expirationBegin componentsSeparatedByString:@"&"] objectAtIndex:0];
        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:FBTokenInformationTokenKey];
        [defaults setObject:expiration forKey:FBTokenInformationExpirationDateKey];
        
        [defaults synchronize];
        //gw [self dismissModalViewControllerAnimated:YES];
    }
    
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    NSString *URLString = [[self.webview.request URL] absoluteString];
    
    NSLog(@"finish--> %@", URLString);
    if ([URLString rangeOfString:@"access_token="].location != NSNotFound) {
        NSString *accessToken = [[URLString componentsSeparatedByString:@"="] lastObject];
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        [defaults setObject:accessToken forKey:@"access_token"];
        [defaults synchronize];
        //gw [self dismissModalViewControllerAnimated:YES];
    }
}



#pragma rotation stuff


- (NSUInteger)supportedInterfaceOrientations
{
    
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //if ( app.lock_orientation )
    //{
    //    return app.take_pic_supported_orientations;
    //}
    //else
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
    //current_orientation = toInterfaceOrientation;
    float width = self.image_facebook.size.width;
    float height = self.image_facebook.size.height;
    
    if ( width > height )
    {
        self.imgview_template.frame =
            CGRectMake(170, 15, 640, 480);
    }
    else
    {
        self.imgview_template.frame =
            CGRectMake(170, 15, 480, 640);
    }
    
    /*
     if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
     {
     if ( self.image_email.size.width > self.image_email.size.height )
     {
     self.imageview_selected.frame =
     CGRectMake(0, 0, 640, 480);
     }
     }
     else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
     {
     if ( self.image_email.size.width > self.image_email.size.height )
     {
     self.imageview_selected.frame =
     CGRectMake(0, 0, 640, 480);
     }
     }
     */
    
    /*
     //  Depending on current orientation, change the mode for the imageview
     //  to aspect fill...
     if ( current_orientation == UIInterfaceOrientationPortrait )
     {
     if ( self.selected_img.size.width > self.selected_img.size.height )
     self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
     }
     else if ( current_orientation == UIInterfaceOrientationLandscapeLeft )
     {
     if ( self.selected_img.size.height > self.selected_img.size.width )
     self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
     }
     else if ( current_orientation == UIInterfaceOrientationLandscapeRight )
     {
     if ( self.selected_img.size.height > self.selected_img.size.width )
     self.img_taken.contentMode = UIViewContentModeScaleAspectFit;
     }
     else
     {
     self.img_taken.contentMode = UIViewContentModeScaleToFill;
     }
     */
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
