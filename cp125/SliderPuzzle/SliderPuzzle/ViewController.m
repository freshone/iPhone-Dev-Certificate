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
@property (nonatomic, strong) PuzzleGrid *puzzleGrid;
@property (nonatomic, strong) NSMutableArray *viewGrid;
@property (nonatomic, strong) UIImage *tileImage;
- (void)generateGridViews;
- (void)decorateView:(UIImageView*)view forIndex:(NSUInteger)index;
- (void)setFrameForView:(UIView*)view forIndex:(NSUInteger)index;
- (void)addGesturesToView:(UIView*)view;
- (void)panTile:(UIPanGestureRecognizer*)gestureRecognizer;
@end

@implementation ViewController
@synthesize puzzleGrid = _puzzleGrid;
@synthesize viewGrid = _viewGrid;
@synthesize tileImage = _tileImage;

static const NSUInteger GRID_SIZE = 3;
static const NSUInteger TILE_SIZE = 100;
static const NSUInteger GAP_SIZE = 5;
static const NSUInteger TAPS_TO_MOVE = 1;
static NSString* const TILE_IMAGE_FILENAME = @"yellow-tile.png";
static NSString* const LABEL_FONTNAME = @"DBLCDTempBlack";

#pragma mark - Load/Unload View

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setPuzzleGrid:[[PuzzleGrid alloc] init]];
    [[self puzzleGrid] generateWithSize:GRID_SIZE];
    //[[self puzzleGrid] shuffle];
    [self setTileImage:[UIImage imageNamed:@"yellow-tile.png"]];
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
    if([self viewGrid] == nil)
    {
        [self setViewGrid:[NSMutableArray arrayWithCapacity:GRID_SIZE]];
    }
    for(int i = 0; i < GRID_SIZE * GRID_SIZE; i++)
    {
        UIImageView *view = [[UIImageView alloc] init];
        [self decorateView:view forIndex:i];
        [self addGesturesToView:view];
        [[self view] addSubview:view];
        [[self viewGrid] addObject:view];
    }
}

- (void)decorateView:(UIImageView*)view forIndex:(NSUInteger)index
{
    NSUInteger tileNumber = [[self puzzleGrid] tileNumberAtIndex:index];
    
    // The zero tile is our space
    if(tileNumber == 0)
    {
        view = [view initWithImage:nil];
        [self setFrameForView:view forIndex:index];
    }
    else
    {
        view = [view initWithImage:[self tileImage]];
        [self setFrameForView:view forIndex:index];
        [view setUserInteractionEnabled:YES];
        
        UILabel *newTileLabel = [[UILabel alloc] init];
        [view addSubview:newTileLabel];
        [newTileLabel setFrame:CGRectMake(TILE_SIZE/2-12, TILE_SIZE/2-12, 24, 24)];
        [newTileLabel setText:[NSString stringWithFormat:@"%d", tileNumber]];
        [newTileLabel setFont:[UIFont fontWithName:LABEL_FONTNAME size:24.0f]];
        [newTileLabel setTextColor:[UIColor greenColor]];
        [newTileLabel setBackgroundColor:[UIColor clearColor]];
        [newTileLabel setShadowColor:[UIColor blackColor]];
        [newTileLabel setShadowOffset:CGSizeMake(2.0f, 2.0f)];
    }
}

- (void)setFrameForView:(UIView*)view forIndex:(NSUInteger)index
{
    CGFloat x = (index % GRID_SIZE) * TILE_SIZE + (index % GRID_SIZE) * GAP_SIZE;
    CGFloat y = (index / GRID_SIZE) * TILE_SIZE + (index / GRID_SIZE) * GAP_SIZE;
    [view setFrame:CGRectMake(x, y, TILE_SIZE, TILE_SIZE)];
}

- (void)addGesturesToView:(UIView *)view
{
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(panTile:)];
    [panGesture setMaximumNumberOfTouches:2];
    [panGesture setDelegate:self];
    [view addGestureRecognizer:panGesture];
    
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapTile:)];
    [tapGesture setNumberOfTapsRequired:TAPS_TO_MOVE];
    [tapGesture setDelegate:self];
    [view addGestureRecognizer:tapGesture];
}

#pragma mark - Tile Manipulation

- (void)adjustAnchorPointForGestureRecognizer:(UIGestureRecognizer *)gestureRecognizer {
    if (gestureRecognizer.state == UIGestureRecognizerStateBegan)
    {
        UIView *tile = gestureRecognizer.view;

        CGPoint locationInView = [gestureRecognizer locationInView:tile];
        CGPoint locationInSuperview = [gestureRecognizer locationInView:tile.superview];
        
        tile.layer.anchorPoint = CGPointMake(locationInView.x / tile.bounds.size.width, locationInView.y / tile.bounds.size.height);
        tile.center = locationInSuperview;
    }
}

- (void)panTile:(UIPanGestureRecognizer *)gestureRecognizer
{
    static CGPoint originalCenter;
    UIView *tileView = [gestureRecognizer view];
    NSUInteger tileIndex = [[self viewGrid] indexOfObject:tileView];
    PieceMoveDirection direction = [[self puzzleGrid] canSlidePieceAtIndex:tileIndex];    

    [self adjustAnchorPointForGestureRecognizer:gestureRecognizer];

    if (direction != Locked &&
        ([gestureRecognizer state] == UIGestureRecognizerStateBegan ||
        [gestureRecognizer state] == UIGestureRecognizerStateChanged))
    {
        if([gestureRecognizer state] == UIGestureRecognizerStateBegan)
        {
            originalCenter = [tileView center];
        }
        
        CGPoint translation = [gestureRecognizer translationInView:[tileView superview]];
        CGFloat x = originalCenter.x;
        CGFloat y = originalCenter.y;
        
        if((direction == Up && translation.y < originalCenter.y) || (direction == Down && translation.y > originalCenter.y + TILE_SIZE))
        {
            y += translation.y;
            [tileView setCenter:CGPointMake(x, y)];
        }
        if((direction == Left && translation.x < originalCenter.x) || (direction == Right && translation.x > originalCenter.x + TILE_SIZE))
        {
            x += translation.x;
            [tileView setCenter:CGPointMake(x, y)];
        }
    }
}

- (void)tapTile:(UITapGestureRecognizer *)gestureRecognizer
{
    UIView *tileView = [gestureRecognizer view];
    NSUInteger oldIndex = [[self viewGrid] indexOfObject:tileView];
    NSUInteger newIndex = [[self puzzleGrid] indexOfBlankTile];
    UIView *blankView = [[self viewGrid] objectAtIndex:newIndex];
    
    if([[self puzzleGrid] slidePieceAtIndex:oldIndex])
    {
        [[self viewGrid] exchangeObjectAtIndex:oldIndex withObjectAtIndex:newIndex];
        [self setFrameForView:tileView forIndex:newIndex];
        [self setFrameForView:blankView forIndex:oldIndex];
    }
}

- (IBAction)shuffleButtonPushed:(id)sender
{
    for(UIImageView *tileView in [self viewGrid])
    {
        [tileView removeFromSuperview];
    }
    [self setViewGrid:nil];
    [[self puzzleGrid] shuffle];
    [self generateGridViews];
}
@end
