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

/*
@interface EmailViewController ()

@end
*/

@implementation EmailViewController

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
    // Do any additional setup after loading the view from its nib.
    
    //self.fld_email.delegate = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    self.fld_email.frame =
        CGRectMake( self.fld_email.frame.origin.x, self.fld_email.frame.origin.y,
                   self.fld_email.frame.size.width, 40 );
    //NSString *galleryPath = [ AppDelegate getGalleryDir ];
    //NSString *fullPath = [ NSString stringWithFormat:@"%@/%@", galleryPath, self.selected_fname ];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    NSString *fullPath = app.fpath;
    
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
        
        //float ewidth = self.image_email.size.width;
        //float eheight = self.image_email.size.height;
        
        self.imageview_selected.image = self.image_email;
    }
    else
    {
        UIImage *test = [ UIImage imageNamed:@"testphoto640x480.png" ];
        self.imageview_selected.image = test;
    }
    
    self.fld_email.text = @"";
}

-(void)viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation  duration:0];
    
    [ self.fld_email becomeFirstResponder ];
}


-(IBAction) btn_fillemail:(id)sender
{
    self.fld_email.text = @"george@devnullenterprises.com";
}

-(BOOL) postimage:(NSString *)email
{
    
    
    //  Write out to file as png to preserve transparency...
    NSData *imageData =
        UIImageJPEGRepresentation(self.image_email, 1.0);
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
 

/*
-(IBAction) btn_send:(id)sender
{
    NSString *email = self.fld_email.text;
    if ([ email rangeOfString:@"@"].location == NSNotFound)
    {
        [ AppDelegate ErrorMessage:@"Invalid email address" ];
    }
    else
    {
        self.btn_cancel.enabled = NO;
    
        if ( ![ self postimage: email ])
        {
            [ AppDelegate InfoMessage:@"Email Sent"];
        
        self.btn_cancel.enabled = YES;
       
    }
}
 */


/*
-(IBAction)donePressed:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    [ app email_go_back ];
}
 */
 

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
    }
     
    
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

#pragma text field stuff

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    NSString *email = self.fld_email.text;
    if ([ email rangeOfString:@"@"].location == NSNotFound)
    {
        [ AppDelegate ErrorMessage:@"Invalid email address" ];
        return NO;
    }
    else
    {
        self.btn_cancel.enabled = NO;
        
        if ( ![ self postimage: email ] )
        {
            [ AppDelegate InfoMessage:@"Error Sending Email"];
        }
        else
        {
            AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
            [ app email_go_back ];
        }
        
        self.btn_cancel.enabled = YES;
        
        return YES;
    }
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
