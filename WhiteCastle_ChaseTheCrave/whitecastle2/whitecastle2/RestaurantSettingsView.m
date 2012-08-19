//
//  RestaurantSettingsView.m
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RestaurantSettingsView.h"

#import "AppDelegate.h"

@interface RestaurantSettingsView ()

@end

@implementation RestaurantSettingsView


@synthesize dist=_dist;
@synthesize distslider=_distslider;
@synthesize num=_num;
@synthesize numslider=_numslider;


-(void) distSliderMove:(id)obj
{
    self.dist.text = [ NSString stringWithFormat:@"%2.1fm",self.distslider.value ];
}


-(void) numSliderMove:(id)obj
{
    self.num.text = [ NSString stringWithFormat:@"%d", (int)self.numslider.value ];
}


-(IBAction) go_home:(id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_home:obj ];
    //[ app pop ];
}


-(IBAction)go_rewards:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_rewards:nil ];
}


-(IBAction)go_settings:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_myaccounthome: sender ];
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
    
    
    [ self.distslider 
        addTarget:self action:@selector(distSliderMove:) forControlEvents:UIControlEventValueChanged];
    
    [ self.numslider 
        addTarget:self action:@selector(numSliderMove:) forControlEvents:UIControlEventValueChanged];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
