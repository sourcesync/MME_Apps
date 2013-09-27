//
//  CMSViewController.m
//  PhotomationApp
//
//  Created by Cuong George Williams on 9/5/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "CMSViewController.h"

#import "ContentManager.h"
#import "AppDelegate.h"
#import "ContentItem.h"

@interface CMSViewController ()

@end

@implementation CMSViewController

//@synthesize navigationTitle=_navigationItem;
//@synthesize navigationPaneBarButtonItem=_navigationPaneBarButtonItem;

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    //[ AppDelegate ErrorMessage:@"VC Memory Low" ];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self)
    {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    //  init table...
    self.tv.delegate = self;
    self.tv.dataSource = self;
    
    [self.navigationItem setHidesBackButton:YES animated:NO];
    self.navigationPaneBarButtonItem = nil;
    
    self.tv.allowsSelection = YES;
    
    self.tap = [ [ UITapGestureRecognizer alloc ]
                initWithTarget:self action:@selector( img_tapped: ) ];
    [self.tap setNumberOfTapsRequired:1];
    [self.img_preview  addGestureRecognizer:self.tap];
    
    
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    

    //  Make sure this object is the callback delegate for the contentmanager...

    [self.tv reloadData];
    
    self.activity.hidden = YES;
    [ self.activity stopAnimating];
}

-(void) viewDidAppear:(BOOL)animated
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    self.cm = app.cm;
    app.cm.cmdel = self;
    
    self.content = app.cm.content;
    self.content_keys = [ [ app.cm.content allKeys ]
                         sortedArrayUsingComparator: ^(id a, id b) {
                             NSString *ka = (NSString *)a;
                             NSString *kb = (NSString *)b;
                             return [ka compare:kb]; } ];
    
    
    //  update the url...
    self.fld_url.text = self.cm.remote;
    
    //  update the skin...
    self.lbl_skin.text = self.cm.name;
    
    //  this will update the status label...
    //  Change the status label...
    NSString *cstr = app.cm.str_cstatus;
    NSLog(@"%@",cstr);
    NSString *sstr = app.cm.str_sstatus;
    NSLog(@"%@",sstr);
    NSString *lblstr = [ NSString stringWithFormat:@"%@,%@",cstr,sstr];
    self.lbl_status.text = lblstr;
    
    [self.tv reloadData];
}

-(void) viewWillDisappear:(BOOL)animated
{
    [ super viewWillDisappear:animated];
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    app.cm.cmdel = nil;
    
    self.current_audio = nil;
    self.img_preview.image = nil;
    [ self.cm lowmemory ];
}


//  CONTENTMANAGERDELEGATE

-(void) ConfigDownloadSucceeded
{
    
}

-(void) ConfigDownloadFailed
{
    
}

-(void) ContentStatusChanged
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  Change the status label...
    NSString *lblstr = [ NSString stringWithFormat:@"%@/%@",app.cm.str_cstatus,
                        app.cm.str_sstatus];
    self.lbl_status.text = lblstr;
    
    //  Change sync button based on status...
    [ self btn_sync_update ];
    
    //  change activity...
    if ( ( self.cm.sstatus == SyncingConfig ) || ( self.cm.sstatus == SyncingSettings ) )
    {
        self.activity.hidden = NO;
        [ self.activity startAnimating ];
    }
    else
    {
        self.activity.hidden = YES;
        [ self.activity stopAnimating ];
    }
    
    [ self.tv reloadData ];
}


-(void) ContentConfigChanged
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    self.content = app.cm.content;
    self.content_keys = [ [ app.cm.content allKeys ]
                        sortedArrayUsingComparator: ^(id a, id b) {
                            NSString *ka = (NSString *)a;
                            NSString *kb = (NSString *)b;
                            return [ka compare:kb]; } ];
    
    [ self.tv reloadData ];
}

//  UITABLEVIEW delegates

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1; 
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (self.content_keys == nil) return 0;
    
   int rows = [ self.content_keys count ];
    return rows;
}


