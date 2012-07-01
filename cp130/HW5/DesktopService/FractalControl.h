//
// IPHONE AND COCOA DEVELOPMENT AUSP10
//	
//  FractalControl.h
//	HW5
//
//  Copyright 2010 Chris Parrish
//
// Class that draws a fractal image and tracks mouse drags
// inside the view to allow 'zooming' in on the displayed fractal
//
// Adapted from Advanced Mac OS X Programming 
// by Mark Dalrymple and Aaron Hillegass 

#import <Cocoa/Cocoa.h>


@interface FractalControl : NSControl


@property (nonatomic, retain)	NSBitmapImageRep*		fractalBitmap;
	// the fractal image to display, represented as a bitmap

@property (assign)				NSRect					region;
	// the region in the complex number space that the view
	// will show the fractal computation for
	// this property changes when the user selects a region in the view
	// the horizontal components of the rect represent the range of the real part	
	// the vertical components of the rect represents the range of the imaginary part

@property (nonatomic, assign)	id						target;
@property (nonatomic, assign)   SEL						action;
	// we need to provide implementations of the target and action
	// properties so we can use IB to set an action for this control
	// in this case the action fires when the user changes the region
	// with a mouse drag in the view

@property (nonatomic, assign)	BOOL					disabled;
	// when disabled, the user cannot drag to change the region

- (void) resetToDefaultRegion;
	// return to the default region that has a nice centered view on the fractal

- (void) zoomIn;
	// adjust the region so that it is zoomed in a bit around its current center

- (void) zoomOut;
	// adjust the region so that it is zoomed out a bit around its current center


@end
