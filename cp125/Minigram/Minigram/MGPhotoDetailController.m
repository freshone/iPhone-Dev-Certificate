//
//  MGPhotoDetailController.m
//  Minigram
//
//  Created by Luke Adamson on 2/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGPhotoDetailController.h"
#import "MGImageRequest.h"

@interface MGPhotoDetailController ()
@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIProgressView *downloadProgressView;
@property (nonatomic, strong) MGImageRequest *imageRequest;
- (void)showDownloadProgress;
- (void)hideDownloadProgress;
@end

@implementation MGPhotoDetailController

@synthesize photo = _photo;
@synthesize imageView = _imageView;
@synthesize downloadProgressView = _downloadProgressView;
@synthesize imageRequest = _imageRequest;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if(self)
    {

    }
    return self;
}

- (void)didReceiveMemoryWarning
{
    NSLog(@"didReceiveMemoryWarning DETAIL");
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    [[self parentViewController] didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

/*
// Implement loadView to create a view hierarchy programmatically, without using a nib.
- (void)loadView
{
}
*/

// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad
{
    [super viewDidLoad];
    if([[self photo] image] == nil)
    {
        [self setImageRequest:[[MGImageRequest alloc] init]];
        [[self imageRequest] setMaxRetryCount:2];
        [[self imageRequest] setDelegate:self];
        [[self imageRequest] setPhoto:[self photo]];
        [self showDownloadProgress];
        [[self imageRequest] send];
    }
    else
    {
        [[self imageView] setImage:[[self photo] image]];
        [[self imageView] setNeedsDisplay];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    [[self imageRequest] cancel];
    [self setImageRequest:nil];
}

- (void)showDownloadProgress
{
    [self setDownloadProgressView:[[UIProgressView alloc] initWithProgressViewStyle:UIProgressViewStyleBar]];
    [[self navigationItem] setTitleView:[self downloadProgressView]];
    [[self downloadProgressView] setProgress:0.0f];
    [[[self navigationItem] leftBarButtonItem] setEnabled:NO];
}

- (void)hideDownloadProgress
{
    [[[self navigationItem] leftBarButtonItem] setEnabled:YES];
    [[self navigationItem] setTitleView:nil];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - MGRequestDelegate

- (void)requestDidComplete:(MGRequest *)request
{
    if([request isKindOfClass:[MGImageRequest class]])
    {
        [[self imageView] setImage:[[self photo] image]];
        [[self imageView] setNeedsDisplay];
        [self hideDownloadProgress];
    }
    
    [self setImageRequest:nil];
}

- (void)requestDidUpdate:(MGRequest *)request
{
    [[self downloadProgressView] setProgress:[request percentComplete]];
}

- (void)requestDidFail:(MGRequest *)request
{
    [request retry];
}

@end
