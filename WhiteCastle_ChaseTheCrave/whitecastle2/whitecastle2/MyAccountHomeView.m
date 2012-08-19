//
//  MyAccountHomeView.m
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "MyAccountHomeView.h"

#import "AppDelegate.h"

@interface MyAccountHomeView ()

@end

@implementation MyAccountHomeView


- (IBAction) go_accountstart: (id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_myaccountstart:obj ];

}

- (IBAction) go_accounttruck: (id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_trucksettingsview:obj ];
    
    //[ app goto_trucksettings ];
    //[ app goto_trucksettings ];
}

- (IBAction) go_accountrestaurant: (id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_restaurantsettingsview:obj ];
    
    //[ app got
    //[ app go_accountrestaurant ];
}


-(IBAction) go_home:(id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_home:obj ];
    //[ app pop ];
}


-(IBAction)go_rewards:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_rewards:nil ];
}


-(IBAction)go_settings:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_myaccounthome: sender ];
}


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

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
