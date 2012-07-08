//
//  ViewController.m
//  HW7
//
//  Created by Jeremy McCarthy on 7/8/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController
@synthesize imageView = _imageView;
@synthesize cornerRadiusSlider = _cornerRadiusSlider;
@synthesize borderWidthSlider = _borderWidthSlider;

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[self imageView] setImage:[UIImage imageNamed:@"diablo.png"]];
    [[self imageView] setCornerRadius:[[self cornerRadiusSlider] value]];
    [[self imageView] setBorderWidth:[[self borderWidthSlider] value]];
}

- (void)viewDidUnload
{
    [self setImageView:nil];
    [self setCornerRadiusSlider:nil];
    [self setBorderWidthSlider:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (IBAction)cornerRadiusDidChange:(id)sender
{
    [[self imageView] setCornerRadius:[[self cornerRadiusSlider] value]];
    [[self imageView] setNeedsDisplay];
}

- (IBAction)borderWidthDidChange:(id)sender
{
    [[self imageView] setBorderWidth:[[self borderWidthSlider] value]];
    [[self imageView] setNeedsDisplay];
}
@end
