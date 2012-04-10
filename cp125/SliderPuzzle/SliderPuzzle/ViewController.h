//
//  ViewController.h
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) NSMutableArray *tileModelGrid;
@property (nonatomic, strong) NSMutableArray *tileViewGrid;
- (void)panTile:(UIPanGestureRecognizer *)gestureRecognizer;
@end