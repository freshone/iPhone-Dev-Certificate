//
//  WidgetTestRunView.m
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import "WidgetTestRunView.h"
#import "AppDelegate.h"
#import "WidgetTester.h"
#import "KeyStrings.h"

@implementation WidgetTestRunView

@synthesize thumbnailImage;
@synthesize shouldDrawMouseInfo;
@synthesize mousePositionViewCoordinates;

// TODO: ask about ...
// FIXME: this doesn't work if ...
// MARK: here a miracle occurs
// !!!: crashes if ...
// ???: what was I thinking?

#pragma mark -
#pragma mark setup and drawing

- (WidgetTester *)oscilloscope
{
    return [(AppDelegate *)[[NSApplication sharedApplication] delegate] widgetTester];
}

- (id)initWithFrame:(NSRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        NSTrackingArea *trackingArea = [[NSTrackingArea alloc] initWithRect:NSZeroRect
                                                                    options:(NSTrackingMouseEnteredAndExited |
                                                                             NSTrackingMouseMoved |
                                                                             NSTrackingActiveAlways |
                                                                             NSTrackingInVisibleRect)
                                                                    owner:self
                                                                    userInfo:nil];
        [self addTrackingArea:trackingArea];
        [trackingArea release];
    }
    return self;
}

- (void)drawRect:(NSRect)dirtyRect {
	NSRect bounds = [self bounds];
	MyLog(@"drawRect: bounds %@", NSStringFromRect(bounds));
	
	double xOffset = [[self oscilloscope]timeMinimum];
    double yOffset = [[self oscilloscope]sensorMinimum];
    double xRange = [[self oscilloscope]timeMaximum] - [[self oscilloscope]timeMinimum];
    double yRange = [[self oscilloscope]sensorMaximum] - [[self oscilloscope]sensorMinimum];
    NSPoint xStart = bounds.origin;
    NSPoint xEnd = bounds.origin;
    xEnd.x += bounds.size.width;    
    NSBezierPath *pointsPath = [NSBezierPath bezierPath];
    
    [pointsPath moveToPoint:xStart];
    
    for(NSValue *pointValue in [[self oscilloscope] testData]) {
        NSPoint dataSpacePoint = [pointValue pointValue];
        NSPoint viewSpacePoint = {
            .x = (dataSpacePoint.x - xOffset) / xRange * bounds.size.width,
            .y = (dataSpacePoint.y - yOffset) / yRange * bounds.size.height
        };
        [pointsPath lineToPoint:viewSpacePoint];
    }
    [pointsPath lineToPoint:xEnd];
    [pointsPath closePath];
    
    NSUInteger drawStyle = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
    switch(drawStyle)
    {
        case 0:
            [[NSColor blueColor]set];
            [NSBezierPath fillRect:bounds];
            [[NSColor greenColor]set];
            [pointsPath fill];
            [[NSColor whiteColor]set];
            [pointsPath stroke];
            break;
        case 1:
            [[NSColor blackColor]set];
            [NSBezierPath fillRect:bounds];
            [[NSColor redColor]set];
            [pointsPath stroke];
            break;
        case 2:
            [[NSColor magentaColor]set];
            [NSBezierPath fillRect:bounds];
            [[NSColor orangeColor]set];
            [pointsPath fill];
            [[NSColor cyanColor]set];
            [pointsPath stroke];
            break;
        default:
            NSLog(@"drawStyle not set correctly. value = %lu", drawStyle);
            break;
    }

	if (self.shouldDrawMouseInfo) {
        NSDictionary *stringAttributes = [NSDictionary dictionaryWithObjectsAndKeys:
                                          [NSColor blackColor], NSForegroundColorAttributeName,
                                          [NSColor whiteColor], NSBackgroundColorAttributeName,
                                          [NSFont fontWithName:@"Verdana-Italic" size:10.0f], NSFontAttributeName,
                                          nil];
        NSPoint mousePositionDataSpace = {
            .x = mousePositionViewCoordinates.x / bounds.size.width * xRange + xOffset,
            .y = mousePositionViewCoordinates.y / bounds.size.height * yRange + yOffset
        };
        
        NSString *mouseString = [NSString stringWithFormat:@"View:(%.0f,%.0f)  Data:(%.1f,%.1f)", self.mousePositionViewCoordinates, mousePositionDataSpace];
        NSAttributedString *mouseDisplayString = [[[NSAttributedString alloc]
                                                   initWithString:mouseString
                                                   attributes:stringAttributes]
                                                  autorelease];
        
        NSPoint drawPoint = self.mousePositionViewCoordinates;
        NSSize stringSize = mouseDisplayString.size;
        if((drawPoint.x + stringSize.width) >= bounds.size.width)
            drawPoint.x -= stringSize.width;
        if((drawPoint.y + stringSize.height) > bounds.size.height)
            drawPoint.y -= stringSize.height;
        [mouseDisplayString drawAtPoint:drawPoint];
	}
}

