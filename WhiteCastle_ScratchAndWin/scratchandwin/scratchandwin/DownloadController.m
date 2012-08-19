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
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    self.canceled = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES  ]; 
    
}

- (void)downloadImage: (NSString *)strurl
{
    NSURL * url = [NSURL URLWithString:strurl];
    NSData * data = [NSData dataWithContentsOfURL:url];
    UIImage * image = [UIImage imageWithData:data];
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
            image = [ UIImage imageNamed:@"iphone-scratchticket-scratched-cleaned.png"];
            AppDelegate *app = (AppDelegate *)
                [ [ UIApplication sharedApplication ] delegate ];
            [ app ShowTicket: image:self.winner ];
        }
        else 
        {
            image = [ UIImage imageNamed:@"2000.jpg"];
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
    
    [self performSelectorInBackground:@selector(downloadImage:) withObject:self.strurl];
    
    //[ self performSelector:@selector(show_ticket:) withObject:self afterDelay:3 ];
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
