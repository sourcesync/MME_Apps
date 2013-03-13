//
//  SecondViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "LoginViewController.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

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
    return 2;
}

- (UITableViewCell *) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    
    if (row==0)
    {
        CGRect frame = self.cell_name.frame;
        frame.origin.x  += 20;
        self.cell_name.frame = frame;
        return self.cell_name;
    }
    else if (row==1)
    {
        return self.cell_pass;
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
