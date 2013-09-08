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

@interface SettingsLeftViewController ()

@end

@implementation SettingsLeftViewController

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
 
    self.navigationController.navigationBarHidden = NO;
    self.navigationItem.title = @"Settings";
    
    //self.navigationItem.leftBarButtonItem = barButtonItem;
    
    self.selected = nil;
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
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
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
        self.cell_sharing.userInteractionEnabled = YES;
        return self.cell_chroma;
    }
    else if ( row == 1 )
    {
        self.cell_sharing.userInteractionEnabled = NO;
        return self.cell_sharing;
    }
    else if ( row == 2 )
    {
        self.cell_printing.userInteractionEnabled = NO;
        return self.cell_printing;
    }
    else if ( row == 3 )
    {
        self.cell_offline.userInteractionEnabled = NO;
        return self.cell_offline;
    }
    else if ( row == 4 )
    {
        self.cell_photobooth.userInteractionEnabled = NO;
        return self.cell_photobooth;
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
    //if ( self.selected == cell )
    //{
        //[ self.popover dismissPopoverAnimated:YES];
        //return;
    //}
    
    self.selected = cell;
    
    //int row = [ indexPath row ];
    //if ( row == 0 )
    //{
    //    [ AppDelegate show_settings_chroma ];
    //}
    
    if (self.popover)
    {
        [ self.popover dismissPopoverAnimated:YES];
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
    self.popover = pc;
    
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
    ChromaViewController *detail =
        (ChromaViewController *)[ detail_nav.viewControllers objectAtIndex: 0];
    detail.navigationController.navigationBarHidden = NO;
    detail.navigationItem.title = @"Chroma Key";
    detail.navigationItem.leftBarButtonItem = nil;
    
    detail.popover = nil;
}



@end
