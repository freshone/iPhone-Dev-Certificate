//
//  ViewController.m
//  BobbleHead
//
//  Created by Jeremy McCarthy on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize headImageView;
@synthesize headSegmentedControl;

static CGFloat UPDATE_INTERVAL = 1.0f/60; 

- (IBAction)changeHeadImage:(id)sender
{
    NSInteger index = [headSegmentedControl selectedSegmentIndex];
    NSInteger headCount = [headImages count];
    
    if(index >= 0 && index < headCount)
        [headImageView setImage:[headImages objectAtIndex:index]];    
}

- (void)updateHeadPostion:(NSTimer *)aTimer {
    CMAcceleration acceleration = motionManager.accelerometerData.acceleration;
    NSLog(@"x = %f | y = %f | z = %f\n", acceleration.x, acceleration.y, acceleration.z);
    
    // reset head to the origin
    headPosition = headOriginPosition;
    
    // calculate the new position
    headPosition.x += roundf(acceleration.x * 150);
    headPosition.y += roundf(-acceleration.y * 150);
    
    // set a lower bound on y axis
    headPosition.y = fminf(headPosition.y, headOriginPosition.y + 20.0);
    
    // draw
    headImageView.center = headPosition;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Release any cached data, images, etc that aren't in use.
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];

    // initialize images
    dominicHeadImage = [UIImage imageNamed:@"dominic.png"];
    harrisonHeadImage = [UIImage imageNamed:@"harrison.png"];
    headImages = [[NSArray arrayWithObjects:dominicHeadImage, harrisonHeadImage, nil] retain];
    [self changeHeadImage:headSegmentedControl];
    headOriginPosition = headPosition = headImageView.center;
    
    // initialize motion
    motionManager = [[[CMMotionManager alloc] init] retain];
    motionManager.accelerometerUpdateInterval = UPDATE_INTERVAL;
    [motionManager startAccelerometerUpdates];
    
    // initialize simulation timer
    timer = [[NSTimer scheduledTimerWithTimeInterval:UPDATE_INTERVAL
                                              target:self
                                            selector:@selector(updateHeadPostion:)
                                            userInfo:nil
                                             repeats:YES] retain];
}

- (void)viewDidUnload
{
    [self setHeadImageView:nil];
    [self setHeadSegmentedControl:nil];
    [headImages release];
    [timer release];
    
    // turn off motion
    [motionManager stopAccelerometerUpdates];
    [motionManager release];
    motionManager = nil;
    
    // invalidate and release the timer
    [timer invalidate];
    [timer release];
    timer = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // don't ever rotate, just keep bobblin'
    return NO;
    
    // Return YES for supported orientations
    //return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

@end
