//
//  ViewController.m
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tileView = _tileView;

#pragma mark - Load/Unload View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self tileView] setImage:[UIImage imageNamed:@"yellow-tile.png"]];
    
    // Add gestures
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTile:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [[self tileView] addGestureRecognizer:panGesture];
    [[self view] addGestureRecognizer:panGesture];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

#pragma mark - Tile Manipulation

- (void)panTile:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *tile = [gestureRecognizer view];
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged)
    {
        CGPoint translation = [gestureRecognizer translationInView:[tile superview]];        
        [tile setCenter:CGPointMake([tile center].x + translation.x, [tile center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[tile superview]];
    }
}

@end
