//
//  RoundedRectImageView.m
//  HW7
//
//  Created by Jeremy McCarthy on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "RoundedRectImageView.h"

@interface RoundedRectImageView ()
@property (assign) CGPathRef roundedPath;
@end

@implementation RoundedRectImageView
@synthesize image = _image;
@synthesize cornerRadius = _cornerRadius;
@synthesize roundedPath = _roundedPath;
@synthesize borderWidth = _borderWidth;

- (void)dealloc
{
    CFRelease([self roundedPath]);
}

- (void)drawRect:(CGRect)rect
{
    CGRect frame = [self frame];
	CGRect border = CGRectMake(20.0f, 10.0f,
                               frame.size.width - 40.0f,
                               frame.size.height - 45.0f);
    CGRect shadow = CGRectMake(20.0f - floor([self borderWidth] / 2), 15.0f,
                               frame.size.width - 40.0f + [self borderWidth],
                               frame.size.height - 45.0f + floor([self borderWidth] / 2));

    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // Draw shadow
    [self setRoundedPath:[[UIBezierPath bezierPathWithRoundedRect:shadow cornerRadius:[self cornerRadius]] CGPath]];
    CGContextAddPath(context, [self roundedPath]);
    CGContextSetFillColorWithColor(context, [[UIColor colorWithRed:0.3f green:0.3f blue:0.3f alpha:0.8f] CGColor]);
    CGContextFillPath(context);
    
    // Draw border
    [self setRoundedPath:[[UIBezierPath bezierPathWithRoundedRect:border cornerRadius:[self cornerRadius]] CGPath]];
    CGContextAddPath(context, [self roundedPath]);
    CGContextSetStrokeColorWithColor(context, [[UIColor colorWithRed:0.7f green:0.1f blue:0.1f alpha:1.0f] CGColor]);
    CGContextSetLineWidth(context, [self borderWidth]);
    CGContextStrokePath(context);
    
    // Draw image
    CGContextSaveGState(context);
    CGContextAddPath(context, [self roundedPath]);
    CGContextClip(context);
    [[self image] drawInRect:border];
    CGContextRestoreGState(context);
}

@end
