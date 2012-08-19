//
//  RewardsView.m
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RewardsView.h"

#import "AppDelegate.h"

@interface RewardsView ()

@end

@implementation RewardsView


-(void) go_home:(id)obj
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



-(IBAction)go_signup:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_signup:nil ];
}


-(IBAction)go_settings:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_myaccounthome: sender ];
}


- (void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    [ [ UIApplication sharedApplication ] setStatusBarHidden: YES ];
    
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
