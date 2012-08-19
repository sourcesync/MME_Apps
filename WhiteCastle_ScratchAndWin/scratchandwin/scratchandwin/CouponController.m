//
//  CouponController.m
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "CouponController.h"

#import "AppDelegate.h"

@interface CouponController ()

@end

@implementation CouponController

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
    // Do any additional setup after loading the view from its nib.
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES  ]; 
    
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


-(IBAction) go_back:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app GoBack ];
}


-(IBAction) home:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app Home ];
}


-(IBAction) my_coupons:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app ShowMyCoupons ];
}



@end
