//
//  PuzzleGrid.h
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PuzzleGrid : NSObject
@property (nonatomic, strong) NSMutableArray *puzzlePieces;
@property (nonatomic, assign) NSUInteger size;
- (void)generateWithSize:(NSUInteger)columns;
- (void)shuffle;
- (BOOL)canMovePieceAtIndex:(NSUInteger)index;
- (BOOL)movePieceFromIndex:(NSUInteger)currentIndex toIndex:(NSUInteger)destinationIndex;
- (BOOL)isSolved;
@end
