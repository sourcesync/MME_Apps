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
    
    //  various init...
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    app.cm.cmdel = self;
    self.cm = app.cm; 
    self.content = app.cm.content;
    self.content_keys = [ [ app.cm.content allKeys ]
                         sortedArrayUsingComparator: ^(id a, id b) {
                             NSString *ka = (NSString *)a;
                             NSString *kb = (NSString *)b;
                             return [ka compare:kb]; } ];
    //  init table...
    self.tv.delegate = self;
    self.tv.dataSource = self;
}

-(void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    //  update the url...
    self.fld_url.text = self.cm.remote;
    
    //  update the skin...
    self.lbl_skin.text = self.cm.name;
    
    //  this will update the status label...
    [ self ContentStatusChanged ];
    
    [self.tv reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//  CONTENTMANAGERDELEGATE

-(void) ContentStatusChanged
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    
    //  Change the status label...
    NSString *lblstr = [ NSString stringWithFormat:@"%@/%@",app.cm.str_cstatus,
                        app.cm.str_sstatus];
    self.lbl_status.text = lblstr;
    
    //  Change sync button based on status...
    [ self btn_sync_update ];
    
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
   int rows = [ self.content_keys count ];
    return rows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MyIdentifier"];
    if (cell == nil)
    {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"MyIdentifier"] autorelease];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        
    }
    
    int row = [ indexPath row ];
    NSString *key = [ self.content_keys objectAtIndex:row];
    cell.textLabel.text = key;
    cell.detailTextLabel.text = nil;
    cell.imageView.image = nil;
    
    //cell.backgroundColor = [ UIColor greenColor ];
    //cell.backgroundView.backgroundColor = [ UIColor greenColor];
    
    cell.textLabel.backgroundColor = [ UIColor clearColor];
    cell.detailTextLabel.backgroundColor = [ UIColor clearColor];
    
    ContentItem *item = [ self.content objectForKey:key ];
    if (item.data==nil)
    {
        if ( item.syncing )
            cell.contentView.backgroundColor = [ UIColor yellowColor];
        else
            cell.contentView.backgroundColor = [ UIColor redColor];
        
        cell.detailTextLabel.text = @"NO VALUE";
    }
    else
    {
        if ( item.syncing )
            cell.contentView.backgroundColor = [ UIColor yellowColor];
        else
            cell.contentView.backgroundColor = [ UIColor greenColor];
        
        if ( [  item.data isKindOfClass:[ NSNumber class] ] )
        {
            NSNumber *num = item.data;
            NSString *val = [ NSString stringWithFormat:@"value=%@", num ];
            cell.detailTextLabel.text = val;
            cell.imageView.image = nil;
        }
        else if ( [  item.data isKindOfClass:[ UIImage class] ])
        {
            NSString *val = [ NSString stringWithFormat:@"value=%@/%@", item.local, item.remote ];
            cell.detailTextLabel.text = val;
            //cell.imageView.image = item.data;
        }
        else if ( [  item.data isKindOfClass:[ AVAudioPlayer class] ] )
        {
            NSString *val = [ NSString stringWithFormat:@"value=%@/%@", item.local, item.remote ];
            cell.detailTextLabel.text = val;
            cell.imageView.image = nil;
        }
        else if ( [  item.data isKindOfClass:[ NSString class] ] )
        {
            NSString *val = [ NSString stringWithFormat:@"value=%@", item.data ];
            cell.detailTextLabel.text = val;
            cell.imageView.image = nil;
        }
        else
        {
            
        }
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
    if ( [ self.cm is_complete] )
    {
        AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
        
        [ app goto_start ];
    }
}

@end
