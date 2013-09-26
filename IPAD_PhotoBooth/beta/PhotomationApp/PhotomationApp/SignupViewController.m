//
//  SecondViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController


- (void)didReceiveMemoryWarning
{
    [ super didReceiveMemoryWarning ];
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
}


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
    
    self.nav.leftBarButtonItem = [ [ [ UIBarButtonItem alloc] initWithTitle:@"back"
                                                                      style:UIBarButtonSystemItemDone target:self action:
                                                                    @selector(nav_back)] autorelease ];
    
    self.tv.delegate = self;
    self.tv.dataSource = self;
    [ self.tv reloadData ];
    
}


- (BOOL)shouldAutorotate
{
    return NO;
}


-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    self.nav.hidesBackButton = NO;
}


-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
        return YES;
    else
        return NO;
}


- (int) tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 3;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    
    if (row==0)
    {
        return self.cell_name;
    }
    else if (row==1)
    {
        return self.cell_pass;
    }
    else if (row==2)
    {
        return self.cell_cpass;
    }
    else
    {
        return nil;
    }
}



- (IBAction) nav_back
{
    [ self.navigationController popToRootViewControllerAnimated:YES ];
}


- (IBAction) btn_submit
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_takephoto ];
}


@end
