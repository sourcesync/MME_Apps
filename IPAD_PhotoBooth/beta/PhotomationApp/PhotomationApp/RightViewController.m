//
//  RightViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/2/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "RightViewController.h"

#import "AppDelegate.h"

@interface RightViewController ()

@end

@implementation RightViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    [ AppDelegate ErrorMessage:@"VC Memory Low" ];
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
/*
#pragma mark -
#pragma mark UISplitViewControllerDelegate implementation
- (void)splitViewController:(UISplitViewController*)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem
       forPopoverController:(UIPopoverController*)pc
{
    //self.navigationItem.leftBarButtonItem = nil;
    [barButtonItem setTitle:@"Your 'popover button' title"];
    self.navigationItem.leftBarButtonItem = barButtonItem;
}


- (void)splitViewController:(UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationItem.leftBarButtonItem = nil;
    //[barButtonItem setTitle:@"Your 'popover button' title"];
    //self.navigationItem.leftBarButtonItem = barButtonItem;
}
 */

-(void) changeView
{
    [ AppDelegate InfoMessage:@"change"];
}


/*
#pragma mark -
#pragma mark UISplitViewControllerDelegate implementation
- (void)splitViewController:(UISplitViewController*)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem
       forPopoverController:(UIPopoverController*)pc
{
    self.popover = pc;
    
    //[barButtonItem setTitle:@"Settings"];
    //self.navigationItem.leftBarButtonItem = barButtonItem;
    //aViewController.navigationController.navigationBarHidden = NO;
    //aViewController.navigationItem.leftBarButtonItem = barButtonItem;
    
    UINavigationController *detail_nav =
    (UINavigationController *)[ self.splitViewController.viewControllers
                               objectAtIndex:1];
    [barButtonItem setTitle:@"Settings"];
    //ChromaViewController *detail =
    //(ChromaViewController *)[ detail_nav.viewControllers objectAtIndex: 0];
    //detail.navigationController.navigationBarHidden = NO;
    //detail.navigationItem.title = @"Chroma Key";
    //detail.navigationItem.leftBarButtonItem = barButtonItem;
    //detail.popover = pc;
    
    
}


- (void)splitViewController:(UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    //self.navigationItem.leftBarButtonItem = nil;
    //aViewController.navigationController.navigationBarHidden = NO;
    //aViewController.navigationItem.leftBarButtonItem = nil;
    
    self.popover = nil;
    UINavigationController *detail_nav =
    (UINavigationController *)[ self.splitViewController.viewControllers
                               objectAtIndex:1];
    //ChromaViewController *detail =
    //(ChromaViewController *)[ detail_nav.viewControllers objectAtIndex: 0];
    //detail.navigationController.navigationBarHidden = NO;
    //detail.navigationItem.title = @"Chroma Key";
    //detail.navigationItem.leftBarButtonItem = nil;
    //detail.popover = nil;
}
 */



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
