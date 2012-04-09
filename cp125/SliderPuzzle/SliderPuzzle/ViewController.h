//
//  ViewController.h
//  SliderPuzzle
//
//  Created by Jeremy McCarthy on 4/9/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UIGestureRecognizerDelegate>
@property (nonatomic, strong) IBOutlet UIImageView *tileView;
- (void)panTile:(UIPanGestureRecognizer *)gestureRecognizer;
@end
