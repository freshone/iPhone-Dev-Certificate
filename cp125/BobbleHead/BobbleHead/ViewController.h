//
//  ViewController.h
//  BobbleHead
//
//  Created by Jeremy McCarthy on 1/28/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMotion/CoreMotion.h>

@interface ViewController : UIViewController {
    NSArray* headImages;
    CGPoint headPosition;
    CGPoint headOriginPosition;
    UIImage* dominicHeadImage;
    UIImage* harrisonHeadImage;
    CMMotionManager* motionManager;
    NSTimer *timer;
}

@property (nonatomic, retain) IBOutlet UIImageView *headImageView;
@property (nonatomic, retain) IBOutlet UISegmentedControl *headSegmentedControl;

- (IBAction)changeHeadImage:(id)sender;
@end