-(IBAction) img_tapped: (id)sender
{
    self.img_preview.hidden = YES;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    int row = [ indexPath row ];
    NSString *key = [ self.content_keys objectAtIndex:row];
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    NSLog(@"%@",key);
    
    if ( [ key hasPrefix:@"img_" ] )
    {
        UIImage *img = [ app.cm get_setting_image:key ];
        if ( img )
        {
            self.img_preview.image = nil;
            self.img_preview.image = img;
            self.img_preview.hidden = NO;
        }
        else
        {
            [ AppDelegate ErrorMessage:@"Could not find/load image"];
        }
    }
    else if ( [ key hasPrefix:@"snd_" ] )
    {
        if (self.current_audio)
        {
            [ self.current_audio stop ];
            self.current_audio = nil;
        }
        AVAudioPlayer *av = [ app.cm get_setting_sound:key];
        if (av)
        {
            self.current_audio = av;
            [ av play ];
        }
    }
    else
    {
        if (self.current_audio)
        {
            [ self.current_audio stop ];
            self.current_audio = nil;
        }
        self.img_preview.image = nil;
        self.img_preview.hidden = YES;
    }
    
    
    
    //return [ tableView cellForRowAtIndexPath:indexPath];

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] autorelease];
        //cell.selectionStyle = UITableViewS
        
    }
    
    int row = [ indexPath row ];
    NSString *key = [ self.content_keys objectAtIndex:row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    
    //cell.textLabel.backgroundColor = [ UIColor clearColor];
    //cell.detailTextLabel.backgroundColor = [ UIColor clearColor];
    //cell.contentView.backgroundColor = [ UIColor whiteColor ];
    
    cell.detailTextLabel.text = @"NO VALUE";
    
    ContentItem *item = [ self.content objectForKey:key ];
    if ( item.syncing )
    {
        cell.contentView.backgroundColor = [ UIColor yellowColor];
    }
    else if ( item.data || ( !item.data && item.local_file ) )
    {
        //cell.contentView.backgroundColor = [ UIColor greenColor];
        cell.contentView.backgroundColor = [ UIColor whiteColor ];
        if ( [  item.data isKindOfClass:[ NSNumber class] ] )
        {
            NSNumber *num = item.data;
            NSString *val = [ NSString stringWithFormat:@"value=%@", num ];
            cell.detailTextLabel.text = val;
            cell.imageView.image = nil;
        }
        else if ( [  item.data isKindOfClass:[ NSString class] ] )
        {
            NSString *val = [ NSString stringWithFormat:@"value=%@", item.data ];
            cell.detailTextLabel.text = val;
            cell.imageView.image = nil;
        }
        else if ( item.fpath )
        {
            NSString *val = [ NSString stringWithFormat:@"value=%@ / %@", item.subpath, item.remote ];
            cell.detailTextLabel.text = val;
            //cell.imageView.image = item.data;
        }
        //else if ( [  item.data isKindOfClass:[ AVAudioPlayer class] ] )
        //{
        //    NSString *val = [ NSString stringWithFormat:@"value=%@ /%@", item.subpath, item.remote ];
        //    cell.detailTextLabel.text = val;
        //    cell.imageView.image = nil;
        //}
        else
        {
            [ AppDelegate ErrorMessage:@"Unknown setting type"];
        }
    }
    else
    {
        cell.contentView.backgroundColor = [ UIColor redColor];
    }
    
    
    //NSString *path = [[NSBundle mainBundle] pathForResource:[item objectForKey:@"imageKey"] ofType:@"png"];
    //UIImage *theImage = [UIImage imageWithContentsOfFile:path];
    //cell.imageView.image = theImage;
    
    return cell;
}



-(void) btn_sync_update
{
    if ( [ self.cm is_syncing ] )
        self.btn_sync.enabled = NO;
    else
        self.btn_sync.enabled = YES;
}


-(IBAction) btn_action_sync: (id)sender
{
    if ( ! [ self.cm is_syncing] )
    {
        [ self.cm sync ];
        
        [ self btn_sync_update ];
    }
}


-(IBAction) btn_action_launch: (id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app settings_done ];

    /*
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    if ( [self.cm is_syncing] )
    {
        [AppDelegate ErrorMessage:@"Please wait.  Content is syncing."];
    }
    else if ( [ self.cm is_complete] )
    {
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
    if (navigationPaneBarButtonItem != _navigationPaneBarButtonItem) {
        if (navigationPaneBarButtonItem)
            [self.toolbar setItems:[NSArray arrayWithObjects:
                                    navigationPaneBarButtonItem,
                                    self.flex,
                                    self.doneButton, nil]animated:NO];
        else
            [self.toolbar setItems:nil animated:NO];
        
        [_navigationPaneBarButtonItem release];
        _navigationPaneBarButtonItem = [navigationPaneBarButtonItem retain];
    }
}


- (void)setNavigationTitle:(NSString *)navigationTitle
{
    self.navigationItem.title = navigationTitle;
}

@end
