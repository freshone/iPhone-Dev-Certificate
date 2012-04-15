//
//  PuzzleGrid.h
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum
{
    Locked,
    Up,
    Down,
    Left,
    Right
} PieceMoveDirection;

@interface PuzzleGrid : NSObject
@property (nonatomic, strong) NSMutableArray *puzzlePieces;
@property (nonatomic, assign) NSUInteger numberOfColumns;
- (void)generateWithSize:(NSUInteger)columns;
- (void)shuffle;
- (PieceMoveDirection)canSlidePieceAtIndex:(NSUInteger)index;
- (BOOL)slidePieceAtIndex:(NSUInteger)currentIndex;
- (BOOL)isSolved;
- (NSUInteger)indexOfBlankTile;
- (NSUInteger)indexOfTileNumber:(NSUInteger)tileNumber;
- (NSUInteger)tileNumberAtIndex:(NSUInteger)index;
@end
