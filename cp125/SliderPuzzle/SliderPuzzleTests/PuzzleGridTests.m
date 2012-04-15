//
//  PuzzleGridTests.m
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/15/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleGridTests.h"

@interface PuzzleGridTests ()
@property (nonatomic, strong) PuzzleGrid *anyPuzzleGrid;
@property (nonatomic, strong) PuzzleGrid *solvedPuzzleGrid;
@property (nonatomic, strong) PuzzleGrid *blankTileInCenterPuzzleGrid;
@end

@implementation PuzzleGridTests
@synthesize anyPuzzleGrid = _anyPuzzleGrid;
@synthesize solvedPuzzleGrid = _solvedPuzzleGrid;
@synthesize blankTileInCenterPuzzleGrid = _blankTileInCenterPuzzleGrid;

static const NSUInteger GRID_SIZE = 3;
static const NSUInteger anyTileNumber = 1;
static const NSUInteger blankTileInCenterTileBelowBlank = 7;
static const NSUInteger blankTileInCenterTileAboveBlank = 1;
static const NSUInteger blankTileInCenterTileLeftBlank = 3;
static const NSUInteger blankTileInCenterTileRightBlank = 5;
static const NSUInteger solvedPuzzleLockedTile = 8;

- (void)setUp
{
    [super setUp];
    
    [self setAnyPuzzleGrid:[[PuzzleGrid alloc] init]];
    [[self anyPuzzleGrid] generateWithSize:GRID_SIZE];
    [[self anyPuzzleGrid] shuffle];
    
    [self setSolvedPuzzleGrid:[[PuzzleGrid alloc] init]];
    [[self solvedPuzzleGrid] generateWithSize:GRID_SIZE];
    
    [self setBlankTileInCenterPuzzleGrid:[[PuzzleGrid alloc] init]];
    [[self blankTileInCenterPuzzleGrid] generateWithSize:GRID_SIZE];
    [[self blankTileInCenterPuzzleGrid] slidePieceAtIndex:1];
    [[self blankTileInCenterPuzzleGrid] slidePieceAtIndex:4];
}

- (void)tearDown
{
    [self setAnyPuzzleGrid:nil];
    [self setSolvedPuzzleGrid:nil];
    [super tearDown];
}

- (void)testGenerateWithSizeCreatesGridWhereNumberOfTilesIsSizeSquared
{
    STAssertEquals([[[self anyPuzzleGrid] puzzlePieces] count], GRID_SIZE * GRID_SIZE, 
                   @"Number of elements in PuzzleGrid was not equal to size squared");
}

- (void)testIsSolvedReturnsTrueForSolvedPuzzle
{
    STAssertTrue([[self solvedPuzzleGrid] isSolved],
                 @"isSolved returned false for a solved puzzle");
}

- (void)testShuffledPuzzleIsNotSolved
{
    [[self anyPuzzleGrid] shuffle];
    STAssertFalse([[self anyPuzzleGrid] isSolved], 
                  @"isSolved returned true for a shuffled puzzle");
}

- (void)testIndexOfTileNumberReturnsTileNumberOnSortedGrid
{
    STAssertEquals([[self solvedPuzzleGrid] indexOfTileNumber:anyTileNumber], anyTileNumber,
                   @"indexOfTileNumber is returning the wrong index");
}

- (void)testTileBelowBlankTileCanSlideUp
{
    STAssertEquals([[self blankTileInCenterPuzzleGrid] canSlidePieceAtIndex:blankTileInCenterTileBelowBlank], Up,
                   @"Tile below blank tile cannot slide up");
}

- (void)testTileBelowBlankTileSlidesUpSuccessfully
{
    STAssertTrue([[self blankTileInCenterPuzzleGrid] slidePieceAtIndex:blankTileInCenterTileBelowBlank],
                 @"Sliding tile below blank tile fails");

}

- (void)testTileAboveBlankTileCanSlideDown
{
    STAssertEquals([[self blankTileInCenterPuzzleGrid] canSlidePieceAtIndex:blankTileInCenterTileAboveBlank], Down,
                   @"Tile above blank tile cannot slide down");
}

- (void)testTileAboveBlankTileSlidesDownSuccessfully
{
    STAssertTrue([[self blankTileInCenterPuzzleGrid] slidePieceAtIndex:blankTileInCenterTileAboveBlank],
                 @"Sliding tile above blank tile fails");    
}

- (void)testTileLeftOfBlankTileCanSlideRight
{
    STAssertEquals([[self blankTileInCenterPuzzleGrid] canSlidePieceAtIndex:blankTileInCenterTileLeftBlank], Right,
                   @"Tile left of blank tile cannot slide right");
}

- (void)testTileLeftOfBlankTileSlidesRightSuccessfully
{
    STAssertTrue([[self blankTileInCenterPuzzleGrid] slidePieceAtIndex:blankTileInCenterTileLeftBlank],
                 @"Sliding tile left of blank tile fails");
}

- (void)testTileRightOfBlankTileCanSlideLeft
{
    STAssertEquals([[self blankTileInCenterPuzzleGrid] canSlidePieceAtIndex:blankTileInCenterTileRightBlank], Left,
                   @"Tile right of blank tile cannot slide left");
}

- (void)testTileRightOfBlankTileSlidesLeftSuccessfully
{
    STAssertTrue([[self blankTileInCenterPuzzleGrid] slidePieceAtIndex:blankTileInCenterTileRightBlank],
                 @"Sliding tile right of blank tile fails");
}

- (void)testLockedTileCannotSlide
{
    STAssertEquals([[self solvedPuzzleGrid] canSlidePieceAtIndex:solvedPuzzleLockedTile], Locked,
                  @"canSlidePieceAtIndex didn't report a locked tile as locked");
}

- (void)testSlidingLockedTileFails
{
    STAssertFalse([[self solvedPuzzleGrid] slidePieceAtIndex:solvedPuzzleLockedTile],
                  @"Sliding locked tile succeeded");
}

@end