- (NSBitmapImageRep *)myBitmapImageRepresentation
{
    NSSize size = self.bounds.size;
    [self lockFocus];
    NSBitmapImageRep *result = [[[NSBitmapImageRep alloc] initWithFocusedViewRect:NSMakeRect(0,0,size.width,size.height)] autorelease];
    [self unlockFocus];
    return result;
}

- (void)setUpThumbnailAndFullImageForPasteboard:(NSPasteboard *)pb
{
    NSLog(@"writeToPasteboard %@", pb);
    NSBitmapImageRep *fullImageRepresentation = [self myBitmapImageRepresentation];
    NSLog(@"%@", fullImageRepresentation);
    [pb declareTypes:[NSArray arrayWithObject:NSPasteboardTypeTIFF] owner:self];
    [pb setData:[fullImageRepresentation TIFFRepresentation] forType:NSTIFFPboardType];
    self.thumbnailImage = [[[NSImage alloc] initWithSize:NSMakeSize(100.0, 100.0)] autorelease];
    [[self thumbnailImage] lockFocus];
    NSRect thumbnailBounds;
    thumbnailBounds.origin = NSZeroPoint;
    thumbnailBounds.size = self.thumbnailImage.size;
    [fullImageRepresentation drawInRect:thumbnailBounds];
    [[self thumbnailImage] unlockFocus];
}

#pragma mark -
#pragma mark mouse events
- (void)mouseDragged:(NSEvent *)event
{
	NSLog(@"mouseDragged: %@", NSStringFromPoint(event.locationInWindow));
	NSPoint p = [self convertPoint:[event locationInWindow] fromView:nil];
    NSPasteboard *thePasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [self dragImage:self.thumbnailImage
                 at:p
             offset:NSZeroSize
              event:event
         pasteboard:thePasteboard
             source:self
          slideBack:YES];
}

- (void)mouseDown:(NSEvent *)event
{
	NSLog(@"mouseDown: %@", NSStringFromPoint(event.locationInWindow));
    NSPasteboard *thePasteboard = [NSPasteboard pasteboardWithName:NSDragPboard];
    [self setUpThumbnailAndFullImageForPasteboard:thePasteboard];
}

//- (BOOL)acceptsFirstResponder
//{
//	return YES;
//}
//
// also see (in AppDelegate.m)
//     self.window.acceptsMouseMovedEvents = YES;
// (if not using NSTrackingArea)
// and the setting of initialFirstResponder for the window in MainMenu.xib.

- (void)mouseMoved:(NSEvent *)theEvent
{
	NSLog(@"mouseMoved: %@", NSStringFromPoint(theEvent.locationInWindow));
    if((theEvent.modifierFlags & NSShiftKeyMask) || (theEvent.modifierFlags & NSControlKeyMask)) {
        self.shouldDrawMouseInfo = YES;
        self.mousePositionViewCoordinates = [self convertPoint:theEvent.locationInWindow fromView:nil];
        [self setNeedsDisplay:YES];
    }
    else if(self.shouldDrawMouseInfo) {
        self.shouldDrawMouseInfo = NO;
        [self setNeedsDisplay:YES];
    }
}
- (void)mouseEntered:(NSEvent *)theEvent
{
	NSLog(@"mouseEntered: %@", NSStringFromPoint(theEvent.locationInWindow));
    if(theEvent.modifierFlags & NSShiftKeyMask) {
        self.shouldDrawMouseInfo = YES;
        self.mousePositionViewCoordinates = [self convertPoint:theEvent.locationInWindow fromView:nil];
        [self setNeedsDisplay:YES];
    }
}
- (void)mouseExited:(NSEvent *)theEvent
{
	NSLog(@"mouseExited: %@", NSStringFromPoint(theEvent.locationInWindow));
    if(theEvent.modifierFlags & NSShiftKeyMask) {
        self.shouldDrawMouseInfo = NO;
        self.mousePositionViewCoordinates = [self convertPoint:theEvent.locationInWindow fromView:nil];
        [self setNeedsDisplay:YES];
    }
}

@end
