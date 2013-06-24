//
//  EmailViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/23/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "EmailViewController.h"

#import "AppDelegate.h"
#import "UIImage+Resize.h"
#import "UIImage+SubImage.h"


@implementation EmailViewController

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
    
    //  one time init for field...
    self.fld_email.delegate = self;
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  Get the file/image to display...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fullPath = app.current_photo_path;
    BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:fullPath];
    if (fileExists)
    {
        UIImage *image =
            [[[ UIImage alloc ] initWithContentsOfFile:fullPath ] autorelease];
        float width = image.size.width;
        float height = image.size.height;
        
        if ( width > height )
        {
            self.image_email =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:NO ];
        }
        else
        {
            self.image_email =  [ app processTemplateWatermark:image
                                                          raw1:nil
                                                          raw2:nil
                                                      vertical:YES ];
        }
        self.imageview_selected.image = self.image_email;
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        self.image_email = test;
        
        self.imageview_selected.image = test;
    }
    
    //  Initialize the text field...
    self.fld_email.text = @"";
    self.fld_email.frame =
    CGRectMake( self.fld_email.frame.origin.x, self.fld_email.frame.origin.y,
               self.fld_email.frame.size.width, 40 );
    
    //  Initialize the message label...
    self.lbl_message.hidden = YES;
    
    //  Initialize orientation and control positions...
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    //  This will popup the keyboard..
    [ self.fld_email becomeFirstResponder ];
    
    //  In experience mode, start the timer...
    [ self restartTimer ];

}

-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    
    [self.timer invalidate];
    self.timer = nil;
}

#pragma actions

-(void) restartTimer
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  we only do timer stuff in experience mode...
    if ( app.config.mode == 1) return;
    
    //  kill the current timer, if any...
    if (self.timer!=nil) [self.timer invalidate];
    self.timer = nil;
    
    //  start the new timer...
    int timeout = app.config.startview_timeout;
    self.timer = [NSTimer scheduledTimerWithTimeInterval:timeout
                                                  target:self
                                                selector:@selector(timerExpired:)
                                                userInfo:nil
                                                 repeats:NO];
}

-(void) timerExpired: (id)obj
{
    //  If got here, and we are the primary view
    //  then go back to start
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    if (app.window.rootViewController == self)
    {
        [ app goto_start ];
    }
}


-(IBAction) btn_fillemail:(id)sender
{
    self.fld_email.text = @"george@devnullenterprises.com";
}

+(BOOL) postimage:(NSString *)email image:(UIImage *)image
{
    //  Write out to file as png to preserve transparency...
    //NSData *imageData =
    //    UIImageJPEGRepresentation(self.image_email, 1.0);
    NSData *imageData =
        UIImageJPEGRepresentation(image, 1.0);
    if ( !imageData )
    {
        [ AppDelegate ErrorMessage:@"Cannot Get Image Data"];
        return false;
    }
    
    NSString *urlString = [NSString stringWithFormat:@"%@ipad_app_send.php", @"http://photomation.mmeink.com/"];
 
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] init];
    [request setURL:[NSURL URLWithString:urlString]];
    [request setHTTPMethod:@"POST"];
 
 
    NSString *boundary = //[NSString
        //stringWithString:
                          @"---------------------------14737809831466499882746641449"
        //]
        ;
    NSString *contentType = [NSString
                             stringWithFormat:
                             @"multipart/form-data; boundary=%@",boundary];
    
    [request addValue:contentType forHTTPHeaderField: @"Content-Type"];
 
    NSMutableData *body = [NSMutableData data];
 
    //  THE EVENT...
    [body appendData:[[NSString
                       stringWithFormat:@"\r\n--%@\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString
                       stringWithFormat:
                       @"Content-Disposition: form-data; name=\"event\"\r\n\r\n"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[//[NSString
                    //stringWithString:
                      @"Photomation"
                      //]
                      dataUsingEncoding:NSUTF8StringEncoding]];
 
    //  THE EMAIL...
    [body appendData:[[NSString
                       stringWithFormat:@"\r\n--%@\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString
                       stringWithFormat:
                       @"Content-Disposition: form-data; name=\"email\"\r\n\r\n"]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString
                       stringWithString:email]
                      dataUsingEncoding:NSUTF8StringEncoding]];
 
    //  Create a guid...
    NSString *uid = [ AppDelegate GetUUID ];
    
    //  THE FILE...
    [body appendData:[[NSString
                       stringWithFormat:@"\r\n--%@\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[[NSString
                       stringWithFormat:
                       @"Content-Disposition: form-data; name=\"photo\"; filename=\"%@.jpg\"\r\n",
                       uid]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[//[NSString
                       //stringWithString:
                       @"Content-Type: application/octet-stream\r\n\r\n"
                       //]
                      dataUsingEncoding:NSUTF8StringEncoding]];
    [body appendData:[NSData dataWithData:imageData]];
 
    [body appendData:[[NSString
                       stringWithFormat:@"\r\n--%@--\r\n",boundary]
                      dataUsingEncoding:NSUTF8StringEncoding]];
 
    [request setHTTPBody:body];
 
    NSData *returnData =
        [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:nil];
    
    NSString *returnString = [[NSString alloc] initWithData:returnData encoding:NSUTF8StringEncoding];
 
    NSLog( @"%@",returnString );
    
    //  look for valid return string...
    if ( [ returnString hasSuffix:@"1_3" ] )
    {
        return true;
    }
    else
    {
        return false;
    }
}
 

-(IBAction) btn_cancel:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app email_go_back ];
}


