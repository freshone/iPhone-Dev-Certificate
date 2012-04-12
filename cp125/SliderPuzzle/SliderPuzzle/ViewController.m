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

static const NSUInteger GRID_SIZE = 3;
static const NSUInteger TILE_SIZE = 100;
static const NSUInteger GAP_SIZE = 5;

#pragma mark - Load/Unload View

- (void)viewDidLoad
{
    [super viewDidLoad];

    UIImage *tileImage = [UIImage imageNamed:@"yellow-tile.png"];
    
    for(int i = 0; i < GRID_SIZE * GRID_SIZE - 1; i++)
    {
        UIImageView *newView = [[UIImageView alloc] initWithImage:tileImage];
        [newView setUserInteractionEnabled:YES];
        CGFloat x = (i % GRID_SIZE) * TILE_SIZE + (i % GRID_SIZE) * GAP_SIZE;
        CGFloat y = (i / GRID_SIZE) * TILE_SIZE + (i / GRID_SIZE) * GAP_SIZE;
        [newView setFrame:CGRectMake(x, y, TILE_SIZE, TILE_SIZE)];
        
        UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTile:)];
        [panGesture setMaximumNumberOfTouches:2];
        [panGesture setDelegate:self];        
        [newView addGestureRecognizer:panGesture];
        
        // Add tile to main view
        [[self view] addSubview:newView];
    }
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
