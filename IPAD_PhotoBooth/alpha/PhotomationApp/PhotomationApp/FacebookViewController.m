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
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fname = app.fname; //[ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",app.selected_id];
   
    
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fname];
    if (fileExists)
    {
        UIImage *image = [[[ UIImage alloc ] initWithContentsOfFile:fname ] autorelease];
        //self.imgview_selected.image = image;
        
        [ self processTemplate:image ];
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        //self.imgview_selected.image = test;
        
        [ self processTemplate:test ];
    }
    //[ self updateView];
    /*
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    
    if (!appDelegate.session.isOpen)
    {
        
        [ AppDelegate ErrorMessage:@"vwa is not Open"];
        //[ AppDelegate ErrorMessage:@"vwa isOpen"];
        
        // create a fresh session object
        appDelegate.session = [[FBSession alloc] init];
        
        // if we don't have a cached token, a call to open here would cause UX for login to
        // occur; we don't want that to happen unless the user clicks the login button, and so
        // we check here to make sure we have a token before calling open
        if (appDelegate.session.state == FBSessionStateCreatedTokenLoaded)
        {
            [ AppDelegate ErrorMessage:@"tokenloaded"];
            
            // even though we had a cached token, we need to login to make the session usable
            [appDelegate.session openWithCompletionHandler:^(FBSession *session,
                                                             FBSessionState status,
                                                             NSError *error) {
                // we recurse here, in order to update buttons and labels
                [self updateView];
            }];
        }
        else
        {
            [ AppDelegate ErrorMessage:@"!tokenloaded"];
            
            [self.btn_loginlogout setTitle:@"Log out" forState:UIControlStateNormal];
        }
    }
    else
    {
        [ AppDelegate ErrorMessage:@"vwa isOpen"];
        
        [self.btn_loginlogout setTitle:@"Log out" forState:UIControlStateNormal];
    }
     */
    
    //[ self updateView];
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
}

- (IBAction)postPhotoClick2:(UIButton *)sender
{
    UIImage *img = self.imgview_template.image;
    
    NSMutableDictionary* params = [[NSMutableDictionary alloc] init];
    [params setObject:@"your custom message" forKey:@"message"];
    [params setObject:UIImagePNGRepresentation(img) forKey:@"picture"];
    
    self.btn_post.enabled = false;
    self.btn_loginlogout.enabled = false;
    self.btn_done.enabled = false;
    
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    [FBSession setActiveSession:appDelegate.session];
    
    
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
         }
         
         
         self.btn_post.enabled = true;
         self.btn_loginlogout.enabled = true;
         self.btn_done.enabled = true;
         //_shareToFbBtn.enabled = YES;
     }];
}



// Post Photo button handler
- (IBAction)postPhotoClick:(UIButton *)sender
{
    [ self postPhotoClick2:sender ];
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
- (void)updateView {
    // get the app delegate, so that we can reference the session property
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication]delegate];
    if (appDelegate.session.isOpen)
    {
        
        //[ AppDelegate ErrorMessage:@"isopen"];
        
        // valid account UI is shown whenever the session is open
        [self.btn_loginlogout setTitle:@"Log out" forState:UIControlStateNormal];
        
        //[self.textNoteOrLink setText:[NSString
            //stringWithFormat:@"https://graph.facebook.com/me/friends?access_token=%@",
                //                      appDelegate.session.accessTokenData.accessToken]];
        self.btn_post.hidden = NO;
        
    }
    else
    {
        
        //[ AppDelegate ErrorMessage:@"is not open"];
        
        // login-needed account UI is shown whenever the session is closed
        [self.btn_loginlogout setTitle:@"Log in" forState:UIControlStateNormal];
        
        //[self.textNoteOrLink setText:@"Login to create a link to fetch account data"];
        
        self.btn_post.hidden = YES;
    }
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
    BOOL canShareFB = [FBDialogs canPresentShareDialogWithParams:p];
    BOOL canShareiOS6 = [FBDialogs canPresentOSIntegratedShareDialogWithSession:nil];
    
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

@end
