//
//  SelectFavoriteViewController.m
//  PhotomationApp
//
//  Created by Cuong Williams on 3/14/13.
//  Copyright (c) 2013 Dev Null Enterprises, LLC. All rights reserved.
//

#import "AppDelegate.h"

#import "SelectFavoriteViewController.h"

@interface SelectFavoriteViewController ()

@end

@implementation SelectFavoriteViewController

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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void) viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated];
    
    NSMutableArray *array = [ NSMutableArray arrayWithObjects:
                             self.first, self.second, self.third, self.fourth, nil];
    NSMutableArray *barray = [ NSMutableArray arrayWithObjects:
                             self.bfirst, self.bsecond, self.bthird, self.bfourth, nil];
     
    for ( int i=0;i < 4; i ++) 
    {
        UIImageView *view = (UIImageView *)[ array objectAtIndex:i ];
        view.hidden = YES;
        UIButton *btn = (UIButton *)[ barray objectAtIndex:i ];
        btn.hidden = YES;
    }
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    int take_count = app.take_count;
    
    for ( int i=0;i < take_count; i ++)
    {
        NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg",i ];
        NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname ];
        BOOL fileExists = [[NSFileManager defaultManager] fileExistsAtPath:jpgPath];
        if (fileExists)
        {
            UIImageView *view = (UIImageView *)[ array objectAtIndex:i ];
            UIImage *image = [[ UIImage alloc ] initWithContentsOfFile:jpgPath ];
            [ view initWithImage:image ];
            view.hidden = NO;

            UIButton *btn = (UIButton *)[ barray objectAtIndex:i ];
            btn.hidden = NO;
        }
    }
}

- (void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated];
    
    [ self playSound:@"pickfavorite" ];
}


- (BOOL)shouldAutorotate
{
    return NO;
}


- (void) playSound:(NSString *)sound
{
    
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app playSound:sound delegate:self];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}

-(IBAction) photo_selected: (id)sender
{
    UIView *view = (UIView *)sender;
    int tag = view.tag;
    
    [ self playSound:@"selection"];
    
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    app.selected_id = tag;
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg", app.selected_id ];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    app.fname = jpgPath;
    
    [ app goto_selectedphoto ];
}


-(IBAction) delete_all:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btn_settings:(id)sender
{
    //[ AppDelegate NotImplemented:nil ];
}
@end
