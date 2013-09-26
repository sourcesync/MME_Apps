//
//  FirstViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "SignupLoginViewController.h"

@interface SignupLoginViewController ()

@end

@implementation SignupLoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        //self.title = NSLocalizedString(@"First", @"First");
        //self.tabBarItem.image = [UIImage imageNamed:@"first"];
        
    
    }
    return self;
}
							
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.title = @"Photomation";
    self.navigationItem.title = @"Photomation";
    
    [ self.navigationController setNavigationBarHidden:YES ];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
}

- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations = UIInterfaceOrientationMaskPortrait;
    return orientations;
}


- (BOOL)shouldAutorotate
{
    return NO;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
        return YES;
    else
        return NO;
}

- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    
}

-(IBAction) btn_signup: (id) sender
{
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    
    [ AppDelegate ErrorMessage:@"Not Implemented" ];
    //[ app goto_signup];
}

-(IBAction) btn_login: (id) sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_login ];
}

@end
