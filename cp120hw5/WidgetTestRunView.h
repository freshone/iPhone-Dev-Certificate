//
//  WidgetTestRunView.h
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WidgetTester;
@interface WidgetTestRunView : NSView {
	NSImage *thumbnailImage;
	BOOL shouldDrawMouseInfo;
	NSPoint mousePositionViewCoordinates;
}

- (WidgetTester *)oscilloscope;
@property(nonatomic,retain)NSImage *thumbnailImage;
@property (nonatomic) BOOL shouldDrawMouseInfo;
@property (nonatomic) NSPoint mousePositionViewCoordinates;

- (void)setUpThumbnailAndFullImageForPasteboard:(NSPasteboard *)pb;
- (NSBitmapImageRep *)myBitmapImageRepresentation;

@end
