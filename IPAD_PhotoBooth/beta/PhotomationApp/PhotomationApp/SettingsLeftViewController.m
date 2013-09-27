//
//  SettingsLeftViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 4/1/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"
#import "SettingsLeftViewController.h"
#import "ChromaViewController.h"
#import "RightViewController.h"

#import "SubstitutableDetailViewController.h"

@interface SettingsLeftViewController ()

@end

@implementation SettingsLeftViewController


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    // Uncomment the following line to preserve selection between presentations.
    self.clearsSelectionOnViewWillAppear = NO;
 
    NSIndexPath *path = [ NSIndexPath indexPathForItem:0 inSection:0];
    [ self.tableView selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
 
    //self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Settings";
    
    //self.navigationItem.leftBarButtonItem = barButtonItem;
    self.tv.delegate = self;
    self.tv.dataSource = self;
    self.tv.allowsSelection = YES;
    self.tv.userInteractionEnabled = YES;
    
    self.selected = nil;
    self.current_page = -1;
}

- (void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    
    //self.navigationController.navigationBarHidden = NO;
    //self.navigationItem.title = @"Settings";
    
    //if (self.selected == nil ) [ self select_chroma ];
    
   
}


- (void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //if (! self.initialized)
    {
        //self.initialized = YES;
    
        
    }
    
}

-(void) reset
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    UIViewController<SubstitutableDetailViewController> * vc =
    (UIViewController<SubstitutableDetailViewController> *)
    app.cms_view;
    [ self setRight:vc title:@""];
    
    NSIndexPath *path = [ NSIndexPath indexPathForItem:0 inSection:0];
    [self.tv selectRowAtIndexPath:path animated:NO scrollPosition:UITableViewScrollPositionTop];
    /*
    self.cell_chroma.selected = NO;
    self.cell_config.selected = YES;
    self.cell_done.selected = NO;
    self.cell_offline.selected = NO;
    self.cell_photobooth.selected = NO;
    self.cell_printing.selected = NO;
     */
    
    self.initialized = YES;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 6;
}

-(void) changeView: (int)i
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    RightViewController *right =
        (RightViewController *)app.settings_right_view;
    [ right changeView];
}

 
-(void) setRight: (UIViewController<SubstitutableDetailViewController> *)vc title:(NSString *)title
{
    self.detailViewController.navigationPaneBarButtonItem = nil;
    
    //vc.navigationPaneBarButtonItem = self.navigationPaneButtonItem;
    self.detailViewController = vc;
    
    self.detailViewController.navigationPaneBarButtonItem = self.navigationPaneButtonItem;
    self.detailViewController.navigationTitle = title;
    
    // Update the split view controller's view controllers array.
    // This causes the new detail view controller to be displayed.
    UIViewController *navigationViewController =
        [self.splitViewController.viewControllers objectAtIndex:0];
    NSArray *viewControllers =
        [[NSArray alloc] initWithObjects:navigationViewController, _detailViewController, nil];
    self.splitViewController.viewControllers = viewControllers;
    [viewControllers release];
    
    // Dismiss the navigation popover if one was present.  This will
    // only occur if the device is in portrait.
    if (self.navigationPopoverController)
    {
        [self.navigationPopoverController dismissPopoverAnimated:YES];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    
    
    /*
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier] autorelease];
    }
     */
    
    int row = [ indexPath row ];
    if ( row == 0 )
    {
        //self.cell_sharing.userInteractionEnabled = YES;
        //return self.cell_chroma;
        self.cell_config.userInteractionEnabled = YES;
        return self.cell_config;
    }
    else if ( row == 1 )
    {
        self.cell_sharing.userInteractionEnabled = YES;
        return self.cell_sharing;
    }
    else if ( row == 2 )
    {
        self.cell_printing.userInteractionEnabled = YES;
        return self.cell_printing;
    }
    else if ( row == 3 )
    {
        self.cell_offline.userInteractionEnabled = YES;
        return self.cell_offline;
    }
    else if ( row == 4 )
    {
        self.cell_photobooth.userInteractionEnabled = YES;
        if ( app.config.mode == 0 )
        {
            self.lbl_photobooth_value.text = @"Manual";
            
        }
        else
        {
            self.lbl_photobooth_value.text = @"Experience";
        }
        return self.cell_photobooth;
    }
    else if ( row == 5 )
    {
        self.cell_done.userInteractionEnabled = YES;
        return self.cell_done;
    }
    else
    {
        return nil;
    }
    
}

/*
-(void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([indexPath row] == 0)
    {
        if ( self.selected == nil )
        {
            //[self
             //performSelectorOnMainThread:@selector(select_chroma) withObject:self waitUntilDone:YES];
        }
    }
}
 */

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }   
    else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

-(IBAction) togglePhotoBooth:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    if ( app.config.mode == 1 )
    {
        app.config.mode = 0;
        self.lbl_photobooth_value.text = @"Manual";
        
    }
    else
    {
        app.config.mode = 1;
        self.lbl_photobooth_value.text = @"Experience";
    }
    
    //  We need to do some recalculation...
    [ app.config ResetParms ];
    
    NSString *str = [ NSString stringWithFormat:@"%d", app.config.mode];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"mode"];
}


-(IBAction) toggleSharing:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication] delegate];
    if ( app.config.sharing)
    {
        app.config.sharing = NO;
        self.lbl_social_value.text = @"Off";
    }
    else
    {
        app.config.sharing = YES;
        self.lbl_social_value.text = @"On";
    }
    
    
    NSString *str = [ NSString stringWithFormat:@"%d", app.config.sharing ];
    [[NSUserDefaults standardUserDefaults] setObject:str forKey:@"sharing"];
}



