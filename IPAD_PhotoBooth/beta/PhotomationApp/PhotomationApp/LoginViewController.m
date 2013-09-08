//
//  SecondViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/11/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"
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


- (BOOL)shouldAutorotate
{
    return NO;
}


-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    self.nav.hidesBackButton = NO;
    
    self.activity.hidden = YES;
    [ self.activity stopAnimating];
    
    self.logging_in = NO;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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

-(void) next:(id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    
    //  Create the configuration objects here...
    app.config = [ [ Configuration alloc ] init ];
    app.cm = [ [ ContentManager alloc ] init:app.login_name ];
    
    //  Goto to cms/skin config screen...
    [ app goto_cms ];
}

- (IBAction) btn_submit
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    //[ app goto_takephoto ];
    
    if ( ( self.field_name.text == nil ) || 
        ( [ self.field_name.text compare:@"" ] == NSOrderedSame ) )
    {
        [ AppDelegate ErrorMessage:@"Invalid Login" ];
    }
    else if (! self.logging_in)
    {
        self.logging_in = YES;
        
        app.login_name =self.field_name.text;
        
        
        self.activity.hidden = NO;
        [self.activity startAnimating];
        
        [ self performSelector:@selector(next:) withObject:nil afterDelay:1];
    }
}

@end
