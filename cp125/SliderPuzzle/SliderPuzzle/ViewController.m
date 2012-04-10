//
//  ViewController.m
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <QuartzCore/QuartzCore.h>

#import "ViewController.h"

@interface ViewController ()

@end

@implementation ViewController

@synthesize tileModelGrid = _tileModelGrid;
@synthesize tileViewGrid = _tileViewGrid;

static const unsigned short GRID_SIZE = 3;
static const unsigned int TILE_SIZE = 100;
static const unsigned int GAP_SIZE = 5;

#pragma mark - Load/Unload View

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *tileImage = [UIImage imageNamed:@"yellow-tile.png"];
    
    UIPanGestureRecognizer *mainViewPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTile:)];
    [mainViewPanGesture setMaximumNumberOfTouches:2];
    [mainViewPanGesture setDelegate:self];
    [[self view] addGestureRecognizer:mainViewPanGesture];
    
    for(int i = 0; i < GRID_SIZE * GRID_SIZE; i++)
    {
        UIImageView *newView = [[UIImageView alloc] initWithImage:tileImage];
        CGFloat x = (i % GRID_SIZE) * TILE_SIZE + (i % GRID_SIZE) * GAP_SIZE;
        CGFloat y = (i / GRID_SIZE) * TILE_SIZE + (i / GRID_SIZE) * GAP_SIZE;
        [newView setFrame:CGRectMake(x, y, TILE_SIZE, TILE_SIZE)];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTile:)];
        [panGesture setMaximumNumberOfTouches:2];
        [panGesture setDelegate:self];        
        [newView addGestureRecognizer:panGesture];
        [mainViewPanGesture requireGestureRecognizerToFail:panGesture];
        
        // Add tile to main view
        [[self view] addSubview:newView];
    }
    
    UIImageView *testView = [[UIImageView alloc] initWithImage:tileImage];
    [testView setFrame:CGRectMake(300,300,100,100)];
    
    UIPanGestureRecognizer *testGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTile:)];
    [testGesture setMaximumNumberOfTouches:2];
    [testGesture setDelegate:self];        
    [testView addGestureRecognizer:testGesture];
    [mainViewPanGesture requireGestureRecognizerToFail:testGesture];
    
    // Add tile to main view
    [[self view] addSubview:testView];
    
    
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

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan) {
        UIView *tile = gestureRecognizer.view;

        CGPoint locationInView = [gestureRecognizer locationInView:tile];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:tile.superview];
        
        tile.layer.anchorPoint = CGPointMake(locationInView.x / tile.bounds.size.width, locationInView.y / tile.bounds.size.height);
        tile.center = locationInSuperview;
    }
}

- (void)panTile:(UIPanGestureRecognizer *)gestureRecognizer
{
    UIView *tile = [gestureRecognizer view];
    
    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];

    if (([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged) )
    {
        CGPoint translation = [gestureRecognizer translationInView:[tile superview]];        
        [tile setCenter:CGPointMake([tile center].x + translation.x, [tile center].y + translation.y)];
        [gestureRecognizer setTranslation:CGPointZero inView:[tile superview]];
    }
}

@end
