//
//  ViewController.h
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PuzzleGrid.h"

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) PuzzleGrid *puzzleGrid;
@property (nonatomic, strong) NSMutableArray *viewGrid;
@end
