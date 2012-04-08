//
//  MGPhotostreamController.m
//  Minigram
//
//  Created by Luke Adamson on 2/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGPhotostreamController.h"
#import "MGPhoto.h"
#import "MGStreamRequest.h"
#import "MGImageRequest.h"
#import "MGPostRequest.h"
#import "MGThumbnailRequest.h"
#import <QuartzCore/QuartzCore.h> // Used for specifying the shadow on the caption field background bar

@interface MGPhotostreamController ()
- (IBAction)cameraButtonTapped;
- (IBAction)refreshButtonTapped;

- (void)uploadNewPhotoWithImageData:(NSData *)jpegData caption:(NSString *)caption;
- (void)uploadDidFinish;

- (void)showUploadProgress;
- (void)hideUploadProgress;

- (void)loadThumbnailsForVisibleRows;
- (void)releaseImagesFromStream;

@property (nonatomic, strong) IBOutlet UIProgressView *uploadProgressView;
@property (nonatomic, strong) NSMutableArray *photoStream;
@property (nonatomic, strong) NSMutableArray *openConnections;
@property (nonatomic, strong) MGStreamRequest *streamRequest;
@end

// The following class extension is here to support taking photos and collecting an optional caption.
@interface MGPhotostreamController () <UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate>
- (void)presentCameraController;
@property (nonatomic, strong) IBOutlet UIView *captionBar;
@property (nonatomic, strong) IBOutlet UITextField *captionField;
@property (nonatomic, strong) NSData *jpegData;
@end


@implementation MGPhotostreamController

// Private accessors
@synthesize captionBar = _captionBar;
@synthesize captionField = _captionField;
@synthesize jpegData = _jpegData;
@synthesize uploadProgressView = _uploadProgressView;
@synthesize photoStream = _photoStream;
@synthesize openConnections = _openConnections;
@synthesize streamRequest = _streamRequest;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)coder;
{
    if ((self = [super initWithCoder:coder]))
    {
        [self setOpenConnections:[[NSMutableArray alloc] init]];
        [self setUploadProgressView:[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar]];
        [[[self navigationController] navigationBar] setTintColor:[UIColor orangeColor]];
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning PARENT");
    [self releaseImagesFromStream];
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
}

- (void)releaseImagesFromStream
{
    NSLog(@"Releasing photos from memory");
    
    NSIndexPath *pathToSelectedRow = [[self tableView] indexPathForSelectedRow];
    MGPhoto *selectedPhoto = [[self photoStream] objectAtIndex:[pathToSelectedRow row]];
    
    for(MGPhoto *photo in [self photoStream])
    {
        if(![photo isEqual:selectedPhoto])
        {
            [photo setImage:nil];            
        }
    }
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([self photoStream] == nil)
    {
        [self refreshButtonTapped];
    }
    [[self tableView] setRowHeight:60.0f];
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[self openConnections] makeObjectsPerformSelector:@selector(cancel:)];
    [[self streamRequest] cancel];
    
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

#pragma mark - UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    int numRows = [[self photoStream] count];
    
    if(numRows > 0)
    {
        return numRows;
    }
    else
    {
        return 7;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"PhotostreamCell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.detailTextLabel.textAlignment = UITextAlignmentCenter;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    if ([[self photoStream] count] > 0)
	{
        MGPhoto *photoAtIndex = [[self photoStream] objectAtIndex:[indexPath row]];
        
		[[cell textLabel] setText:[photoAtIndex title]];
        [[cell detailTextLabel] setText:[photoAtIndex username]];
        
        if([photoAtIndex thumbnail] != nil)
        {
            [[cell imageView] setImage:[photoAtIndex thumbnail]];
        }
        else
        {
            [[cell imageView] setImage:[UIImage imageNamed:@"Placeholder.png"]];
        }
    }
    else
    {
        [[cell textLabel] setText:@"Loading..."];
        [[cell detailTextLabel] setText:@"Please wait"];
        [[cell imageView] setImage:[UIImage imageNamed:@"Placeholder.png"]];
    }
    
    return cell;
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    NSIndexPath *indexPath = [[self tableView] indexPathForSelectedRow];
    
    if ([[segue identifier] isEqualToString:@"ShowPhotoDetailSegue"])
    {
        MGPhoto *selectedPhoto = [[self photoStream] objectAtIndex:[indexPath row]];
        [[segue destinationViewController] setPhoto:selectedPhoto];
    }
}

#pragma mark Deferred image loading (UIScrollViewDelegate)

// Load images for all onscreen rows when scrolling is finished
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self loadThumbnailsForVisibleRows];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self loadThumbnailsForVisibleRows];
}

- (void)loadThumbnailsForVisibleRows
{
    if ([[self photoStream] count] > 0)
	{
        NSArray *visibleRowPaths = [[self tableView] indexPathsForVisibleRows];
        for (NSIndexPath *indexPath in visibleRowPaths)
        {
            MGPhoto *photoAtIndex = [[self photoStream] objectAtIndex:[indexPath row]];        
            if([photoAtIndex thumbnail] == nil)
            {
                MGThumbnailRequest *thumbnailRequest = [[MGThumbnailRequest alloc] init];
                [thumbnailRequest setMaxRetryCount:1];
                [thumbnailRequest setDelegate:self];
                [thumbnailRequest setPhoto:photoAtIndex];
                [thumbnailRequest setIndexPath:indexPath];
                [thumbnailRequest send];
                [[self openConnections] addObject:thumbnailRequest];
            }
            else
            {
                UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:indexPath];
                [[cell imageView] setImage:[photoAtIndex thumbnail]];
            }
        }
    }
}

