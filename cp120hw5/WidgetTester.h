//
//  WidgetTester.h
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface WidgetTester : NSObject {
	NSUInteger sampleSize;
	NSMutableArray *testData;
	double sensorMinimum;
	double sensorMaximum;
}

#pragma mark -
#pragma mark properties

@property(nonatomic,assign)NSUInteger sampleSize;
@property(nonatomic,retain)NSMutableArray *testData;
@property(nonatomic,assign)double sensorMinimum;
@property(nonatomic,assign)double sensorMaximum;

- (void)performTest;

- (NSPoint)startingPoint;
- (NSPoint)endingPoint;
- (double)sensorMinimum;
- (double)sensorMaximum;
- (double)timeMinimum;
- (double)timeMaximum;


@end
