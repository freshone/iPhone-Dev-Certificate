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
#import "MGThumbnailRequest.h"
#import <QuartzCore/QuartzCore.h> // Used for specifying the shadow on the caption field background bar

@interface MGPhotostreamController ()
- (IBAction)cameraButtonTapped;
- (IBAction)refreshButtonTapped;

- (void)uploadNewPhotoWithImageData:(NSData *)jpegData caption:(NSString *)caption;
- (void)uploadDidFinish;

- (void)showUploadProgress;
- (void)hideUploadProgress;

@property (nonatomic, strong) IBOutlet UIView *uploadProgressViewContainer;
@property (nonatomic, strong) IBOutlet UIProgressView *uploadProgressView;
@property (nonatomic, strong) NSMutableArray *photoStream;
@property (nonatomic, strong) NSMutableArray *openConnections;

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
@synthesize uploadProgressViewContainer = _uploadProgressViewContainer;
@synthesize uploadProgressView = _uploadProgressView;
@synthesize photoStream = _photoStream;
@synthesize openConnections = _openConnections;

#pragma mark - Initialization

- (id)initWithCoder:(NSCoder *)coder;
{
    if ((self = [super initWithCoder:coder])) {
        // Custom initialization
    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if([[self photoStream] count] == 0)
    {
        MGStreamRequest *streamRequest = [[MGStreamRequest alloc] init];
        [streamRequest setDelegate:self];
        [streamRequest send];
        if([self openConnections] == nil)
        {
            [self setOpenConnections:[[NSMutableArray alloc] init]];
        }
        [[self openConnections] addObject:streamRequest];
    }
    [[self tableView] setRowHeight:60.0f];
    self.clearsSelectionOnViewWillAppear = YES;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
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

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([[self photoStream] count] > 0)
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
            [[cell imageView] setImage:[photoAtIndex thumbnail]];
        }
    }
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

- (IBAction)refreshButtonTapped;
{
#warning Incomplete method implementation
}

- (IBAction)cameraButtonTapped;
{
    [self presentCameraController];
}

- (void)uploadNewPhotoWithImageData:(NSData *)jpegData caption:(NSString *)caption;
{
#warning Incomplete method implementation
    
    // You need to create a POST request here, either directly or indirectly (perhaps using an intermediate object in your model), to upload the new photo to the Minigram server (http://minigram.herokuapp.com/photos.json). Your POST will need to include your Minigram API key, the proper content type header, and a properly encoded request body (including the image, and its metadata, such as the title/caption). To create a multipart form data request, you can use the categories declared in NSMutableData+MGMultipartFormData.h.
}

- (void)uploadDidFinish;
{
    // Allow the user to take another photo and stop displaying "upload in progress" feedback
}

- (void)showUploadProgress;
{
    // Prevent the user from taking another photo and start displaying "upload in progress" feedback
}

- (void)hideUploadProgress;
{
    // Enable camera button
    self.navigationItem.leftBarButtonItem.enabled = YES;
    
    self.navigationItem.titleView = nil;
}

#pragma mark - Camera and caption management

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
    // We always want to remove the request from our queue if it's done
    [[self openConnections] removeObject:request];
    
    if([request isKindOfClass:[MGStreamRequest class]])
    {
        [self setPhotoStream:[(MGStreamRequest*)request photoStream]];
        [[self tableView] reloadData];
    }
    if([request isKindOfClass:[MGThumbnailRequest class]])
    {
        MGThumbnailRequest *thumbnailRequest = (MGThumbnailRequest *)request;
        UITableViewCell *cell = [[self tableView] cellForRowAtIndexPath:[thumbnailRequest indexPath]];
        [[cell imageView] setImage:[[thumbnailRequest photo] thumbnail]];
    }
}

- (void)requestDidFail:(MGRequest *)request
{
    [request retry];
}

@end
