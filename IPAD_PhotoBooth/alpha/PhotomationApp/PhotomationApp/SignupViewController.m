//
//  SecondViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "SignupViewController.h"

@interface SignupViewController ()

@end

@implementation SignupViewController

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

-(void) viewWillAppear:(BOOL)animated
{
    
    
    self.nav.hidesBackButton = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

@end
