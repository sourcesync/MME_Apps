//
//  PrintSettingsViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 10/20/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "PrintSettingsViewController.h"

#import "AppDelegate.h"

@interface PrintSettingsViewController ()

@end

@implementation PrintSettingsViewController

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
    
    [ self.fld_url addTarget:self action:@selector(textFieldDidChange:) forControlEvents:UIControlEventEditingChanged];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)viewWillAppear:(BOOL)animated
{
    [[ UIApplication sharedApplication ] setStatusBarHidden:YES ];
    
    self.toolbar.bounds = CGRectMake(0, 0,
                                     self.toolbar.frame.size.width,
                                     self.toolbar.frame.size.height);
    if ( _navigationPaneBarButtonItem )
    {
        [self.toolbar setItems:[NSArray arrayWithObjects:
                                _navigationPaneBarButtonItem,
                                self.flex,
                                self.doneButton, nil] animated:NO];
    }
    
    UIDeviceOrientation or = [ [UIDevice currentDevice ] orientation ];
    if ( (UIDeviceOrientationIsPortrait(or))|| (!self.toolbar.hidden))
        [ self.lbl_title setText:_navigationTitle];
    else
        [ self.lbl_title setText:@""];
    
}

-(void) textFieldDidChange: (id)sender
{
    NSString *txt = self.fld_url.text;
    
    AppDelegate *app = (AppDelegate *) [ [ UIApplication sharedApplication] delegate];
    app.config.printURL = txt;
    [[NSUserDefaults standardUserDefaults] setObject:txt forKey:@"print_url"];
    
}


-(void) changeView:(int)i
{
    //  pop the url field...
    NSString *url =[[NSUserDefaults standardUserDefaults]  stringForKey:@"print_url" ];
    if ( url ) self.fld_url.text = url;
    
    //[ AppDelegate InfoMessage:@"change"];
}

#pragma mark -
#pragma mark SubstitutableDetailViewController

// -------------------------------------------------------------------------------
//	setNavigationPaneBarButtonItem:
//  Custom implementation for the navigationPaneBarButtonItem setter.
//  In addition to updating the _navigationPaneBarButtonItem ivar, it
//  reconfigures the toolbar to either show or hide the
//  navigationPaneBarButtonItem.
// -------------------------------------------------------------------------------
- (void)setNavigationPaneBarButtonItem:(UIBarButtonItem *)navigationPaneBarButtonItem
{
    //if (navigationPaneBarButtonItem==nil)
    //    self.lbl_title.text = ;
    
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        
        
        [_navigationPaneBarButtonItem release];
        _navigationPaneBarButtonItem = [navigationPaneBarButtonItem retain];
        
        //int width = _navigationPaneBarButtonItem.width;
        //NSString *title = _navigationPaneBarButtonItem.title;
        //[ _navigationPaneBarButtonItem setWidth:100.0];
        
        self.toolbar.bounds = CGRectMake(0, 0,
                                         self.toolbar.frame.size.width,
                                         self.toolbar.frame.size.height);
        
        if (navigationPaneBarButtonItem)
            [self.toolbar setItems:[NSArray arrayWithObjects:
                                    _navigationPaneBarButtonItem,
                                    self.flex,
                                    self.doneButton, nil] animated:NO];
        else
            [self.toolbar setItems:nil animated:NO];
        
    }
    
    UIDeviceOrientation or = [ [UIDevice currentDevice ] orientation ];
    if (UIDeviceOrientationIsPortrait(or))
        [ self.lbl_title setText:_navigationTitle];
    else
        [ self.lbl_title setText:@""];
    
}

- (void)setNavigationTitle:(NSString *)navigationTitle
{
    _navigationTitle = navigationTitle;
    
    
    
    UIDeviceOrientation or = [ [UIDevice currentDevice ] orientation ];
    if ((UIDeviceOrientationIsPortrait(or)) || (!self.toolbar.hidden))
        [ self.lbl_title setText:_navigationTitle];
    else
        [ self.lbl_title setText:@""];
    
}


-(IBAction) btn_action_launch: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app settings_done ];
    /*
     AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
     ContentManager *cm = app.cm;
     
     if ( [cm is_syncing] )
     {
     [AppDelegate ErrorMessage:@"Please wait.  Content is syncing."];
     }
     else if ( [ cm is_complete] )
     {
     AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
     
     Configuration *cf = app.config;
     if (cf.mode==1) // experience
     [ app goto_start ];
     else
     [ app goto_takephoto ];
     }
     else
     {
     [AppDelegate ErrorMessage:@"Content is not complete.  Please sync."];
     }
     */
}





@end
