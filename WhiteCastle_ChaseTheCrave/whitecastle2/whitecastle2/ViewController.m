//
//  ViewController.m
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

#import "AppDelegate.h"

@interface ViewController ()

@end

@implementation ViewController


static bool _wenthome = false;

-(void) go_home:(id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_home:obj ];
}


-(void) cbtimer: (id)obj
{
    if ( _wenthome ) return;
    else 
    {
        [ self go_home:obj ];
        _wenthome = true;
    }
}


- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    [ [ UIApplication sharedApplication ] setStatusBarHidden: YES ];
    
    
    [ self performSelector:@selector(cbtimer:) withObject:self afterDelay:3 ];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return NO;
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
