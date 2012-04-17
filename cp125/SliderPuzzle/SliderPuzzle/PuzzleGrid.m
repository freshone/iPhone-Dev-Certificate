//
//  PuzzleGrid.m
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "PuzzleGrid.h"

@implementation PuzzleGrid
@synthesize puzzlePieces = _puzzlePieces;
@synthesize numberOfColumns = _numberOfColumns;

- (void)generateWithSize:(NSUInteger)columns
{
    [self setPuzzlePieces:[NSMutableArray arrayWithCapacity:columns * columns]];
    [self setNumberOfColumns:columns];
    
    for(NSUInteger i = 0; i < columns * columns; i++)
    {
        [[self puzzlePieces] addObject:[NSNumber numberWithInteger:i]];
    }
}

- (void)shuffle
{
    do
    {
        // Sort the array randomly
        srand(clock());
        [[self puzzlePieces] sortUsingComparator:^(id a, id b)
         {
             return ((rand() % 2) == 0) ? 1 : -1;
         }];
    // Do it again if we happen to randomly generate a solved puzzle
    } while([self isSolved]);
}

- (PieceMoveDirection)canSlidePieceAtIndex:(NSUInteger)index
{
    NSUInteger blankIndex = [self indexOfBlankTile];
    if((index - [self numberOfColumns]) == blankIndex)
    {
        return Up;
    }
    if((index + [self numberOfColumns]) == blankIndex)
    {
        return Down;
    }
    if((index - 1) == blankIndex)
    {
        return Left;
    }
    if((index + 1) == blankIndex)
    {
        return Right;
    }
    return Locked;
}

- (BOOL)slidePieceAtIndex:(NSUInteger)currentIndex
{
    if([self canSlidePieceAtIndex:currentIndex] != Locked)
    {
        [[self puzzlePieces] exchangeObjectAtIndex:currentIndex withObjectAtIndex:[self indexOfBlankTile]];
        return YES;
    }
    return NO;
}

- (BOOL)isSolved
{
    NSArray *solvedPuzzle = [[self puzzlePieces] sortedArrayUsingSelector:@selector(compare:)];
    return [[self puzzlePieces] isEqualToArray:solvedPuzzle];
}

- (NSUInteger)indexOfTileNumber:(NSUInteger)tileNumber
{
    return [[self puzzlePieces] indexOfObject:[NSNumber numberWithInteger:tileNumber]];
}

- (NSUInteger)indexOfBlankTile
{
    return [self indexOfTileNumber:0];
}

- (NSUInteger)tileNumberAtIndex:(NSUInteger)index;
{
    return [[[self puzzlePieces] objectAtIndex:index] unsignedIntegerValue];
}

@end