#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Navigation logic may go here. Create and push another view controller.
    /*
     <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:@"<#Nib name#>" bundle:nil];
     // ...
     // Pass the selected object to the new view controller.
     [self.navigationController pushViewController:detailViewController animated:YES];
     [detailViewController release];
     */
    
    UITableViewCell *cell = [ tableView cellForRowAtIndexPath:indexPath ];
    
    self.selected = cell;
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        int row = [ indexPath row ];
    //if (row == self.current_page)
    //{
        //return;
    //}
    //else
    
    /*
    self.cell_chroma.selected = NO;
    self.cell_config.selected = NO;
    self.cell_done.selected = NO;
    self.cell_offline.selected = NO;
    self.cell_photobooth.selected = NO;
    self.cell_printing.selected = NO;
    self.cell_sharing.selected = NO;
     */
    
    if (row==0)
    {
        //self.cell_config.selected = YES;
        UIViewController<SubstitutableDetailViewController> * vc =
            (UIViewController<SubstitutableDetailViewController> *)
            app.cms_view;
        [self setRight:vc title:@"" ];
    }
    else if (row==1)
    {
        //self.cell_sharing.selected = YES;

        UIViewController<SubstitutableDetailViewController> * vc =
            (UIViewController<SubstitutableDetailViewController> *)
        app.settings_right_view;
        [self setRight:vc title:@"Social"];
    }
    else if (row==2)
    {
        //self.cell_printing.selected = YES;
        UIViewController<SubstitutableDetailViewController> * vc =
        (UIViewController<SubstitutableDetailViewController> *)
        app.settings_right_view;
        [self setRight:vc title:@"Printing"];
    }
    else if (row==3)
    {
        //self.cell_offline.selected = YES;
        UIViewController<SubstitutableDetailViewController> * vc =
        (UIViewController<SubstitutableDetailViewController> *)
        app.settings_right_view;
        [self setRight:vc title:@"Offline"];
    }
    else if (row==4)
    {
        //self.cell_photobooth.selected = YES;
        UIViewController<SubstitutableDetailViewController> * vc =
        (UIViewController<SubstitutableDetailViewController> *)
        app.settings_right_view;
        [self setRight:vc title:@"Photobooth"];
    }
    
    else if (row==5)
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        [ app settings_done ];

    }
    
    self.current_page = row;
    
    if (row!=5)
    {
    if (self.navigationPopoverController)
    {
        [ self.navigationPopoverController dismissPopoverAnimated:YES];
    }
    }
    
}



-(void) select_chroma
{
    /*
    NSIndexPath *path = [NSIndexPath indexPathForItem:0 inSection:0 ];
    //UITableViewCell *cell = [ self.tableView cellForRowAtIndexPath:path ];
    UITableViewCell *cell = self.cell_chroma;
    if (cell == nil)
    {
        return;
    }
    else if ( cell == self.selected )
    {
        return;
    }
    else
    {
        [ self.selected setSelected:NO ];
        [ cell setSelected:YES animated:YES];
        
        self.selected = cell;
        
        int row = [ path row ];
        if ( row == 0 )
        {
            [ AppDelegate show_settings_chroma ];
        }

    }
     */
}





#pragma mark -
#pragma mark UISplitViewControllerDelegate implementation
- (void)splitViewController:(UISplitViewController*)svc
     willHideViewController:(UIViewController *)aViewController
          withBarButtonItem:(UIBarButtonItem*)barButtonItem
       forPopoverController:(UIPopoverController*)pc
{
    
    barButtonItem.title = @"Settings";
    
    self.navigationPaneButtonItem = barButtonItem;
    self.navigationPopoverController = pc;
    
    // Tell the detail view controller to show the navigation button.
    self.detailViewController.navigationPaneBarButtonItem = barButtonItem;
    
    /*
    //self.popover = pc;
    self.navigationPopoverController = pc;
    
    //[barButtonItem setTitle:@"Settings"];
    //self.navigationItem.leftBarButtonItem = barButtonItem;
    //aViewController.navigationController.navigationBarHidden = NO;
    //aViewController.navigationItem.leftBarButtonItem = barButtonItem;
    
    UINavigationController *detail_nav =
        (UINavigationController *)[ self.splitViewController.viewControllers
                               objectAtIndex:1];
    [barButtonItem setTitle:@"Settings"];
    ChromaViewController *detail =
        (ChromaViewController *)[ detail_nav.viewControllers objectAtIndex: 0];
    detail.navigationController.navigationBarHidden = NO;
    detail.navigationItem.title = @"Chroma Key";
    detail.navigationItem.leftBarButtonItem = barButtonItem;
    
    detail.popover = pc;
    */
    
}


- (void)splitViewController:(UISplitViewController*)svc
     willShowViewController:(UIViewController *)aViewController
  invalidatingBarButtonItem:(UIBarButtonItem *)barButtonItem
{
    self.navigationPaneButtonItem = nil;
    self.navigationPopoverController = nil;
    
    // Tell the detail view controller to remove the navigation button.
    self.detailViewController.navigationPaneBarButtonItem = nil;
    
    //self.navigationItem.leftBarButtonItem = nil;
    //aViewController.navigationController.navigationBarHidden = NO;
    //aViewController.navigationItem.leftBarButtonItem = nil;
    
    //self.navigationPopoverController =
   
    /*
    self.popover = nil;
        UINavigationController *detail_nav =
    (UINavigationController *)[ self.splitViewController.viewControllers
                               objectAtIndex:1];
    ChromaViewController *detail = 
            (ChromaViewController *)[ detail_nav.viewControllers objectAtIndex: 0];
    detail.navigationController.navigationBarHidden = NO;
    detail.navigationItem.title = @"Chroma Key";
    detail.navigationItem.leftBarButtonItem = nil;
    
    detail.popover = nil;
     */
}



@end
