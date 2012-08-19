//
//  HomeView.m
//  whitecastle2
//
//  Created by George Williams on 8/1/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "HomeView.h"

#import "AppDelegate.h"

@interface HomeView ()

@end

@implementation HomeView


-(IBAction) takePicture:(id) sender
{
    UIImagePickerController *imagePicker = [[UIImagePickerController alloc] init];
    
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypeCamera];
    }
    else
    {
        [imagePicker setSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }
    
    [imagePicker setDelegate:self];
    
    [self presentModalViewController:imagePicker animated:YES];
}


-(void) initializeFilterContext
{
    //context = [CIContext contextWithOptions:nil];
}



-(void) applyFilter:(id) sender
{
    /*
    selectedFilterView.layer.shadowRadius = 0.0f;
    selectedFilterView.layer.shadowOpacity = 0.0f;
    
    selectedFilterView = [(UITapGestureRecognizer *) sender view];
    
    selectedFilterView.layer.shadowColor = [UIColor yellowColor].CGColor;
    selectedFilterView.layer.shadowRadius = 3.0f;
    selectedFilterView.layer.shadowOpacity = 0.9f;
    selectedFilterView.layer.shadowOffset = CGSizeZero;
    selectedFilterView.layer.masksToBounds = NO;
    
    int filterIndex = selectedFilterView.tag;
    Filter *filter = [filters objectAtIndex:filterIndex];
    
    CIImage *outputImage = [filter.filter outputImage];
    
    CGImageRef cgimg =
    [context createCGImage:outputImage fromRect:[outputImage extent]];
    
    finalImage = [UIImage imageWithCGImage:cgimg];
    
    finalImage = [finalImage imageRotatedByDegrees:90];
    
    [self.imageView setImage:finalImage];
    
    CGImageRelease(cgimg);
    
     */
}

-(void) createPreviewViewsForFilters
{
    /*
    int offsetX = 10;
    
    for(int index = 0; index < [filters count]; index++)
    {
        UIView *filterView = [[UIView alloc] initWithFrame:CGRectMake(offsetX, 0, 60, 60)];
        filterView.tag = index;
        // create a label to display the name
        UILabel *filterNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, filterView.bounds.size.width, 8)];
        filterNameLabel.center = CGPointMake(filterView.bounds.size.width/2, filterView.bounds.size.height + filterNameLabel.bounds.size.height);
        Filter *filter = (Filter *) [filters objectAtIndex:index];
        filterNameLabel.text =  filter.name;
        filterNameLabel.backgroundColor = [UIColor clearColor];
        filterNameLabel.textColor = [UIColor whiteColor];
        filterNameLabel.font = [UIFont fontWithName:@"AppleColorEmoji" size:10];
        filterNameLabel.textAlignment = UITextAlignmentCenter;
        CIImage *outputImage = [filter.filter outputImage];
        CGImageRef cgimg =
        [context createCGImage:outputImage fromRect:[outputImage extent]];
        UIImage *smallImage =  [UIImage imageWithCGImage:cgimg];
        if(smallImage.imageOrientation == UIImageOrientationUp)
        {
            smallImage = [smallImage imageRotatedByDegrees:90];
        }
        
        // create filter preview image views
        UIImageView *filterPreviewImageView = [[UIImageView alloc] initWithImage:smallImage];
        [filterView setUserInteractionEnabled:YES];
        filterPreviewImageView.layer.cornerRadius = 15;
        filterPreviewImageView.opaque = NO;
        filterPreviewImageView.backgroundColor = [UIColor clearColor];
        filterPreviewImageView.layer.masksToBounds = YES;
        filterPreviewImageView.frame = CGRectMake(0, 0, 60, 60);
        filterView.tag = index;
        [self applyGesturesToFilterPreviewImageView:filterView];
        
        [filterView addSubview:filterPreviewImageView];
        [filterView addSubview:filterNameLabel];
        
        [filtersScrollView addSubview:filterView];
        
        offsetX += filterView.bounds.size.width + 10;
        
    }
    
    [filtersScrollView setContentSize:CGSizeMake(400, 90)];
     */
}


-(void) loadFiltersForImage:(UIImage *) image
{
    /*
    
    CIImage *filterPreviewImage = [[CIImage alloc] initWithImage:image];
    
    CIFilter *sepiaFilter = [CIFilter filterWithName:@"CISepiaTone" keysAndValues:kCIInputImageKey,filterPreviewImage,
                             @"inputIntensity",[NSNumber numberWithFloat:0.8],nil];
    
    
    CIFilter *colorMonochrome = [CIFilter filterWithName:@"CIColorMonochrome" keysAndValues:kCIInputImageKey,filterPreviewImage,
                                 @"inputColor",[CIColor colorWithString:@"Red"],
                                 @"inputIntensity",[NSNumber numberWithFloat:0.8], nil];
    
    filters = [[NSMutableArray alloc] init];
    
    */
    
    /*
    [filters addObjectsFromArray:[NSArray arrayWithObjects:
                                  [[Filter alloc] initWithNameAndFilter:@"Sepia" filter:sepiaFilter],
                                  [[Filter alloc] initWithNameAndFilter:@"Mono" filter:colorMonochrome]
                                  
                                  , nil]];
    */
    
    [self createPreviewViewsForFilters];
}


