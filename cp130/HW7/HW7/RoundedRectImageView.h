//
//  RoundedRectImageView.h
//  HW7
//
//  Created by Jeremy McCarthy on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RoundedRectImageView : UIView
@property (strong, nonatomic) UIImage *image;
@property (assign) CGFloat cornerRadius;
@property (assign) CGFloat borderWidth;
@end
