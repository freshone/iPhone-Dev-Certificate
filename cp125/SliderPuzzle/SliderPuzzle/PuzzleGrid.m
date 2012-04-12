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
@synthesize size = _size;

- (void)generateWithSize:(NSUInteger)columns
{
    [self setPuzzlePieces:[NSMutableArray arrayWithCapacity:columns]];
    [self setSize:columns];
    
    for(NSUInteger i = 0; i < columns * columns; i++)
    {
        [[self puzzlePieces] addObject:[NSNumber numberWithInteger:i]];
    }

    [self shuffle];
}

- (void)shuffle
{
    // Sort the array randomly
    srand(clock());
    [[self puzzlePieces] sortUsingComparator:^(id a, id b)
     {
         return ((rand() % 3) - 1);
     }];
}

- (BOOL)canMovePieceAtIndex:(NSUInteger)index
{
    return YES;
}

- (BOOL)movePieceFromIndex:(NSUInteger)currentIndex toIndex:(NSUInteger)destinationIndex
{
    return YES;
}

- (BOOL)isSolved
{
    return NO;
}

@end