#pragma rotation stuff


- (NSUInteger)supportedInterfaceOrientations
{
    
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
    float width = self.image_email.size.width;
    float height = self.image_email.size.height;

    
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        self.imageview_bg.image =
            [ UIImage imageNamed:@"03-Photomation-iPad-Enter-Email-Screen-Vertical.jpg"];
        self.fld_email.frame = CGRectMake(0,681,682,44);
        self.btn_cancel.frame = CGRectMake(687, 681, 73, 44);
        
        self.imageview_selected.hidden = NO;
        if ( width > height )
        {
            self.imageview_selected.frame =
                CGRectMake(231, 223, 306, 409);
        }
        else
        {
            self.imageview_selected.frame =
                CGRectMake(231, 223, 306, 409);
        }
        
        self.lbl_message.frame =
            CGRectMake( 295, 401, 179, 21 );
        
        
        //  NOTE: THIS MIGHT BE YOUR PROBLEM !!
        self.imageview_selected.hidden = YES;
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        self.imageview_bg.image =
            [ UIImage imageNamed:@"03-Photomation-iPad-Entyer-Email-Horizontal.jpg"];
        self.fld_email.frame = CGRectMake(76,345,727,44);
        self.btn_cancel.frame = CGRectMake(811, 345, 73, 44);
        
        self.imageview_selected.hidden = NO;
        if ( width > height )
        {
            self.imageview_selected.frame =
                CGRectMake(439, 131, 146, 194);
        }
        else
        {
            self.imageview_selected.frame =
                CGRectMake(439, 131, 146, 194);
        }
        
        self.lbl_message.frame =
            CGRectMake( 423, 237, 179, 21 );
        
        
        //  NOTE: THIS MIGHT BE YOUR PROBLEM !!
        self.imageview_selected.hidden = YES;
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

#pragma text field stuff

- (void) doIt
{
    AppDelegate *app =
    (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *email = self.fld_email.text;
    
    //  In experience mode, we stash the email for sending later...
    if ( app.config.mode==1)
    {
        app.current_email = email;
        [ app goto_takephoto ];
    }
    else // In app/manual mode, send now...
    {

        if ( ![ EmailViewController postimage:email  image:self.image_email ] )
        {
            [ AppDelegate InfoMessage:@"Error Sending Email"];
        }
        else
        {
            [ app email_go_back ];
        }
        
        self.btn_cancel.enabled = YES;
    }
    
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    //  restart the timer...
    [ self restartTimer ];
    
    //  get the email...
    NSString *email = self.fld_email.text;
    if ([ email rangeOfString:@"@"].location == NSNotFound)
    {
        [ AppDelegate ErrorMessage:@"Invalid email address" ];
        return NO;
    }
    else
    {
        AppDelegate *app =
        (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        if ( app.config.mode==0) // manual mode, do some ui stuff...
        {
            self.imageview_selected.hidden = YES;
            self.lbl_message.hidden = NO;
            self.lbl_message.text = @"Sending...";
        }
        
        [ self performSelector:@selector( doIt ) withObject:self afterDelay:0.01];
        
        self.btn_cancel.enabled = NO;
                
        return YES;
    }
}

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    //  Restart the timer...
    [ self restartTimer ];
    
    NSLog( @"did begin editing");
}

-(BOOL) textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    //  Restart the timer...
    [ self restartTimer ];
    
    return YES;
}

/*
UIToolbar *_inputAccessoryView;
UITextView *_myTextView;

-(void) textFieldDidBeginEditing:(UITextField *)textField
{
    [self createInputAccessoryView];
    [textField setInputAccessoryView: _inputAccessoryView];
    //_myTextView = textView;
}


-(void)createInputAccessoryView {
    
    _inputAccessoryView = [[UIToolbar alloc] init];
    _inputAccessoryView.barStyle = UIBarStyleBlackOpaque;
    [_inputAccessoryView sizeToFit];
    
    _inputAccessoryView.frame = CGRectMake(0, 200, 0, 100 );
    //_inputAccessoryView.frame = CGRectMake(0,_collageView.frame.size.height - 44, _collageView.frame.size.width, 44);
    

    UIBarButtonItem *fontItem = [[UIBarButtonItem alloc] initWithTitle:@"Font"
                                                                 style:UIBarButtonItemStyleBordered
                                                                target:self action:@selector(changeFont:)];
    UIBarButtonItem *removeItem = [[UIBarButtonItem alloc] initWithTitle:@"Remove"
                                                                   style:UIBarButtonItemStyleBordered
                                                                  target:self action:@selector(removeTextView:)];
    //Use this to put space in between your toolbox buttons
    UIBarButtonItem *flexItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace
                                                                              target:nil
                                                                              action:nil];
    UIBarButtonItem *doneItem = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                                 style:UIBarButtonItemStyleDone
                                                                target:self action:@selector(dismissKeyBoard:)];
     NSArray *items = [NSArray arrayWithObjects:fontItem,removeItem,flexItem,doneItem, nil];
    
    
    [_inputAccessoryView setItems:items animated:YES];
    
    //[ self.fld_email addSubview:_inputAccessoryView];
    //[_myTextView addSubview:_inputAccessoryView];
}
 */


@end
