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


- (void) ContentStatusChanged
{
    
}

- (void) ContentConfigChanged
{
    
}

- (void) ConfigDownloadFailed
{
    //  Adjust ui
    self.activity.hidden = YES;
    [self.activity stopAnimating];
    self.btn_login.enabled = YES;
    self.logging_in = NO;
    
    [ AppDelegate ErrorMessage:@"Login Failed"];
    //  Goto to cms/skin config screen...
    //AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    //[ app goto_cms ];
}



- (void) ConfigDownloadSucceeded
{
    //  Adjust ui
    self.activity.hidden = YES;
    [self.activity stopAnimating];
    self.btn_login.enabled = YES;
    self.logging_in = NO;
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    [ app goto_cms ];
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
    
    //
    //  Create the configuration objects here...
    //
    if ( app.config == nil )
    {
        app.config = [ [ Configuration alloc ] init ];
        app.cm = [ [ ContentManager alloc ] init:app.login_name ];
        app.cm.cmdel = self;
    }
    
    if ( ! [ app.cm config_sync: NO] )
    {
        //  Adjust ui
        self.activity.hidden = YES;
        [self.activity stopAnimating];
        self.btn_login.enabled = YES;
        self.logging_in = NO;
        
        [ AppDelegate ErrorMessage:@"Problem Connecting To Server" ];
    }
    
}

- (IBAction) btn_submit
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate ];
    //[ app goto_takephoto ];
    
    if ( ( self.field_name.text == nil ) || 
        ( [ self.field_name.text compare:@"" ] == NSOrderedSame ) )
    {
        [ AppDelegate ErrorMessage:@"Invalid Login Name" ];
    }
    else if (! self.logging_in)
    {
        self.logging_in = YES;
        
        //  Set the login name globally...
        app.login_name =self.field_name.text;
        
        //  Adjust ui
        self.activity.hidden = NO;
        [self.activity startAnimating];
        self.btn_login.enabled = NO;
            
        [ self performSelector:@selector(next:) withObject:nil afterDelay:1];
        
    }
}

@end
