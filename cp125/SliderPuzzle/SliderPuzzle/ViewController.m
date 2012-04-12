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
- (void)generateGridViews;
- (void)panTile:(UIPanGestureRecognizer *)gestureRecognizer;
@end

@implementation ViewController

@synthesize puzzleGrid = _puzzleGrid;
@synthesize viewGrid = _tileViewGrid;

static const NSUInteger GRID_SIZE = 3;
static const NSUInteger TILE_SIZE = 100;
static const NSUInteger GAP_SIZE = 5;

#pragma mark - Load/Unload View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPuzzleGrid:[[PuzzleGrid alloc] init]];
    [[self puzzleGrid] generateWithSize:GRID_SIZE];
    [self generateGridViews];
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

- (void)generateGridViews
{
    UIImage *tileImage = [UIImage imageNamed:@"yellow-tile.png"];
    
    for(NSUInteger i = 0; i < GRID_SIZE * GRID_SIZE - 1; i++)
    {
        UIImageView *newTileView = [[UIImageView alloc] initWithImage:tileImage];
        CGFloat x = (i % GRID_SIZE) * TILE_SIZE + (i % GRID_SIZE) * GAP_SIZE;
        CGFloat y = (i / GRID_SIZE) * TILE_SIZE + (i / GRID_SIZE) * GAP_SIZE;
        [newTileView setFrame:CGRectMake(x, y, TILE_SIZE, TILE_SIZE)];
        [newTileView setUserInteractionEnabled:YES];

        UILabel *newTileLabel = [[UILabel alloc] init];
        [newTileLabel setFrame:CGRectMake(TILE_SIZE/2-8, TILE_SIZE/2-8, 24, 24)];
        [newTileLabel setText:[NSString stringWithFormat:@"%d", i]];
        [newTileLabel setFont:[UIFont fontWithName:@"DBLCDTempBlack" size:24.0f]];
        [newTileLabel setTextColor:[UIColor greenColor]];
        [newTileLabel setBackgroundColor:[UIColor clearColor]];
        [newTileLabel setShadowColor:[UIColor blackColor]];
        [newTileLabel setShadowOffset:CGSizeMake(2.0f, 2.0f)];
        [newTileView addSubview:newTileLabel];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTile:)];
        [panGesture setMaximumNumberOfTouches:2];
        [panGesture setDelegate:self];        
        [newTileView addGestureRecognizer:panGesture];
        
        // Add tile to main view and save in our grid container
        [[self view] addSubview:newTileView];
        [[self viewGrid] addObject:newTileView];
    }
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
