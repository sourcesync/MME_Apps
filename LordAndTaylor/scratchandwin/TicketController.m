//
//  TicketController.m
//  scratchandwin
//
//  Created by George Williams on 7/7/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "TicketController.h"

#import "AppDelegate.h"

@interface TicketController ()

@end

@implementation TicketController

@synthesize scratch_iv=_scratch_iv;
@synthesize winner_iv=_winner_iv;
@synthesize results_iv=_results_iv;

@synthesize state=_state;

@synthesize mouseSwiped=_mouseSwiped;
@synthesize drawImage=_drawImage;
@synthesize lastPoint=_lastPoint;
@synthesize firstTouch=_firstTouch;
@synthesize img=_img;
@synthesize winner=_winner;
@synthesize canceled=_canceled;
@synthesize blink_state=_blink_state;
@synthesize scratch_started=_scratch_started;

@synthesize redeem_timer_started=_redeem_timer_started;

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
    
    self.state = 0;
}


- (void) viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated ];
    
    self.canceled = NO;
    self.redeem_timer_started = NO;
    self.blink_state = YES;
    self.scratch_started = NO;
    
    [[UIApplication sharedApplication] setStatusBarHidden:YES  ]; 
    
    if ( self.state == 0 )
    {
        UIImage *imgg = [ UIImage imageNamed:@"iphone-scratchticket-rot.jpg" ];
        if (!imgg) 
        {
            
        }
        self.scratch_iv.image = imgg;
        [ self.scratch_iv setFrame:CGRectMake(0, 0, 320, 480) ];
        self.scratch_iv.hidden = NO;
        
        
        //imgg = [ UIImage imageNamed:@"iphone-scratchticket-scratched-cleaned" ];
        self.winner_iv.image = self.img;
        [ self.winner_iv setFrame:CGRectMake(0, 0, 320, 480) ];

        self.results_iv.hidden = YES;
    }

    self.firstTouch = YES;
    self.drawImage = self.scratch_iv;
    
}

-(void) viewWillDisappear:(BOOL)animated
{
    self.canceled = YES;
}

-(void) show_results: (id)obj
{
    //  home or my coupons clicked ?...
    if (self.canceled) return;
    
    //  already showing results? (back from timer)...
    if (self.state==1) return;
    
    self.scratch_iv.hidden = YES;
    
    if (self.winner)
    {
        UIImage *img = [ UIImage imageNamed:@"iphone-winner-cosmetics-rot.png" ];
        self.results_iv.image = img;
        self.results_iv.hidden = NO;
        self.state = 1;
    }
    else 
    {
        UIImage *img = [ UIImage imageNamed:@"iphone-not-a-winner-rot.png" ];
        self.results_iv.image = img;
        self.results_iv.hidden = NO;
        self.state = 1;
    }
    
    [ self blink:self ];

}

-(void) blink: (id)obj
{
    if (self.canceled) return;
    
    if (self.blink_state)
    {
        self.results_iv.hidden = NO;
    }
    else 
    {
        self.results_iv.hidden = YES;
    }
    
    self.blink_state = !self.blink_state;
    
    [ self performSelector:@selector(blink:) withObject:self afterDelay:0.5 ];
}

-(void) viewDidAppear:(BOOL)animated
{
    [ super viewDidAppear:animated ];
    
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    
    return NO;
    //return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



-(IBAction) home:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app Home ];
}


-(IBAction) my_coupons:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app ShowMyCoupons ];
}


-(IBAction) redeem:(id)sender
{
    if ( (self.state == 0 ) && ( self.scratch_started ) )
    {
        [ self show_results:self ];
    }
    else if (self.state == 1)
    {
        if (self.winner)
        {
            self.canceled = YES;
            AppDelegate *app = (AppDelegate *)
            [ [ UIApplication sharedApplication ] delegate ];
            [ app ShowCoupon: self ];
        }
        else 
        {
            self.canceled = YES;
            [ self home:self ];
        }
    }
}


- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event {
    
    self.mouseSwiped = NO;
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 2) {
        self.drawImage.image = nil;
        return;
    }
}

-(void) start_redeem_timer
{
    if (!self.redeem_timer_started)
    {
        self.redeem_timer_started = YES;
        
        [ self performSelector:@selector(show_results:) 
                    withObject:self 
                    afterDelay:5.0 ];
    }
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event {
    self.mouseSwiped = YES;
    
    UITouch *touch = [touches anyObject];
    CGPoint currentPoint = [touch locationInView:self.view];
    currentPoint.y -= 20;
    
    if ( self.firstTouch )
    {
        self.firstTouch = NO;
        self.lastPoint = CGPointMake( currentPoint.x, currentPoint.y);
    }
    
    /*
    UIGraphicsBeginImageContext(self.drawImage.frame.size);
    [self.drawImage.image drawInRect:CGRectMake(0, 0, 
                                                self.drawImage.frame.size.width,
                                                self.drawImage.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGImageAlphaNone); //kCGImageAlphaPremultipliedLast);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1, 0, 0, 10);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 
                         self.lastPoint.x, self.lastPoint.y);
    CGContextClearRect (UIGraphicsGetCurrentContext(), 
                        CGRectMake(self.lastPoint.x, self.lastPoint.y, 10, 10));
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    */
    
    
     UIGraphicsBeginImageContext(self.view.frame.size);
    CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
    
    [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
    CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 25.0);
    CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 10.0);
    CGContextBeginPath(UIGraphicsGetCurrentContext());
    CGContextMoveToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
    CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), currentPoint.x, currentPoint.y);
    CGContextStrokePath(UIGraphicsGetCurrentContext());
    self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
     
    self.lastPoint = currentPoint;
    
    self.scratch_started = YES;
    
    
    [ self start_redeem_timer ];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event 
{
    
    UITouch *touch = [touches anyObject];
    
    if ([touch tapCount] == 2) {
        self.drawImage.image = nil;
        return;
    }
    
    
    if(!self.mouseSwiped) 
    {
        
        UIGraphicsBeginImageContext(self.drawImage.frame.size);
        [self.drawImage.image drawInRect:CGRectMake(0, 0, 
                                                    self.drawImage.frame.size.width,
                                                    self.drawImage.frame.size.height)];
        
        /*
        CGContextSetLineCap(UIGraphicsGetCurrentContext(),kCGImageAlphaNone); //kCGImageAlphaPremultipliedLast);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 10);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1, 0, 0, 10);
        CGContextBeginPath(UIGraphicsGetCurrentContext());
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 
                             self.lastPoint.x, self.lastPoint.y);
        CGContextClearRect (UIGraphicsGetCurrentContext(), 
                            CGRectMake(self.lastPoint.x, self.lastPoint.y, 10, 10));
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        */
        
        
        
        UIGraphicsBeginImageContext(self.view.frame.size);        
        CGContextSetBlendMode(UIGraphicsGetCurrentContext(), kCGBlendModeClear);
        
        [self.drawImage.image drawInRect:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        CGContextSetLineCap(UIGraphicsGetCurrentContext(), kCGLineCapRound);
        CGContextSetLineWidth(UIGraphicsGetCurrentContext(), 25.0);
        CGContextSetRGBStrokeColor(UIGraphicsGetCurrentContext(), 1.0, 0.0, 0.0, 10.0);
        CGContextMoveToPoint(UIGraphicsGetCurrentContext(), 
                             self.lastPoint.x, self.lastPoint.y);
        CGContextAddLineToPoint(UIGraphicsGetCurrentContext(), self.lastPoint.x, self.lastPoint.y);
        CGContextStrokePath(UIGraphicsGetCurrentContext());
        CGContextFlush(UIGraphicsGetCurrentContext());
        self.drawImage.image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        self.scratch_started = YES;
        
        [ self start_redeem_timer ];
        
    }
}



@end
