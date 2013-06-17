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
    
    UIInterfaceOrientation uiorientation = [ [ UIApplication sharedApplication] statusBarOrientation];
    [ self orientElements:uiorientation];
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
    NSURL *url = [NSURL URLWithString:sound];
    [ app playSound:url delegate:self];
}


- (void)audioPlayerDidFinishPlaying:(AVAudioPlayer *)player successfully:(BOOL)flag
{
}

-(IBAction) photo_selected: (id)sender
{
    UIView *view = (UIView *)sender;
    int tag = view.tag;
    
    [ self playSound:@"selection"];
    
    //  Set the global path to the selected photo...
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    app.selected_id = tag;
    NSString *fname = [ NSString stringWithFormat:@"Documents/TakePhoto%d.jpg", app.selected_id ];
    NSString  *jpgPath = [NSHomeDirectory() stringByAppendingPathComponent:fname];
    app.fpath = jpgPath;
    
    //  Show selected photo screen...
    [ app goto_selectedphoto ];
}


-(IBAction) delete_all:(id)sender
{
    AppDelegate *app = (AppDelegate *)[[ UIApplication sharedApplication] delegate ];
    [ app goto_takephoto ];
}


-(IBAction) btn_settings:(id)sender
{
    [ AppDelegate NotImplemented:nil ];
}





- (NSUInteger)supportedInterfaceOrientations
{
    NSUInteger orientations =
    UIInterfaceOrientationMaskAll;
    return orientations;
}

-(BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(interfaceOrientation) )
    {
        return YES;
    }
    else
    {
        return YES;
    }
}

-(void)orientElements:(UIInterfaceOrientation)toInterfaceOrientation
{
    if ( UIInterfaceOrientationIsPortrait(toInterfaceOrientation) )
    {
        /*
        self.img_bg.image = [ UIImage imageNamed:
                             @"8-Photomation-iPad-Gallery-Main-Screen-Vertical.jpg" ];
        
        CGRect rect = CGRectMake(119,171, 117,156);
        self.one.frame = rect;
        self.bone.frame = rect;
        
        rect = CGRectMake(258, 171, 117,156);
        self.two.frame = rect;
        self.btwo.frame = rect;
        
        rect = CGRectMake(397, 171, 117,156);
        self.three.frame = rect;
        self.bthree.frame = rect;
        
        rect = CGRectMake(532, 171, 117,156);
        self.four.frame = rect;
        self.bfour.frame = rect;
        
        rect = CGRectMake(119, 353, 117,156);
        self.five.frame = rect;
        self.bfive.frame = rect;
        
        rect = CGRectMake(258, 353, 117, 156);
        self.six.frame = rect;
        self.bsix.frame = rect;
        
        rect = CGRectMake(397, 353, 117,156);
        self.seven.frame = rect;
        self.bseven.frame = rect;
        
        rect = CGRectMake(532, 353, 117,156);
        self.eight.frame = rect;
        self.beight.frame = rect;
        
        rect = CGRectMake(119, 534, 117,156);
        self.nine.frame = rect;
        self.bnine.frame = rect;
        
        rect = CGRectMake(258, 534, 117,156);
        self.ten.frame = rect;
        self.bten.frame = rect;
        
        rect = CGRectMake(397, 534, 117,156);
        self.eleven.frame = rect;
        self.beleven.frame = rect;
        
        rect = CGRectMake(532, 534, 117,156);
        self.twelve.frame = rect;
        self.btwelve.frame = rect;
        
        //
        rect = CGRectMake(200,944, 73,72);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(347, 944, 73,72);
        self.btn_takephoto.frame = rect;
        
        rect = CGRectMake(490, 944, 73,72);
        self.btn_settings.frame = rect;
        
        rect = CGRectMake(26, 394, 73,72);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(675, 394, 73,72);
        self.btn_right.frame = rect;
        */
    }
    else if ( UIInterfaceOrientationIsLandscape(toInterfaceOrientation) )
    {
        /*
        self.img_bg.image = [ UIImage imageNamed:
                             @"8-Photomation-iPad-Gallery-Main-Screen-Horizontal.jpg" ];
        
        CGRect rect = CGRectMake(276,109, 104,143);
        self.one.frame = rect;
        self.bone.frame = rect;
        
        rect = CGRectMake(399,109, 104,143);
        self.two.frame = rect;
        self.btwo.frame = rect;
        
        rect = CGRectMake(523, 109, 104,143);
        self.three.frame = rect;
        self.bthree.frame = rect;
        
        rect = CGRectMake(645, 109, 104,143);
        self.four.frame = rect;
        self.bfour.frame = rect;
        
        rect = CGRectMake(276, 272, 104,143);
        self.five.frame = rect;
        self.bfive.frame = rect;
        
        rect = CGRectMake(399, 272, 104,143);
        self.six.frame = rect;
        self.bsix.frame = rect;
        
        rect = CGRectMake(523, 272, 104,143);
        self.seven.frame = rect;
        self.bseven.frame = rect;
        
        rect = CGRectMake(645, 272, 104,143);
        self.eight.frame = rect;
        self.beight.frame = rect;
        
        rect = CGRectMake(276, 434, 104,143);
        self.nine.frame = rect;
        self.bnine.frame = rect;
        
        rect = CGRectMake(399, 434, 104,143);
        self.ten.frame = rect;
        self.bten.frame = rect;
        
        rect = CGRectMake(523, 434, 104,143);
        self.eleven.frame = rect;
        self.beleven.frame = rect;
        
        rect = CGRectMake(645, 434, 104,143);
        self.twelve.frame = rect;
        self.btwelve.frame = rect;
        
        //
        rect = CGRectMake(302,689, 73,72);
        self.btn_gallery.frame = rect;
        
        rect = CGRectMake(476, 689, 73,72);
        self.btn_takephoto.frame = rect;
        
        rect = CGRectMake(645, 689, 73,72);
        self.btn_settings.frame = rect;
        
        rect = CGRectMake(160, 308, 73,72);
        self.btn_left.frame = rect;
        
        rect = CGRectMake(789, 308, 73,72);
        self.btn_right.frame = rect;
         */
    }
    
}


- (void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation
                                duration:(NSTimeInterval)duration
{
    [ self orientElements:toInterfaceOrientation];
}



@end