-(void) imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
     UIAlertView *message = [[UIAlertView alloc] initWithTitle:@"Hello World!"
     message:@"This is your first UIAlertview message."
     delegate:nil
     cancelButtonTitle:@"OK"
     otherButtonTitles:nil];
     
     [message show];
     
    //finalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //[self.imageView setImage:finalImage];
    
    // UIImageWriteToSavedPhotosAlbum(image, self, nil, nil);
    
    [self dismissModalViewControllerAnimated:YES];
    
    // load the filters again
    
    //[self loadFiltersForImage:finalImage];
}


/*


- (IBAction) showCameraUI {
    [self startCameraControllerFromViewController: self
                                    usingDelegate: self];
}

- (BOOL) startCameraControllerFromViewController: (UIViewController*) controller
                                   usingDelegate: (id <UIImagePickerControllerDelegate,
                                                   UINavigationControllerDelegate>) delegate {
    
    if (([UIImagePickerController isSourceTypeAvailable:
          UIImagePickerControllerSourceTypeCamera] == NO)
        || (delegate == nil)
        || (controller == nil))
        return NO;
    
    
    UIImagePickerController *cameraUI = [[UIImagePickerController alloc] init];
    cameraUI.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    // Displays a control that allows the user to choose picture or
    // movie capture, if both are available:
    cameraUI.mediaTypes =
    [UIImagePickerController availableMediaTypesForSourceType:
     UIImagePickerControllerSourceTypeCamera];
    
    // Hides the controls for moving & scaling pictures, or for
    // trimming movies. To instead show the controls, use YES.
    cameraUI.allowsEditing = NO;
    
    cameraUI.delegate = delegate;
    
    [controller presentModalViewController: cameraUI animated: YES];
    return YES;
}


// For responding to the user tapping Cancel.
- (void) imagePickerControllerDidCancel: (UIImagePickerController *) picker {
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker release];
}

// For responding to the user accepting a newly-captured picture or movie
- (void) imagePickerController: (UIImagePickerController *) picker
 didFinishPickingMediaWithInfo: (NSDictionary *) info {
    
    
    NSString *mediaType = [info objectForKey: UIImagePickerControllerMediaType];
    UIImage *originalImage, *editedImage, *imageToSave;
    
    
    // Handle a still image capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeImage, 0)
        == kCFCompareEqualTo) {
        
        editedImage = (UIImage *) [info objectForKey:
                                   UIImagePickerControllerEditedImage];
        originalImage = (UIImage *) [info objectForKey:
                                     UIImagePickerControllerOriginalImage];
        
        if (editedImage) {
            imageToSave = editedImage;
        } else {
            imageToSave = originalImage;
        }
        
        // Save the new image (original or edited) to the Camera Roll
        UIImageWriteToSavedPhotosAlbum (imageToSave, nil, nil , nil);
    }
     
    
    
    // Handle a movie capture
    if (CFStringCompare ((CFStringRef) mediaType, kUTTypeMovie, 0)
        == kCFCompareEqualTo) {
        
        NSString *moviePath = [[info objectForKey:
                                UIImagePickerControllerMediaURL] path];
        
        if (UIVideoAtPathIsCompatibleWithSavedPhotosAlbum (moviePath)) {
            UISaveVideoAtPathToSavedPhotosAlbum (
                                                 moviePath, nil, nil, nil);
        }
    }
     
    
    [[picker parentViewController] dismissModalViewControllerAnimated: YES];
    [picker release];
}

*/


-(IBAction)go_signup:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_signup:nil ];
}



-(IBAction)go_deals:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_deals:nil ];
}

-(IBAction)go_rewards:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_rewards:nil ];
}

-(IBAction)go_truckfinder:(id)sender
{
    AppDelegate *app = (AppDelegate *)[ [ UIApplication sharedApplication ] delegate ];
    [ app goto_truckfinder:nil ];
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
    [self setup];
}


-(void) setup
{
    /*
    [self setupAppearance];
    [self initializeFilterContext];
    //[self loadFiltersForImage:[UIImage imageNamed:@"iphone-splashscreen.png"]];
     */
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)viewWillAppear:(BOOL)animated
{
    [ super viewWillAppear:animated ];
    
    [ [ UIApplication sharedApplication ] setStatusBarHidden: YES ];
    
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
