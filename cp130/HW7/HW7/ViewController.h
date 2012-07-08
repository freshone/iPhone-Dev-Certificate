//
//  ViewController.h
//  HW7
//
//  Created by Jeremy McCarthy on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RoundedRectImageView.h"

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet RoundedRectImageView *imageView;
@property (weak, nonatomic) IBOutlet UISlider *cornerRadiusSlider;
@property (weak, nonatomic) IBOutlet UISlider *borderWidthSlider;
- (IBAction)cornerRadiusDidChange:(id)sender;
- (IBAction)borderWidthDidChange:(id)sender;
@end
