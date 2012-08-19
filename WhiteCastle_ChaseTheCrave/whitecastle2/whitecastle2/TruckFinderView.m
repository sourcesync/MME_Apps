//
//  TruckFinderView.m
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TruckFinderView.h"

#import "AppDelegate.h"

@interface TruckFinderView ()

@end

@implementation TruckFinderView


-(void) go_home:(id)obj
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_home:obj ];
    //[ app pop ];
}


-(IBAction)schedule_notification
{
        UILocalNotification *localNotification = [[UILocalNotification alloc] init];
        
        NSDate *now = [NSDate date];
        NSDate *future = [ now dateByAddingTimeInterval:10 ];
        localNotification.fireDate = future;
        localNotification.alertBody = @"There is a WhiteCastle Close By!";
        localNotification.soundName = UILocalNotificationDefaultSoundName;
        localNotification.applicationIconBadgeNumber = 1;
        
        NSDictionary *infoDict = [NSDictionary dictionaryWithObjectsAndKeys:@"Object 1", @"Key 1", @"Object 2", @"Key 2", nil];
        localNotification.userInfo = infoDict;
        
        [[UIApplication sharedApplication] scheduleLocalNotification:localNotification];
        [localNotification release];
    
}

-(IBAction)go_rewards:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_rewards:nil ];
}



-(IBAction)go_signup:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_signup:nil ];
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
