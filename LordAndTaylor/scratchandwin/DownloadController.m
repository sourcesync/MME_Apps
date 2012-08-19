//
//  DownloadController.m
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "DownloadController.h"

#import "AppDelegate.h"

@interface DownloadController ()

@end

@implementation DownloadController

@synthesize canceled=_canceled;
@synthesize strurl=_strurl;
@synthesize winner=_winner;
@synthesize fake=_fake;

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
    
    self.fake = YES;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    self.canceled = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES  ]; 
    
}

- (void)downloadImage: (NSString *)strurl
{
    UIImage *image = nil;
    if ( !self.fake )
    {
        NSURL * url = [NSURL URLWithString:strurl];
        NSData * data = [NSData dataWithContentsOfURL:url];
        image = [UIImage imageWithData:data];
    }
    
    //  Determine if we use preloaded images or not...
    if (image)
    {
        if (self.canceled) return;
        
        AppDelegate *app = (AppDelegate *)
            [ [ UIApplication sharedApplication ] delegate ];
        [ app ShowTicket: image:self.winner ];
        
    }
    else
    {
        if (self.canceled) return;
        
        if (self.winner)
        {
            image = [ UIImage imageNamed:@"iphone-scratched-three-gold-rot.jpg"];
            if (!image)
            {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"Scratch&Win" 
                                      message:@"Invalid Image" 
                                        delegate:nil 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            AppDelegate *app = (AppDelegate *)
                [ [ UIApplication sharedApplication ] delegate ];
            [ app ShowTicket: image:self.winner ];
        }
        else 
        {
            image = [ UIImage 
                     imageNamed:@"iphone-scratched-white-gold-gold-rot.jpg"];
            if (!image)
            {
                UIAlertView *alert = [[UIAlertView alloc] 
                                      initWithTitle:@"Scratch&Win" 
                                            message:@"Invalid Image" 
                                                delegate:nil 
                                                      cancelButtonTitle:@"OK"
                                                      otherButtonTitles:nil];
                [alert show];
                [alert release];
            }
            AppDelegate *app = (AppDelegate *)
            [ [ UIApplication sharedApplication ] delegate ];
            [ app ShowTicket: image:self.winner ];
        }
    }
}   


-(void) show_ticket: (id)sender
{
    if (self.canceled) return;
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app ShowTicket: nil: self.winner];
}

- (void) viewDidAppear:(BOOL)animated
{
    [super viewDidLoad];
    
    if (self.fake )
    {
        [ self performSelector:@selector(downloadImage:) 
                    withObject:self afterDelay:3 ];
    }
    else 
    {
      
        [self performSelectorInBackground:@selector(downloadImage:) 
                               withObject:self.strurl];
    }
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}


-(IBAction) home:(id)sender
{
    self.canceled = YES;
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app Home ];
}


-(IBAction) my_coupons:(id)sender
{
    self.canceled = YES;
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app ShowMyCoupons ];
}

@end