#pragma mark - Button, camera, and caption management

- (IBAction)refreshButtonTapped;
{
    if([self streamRequest] == nil)
    {
        [self setStreamRequest:[[MGStreamRequest alloc] init]];
        [[self streamRequest] setDelegate:self];
        [[self streamRequest] send];
    }
}

- (IBAction)cameraButtonTapped;
{
    [self presentCameraController];
}

- (void)uploadNewPhotoWithImageData:(NSData *)jpegData caption:(NSString *)caption;
{
    MGPhoto *newPhoto = [[MGPhoto alloc] init];
    [newPhoto setImage:[UIImage imageWithData:jpegData]];
    [newPhoto setTitle:caption];
    
    MGPostRequest *postRequest = [[MGPostRequest alloc] init];
    [postRequest setMaxRetryCount:1];
    [postRequest setDelegate:self];
    [postRequest setPhoto:newPhoto];
    [postRequest send];
    [[self openConnections] addObject:postRequest];
    [self showUploadProgress];
}

- (void)uploadDidFinish;
{
    // Allow the user to take another photo and stop displaying "upload in progress" feedback
}

- (void)showUploadProgress;
{
    [[self navigationItem] setTitleView:[self uploadProgressView]];
    [[self uploadProgressView] setProgress:0.0f];
    [[[self navigationItem] leftBarButtonItem] setEnabled:NO];
}

- (void)hideUploadProgress;
{
    [[[self navigationItem] leftBarButtonItem] setEnabled:YES];
    [[self navigationItem] setTitleView:nil];
}

- (void)presentCameraController;
{
    // Create an instance of UIImagePickerController to take a new photo
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    // Configure it to use the camera
    imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;

    // Become the delegate of the image picker so we're informed when it has cancelled or taken a new photo
    imagePickerController.delegate = self;
    
    // Create a custom camera overlay view, which we will use to host a caption field if the user takes a new photo
    UIView *overlayView = [[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds];
    overlayView.opaque = NO;
    overlayView.backgroundColor = [UIColor clearColor];

    imagePickerController.cameraOverlayView = overlayView;

    // Present the image picker
    [self presentViewController:imagePickerController animated:YES completion:NULL];
}

#pragma mark - UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info;
{
    // Extract the new image from the picker
    UIImage *photoImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    self.jpegData = UIImageJPEGRepresentation(photoImage, 0.8);

    // Present a caption field to the user

    UINib *captionBarNib = [UINib nibWithNibName:@"MGCaptionBar" bundle:nil];
    [captionBarNib instantiateWithOwner:self options:nil];
    
    // Add drop shadow to set the bar apart from the photo
    self.captionBar.layer.shadowOpacity = 0.5;
    self.captionBar.layer.shadowOffset = CGSizeMake(0, 2);
    self.captionBar.layer.shadowColor = [[UIColor blackColor] CGColor];
    
    // Add the background bar to the overlay
    [picker.cameraOverlayView addSubview:self.captionBar];
    
    // Animate the caption field and bar so that they drop in nicely from the top of the screen as the keyboard is sliding up
    CGRect barFrame = self.captionBar.frame;
    barFrame.origin.y = -barFrame.size.height;
    self.captionBar.frame = barFrame;
    
    [UIView animateWithDuration:0.25 animations:^{
        CGRect animatedBarFrame = barFrame;
        animatedBarFrame.origin.y = 0;
        self.captionBar.frame = animatedBarFrame;
    }];
    
    // Make the caption field first responder, which will give it key focus and bring up the keyboard
    [self.captionField becomeFirstResponder];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker;
{
    [self dismissModalViewControllerAnimated:YES];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField;
{
    // Dismiss the keyboard
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField;
{
    // Dismiss the camera interface
    [self dismissViewControllerAnimated:YES completion:^{
        [self uploadNewPhotoWithImageData:self.jpegData caption:textField.text];
    }];
}

#pragma mark - MGRequestDelegate

- (void)requestDidComplete:(MGRequest *)request
{    
    if([request isKindOfClass:[MGStreamRequest class]])
    {
        NSMutableArray *newPhotoStream = [(MGStreamRequest*)request photoStream];
        // If we don't have a photo stream yet, just take it all
        if([self photoStream] == nil)
        {
            [self setPhotoStream:newPhotoStream];
        }
        else
        {
            NSUInteger newPhotoCount = [newPhotoStream count] - [[self photoStream] count];
            for(NSUInteger i = 0; i < newPhotoCount; i++)
            {
                // Let's make double sure we don't have this photo already
                if(![[self photoStream] containsObject:[newPhotoStream objectAtIndex:i]])
                {
                    [[self photoStream] insertObject:[newPhotoStream objectAtIndex:i] atIndex:i];
                }
            }
        }
        
        [[self tableView] reloadData];
        [self loadThumbnailsForVisibleRows];
        [self setStreamRequest:nil];
    }
    if([request isKindOfClass:[MGThumbnailRequest class]])
    {
        MGThumbnailRequest *thumbnailRequest = (MGThumbnailRequest *)request;
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[thumbnailRequest indexPath]];
        [[cell imageView] setImage:[[thumbnailRequest photo] thumbnail]];
    }
    if([request isKindOfClass:[MGPostRequest class]])
    {
        [self hideUploadProgress];
        [self refreshButtonTapped];
    }
    
    [[self openConnections] removeObject:request];
    request = nil;
}

- (void)requestDidUpdate:(MGRequest *)request
{
    [[self uploadProgressView] setProgress:[request percentComplete]];
}

- (void)requestDidFail:(MGRequest *)request
{
    [request retry];
}

@end
