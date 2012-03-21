//
//  WidgetTester.m
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import "WidgetTester.h"


@implementation WidgetTester

#pragma mark -
#pragma mark properties

@synthesize sampleSize;
@synthesize testData;
@synthesize sensorMinimum;
@synthesize sensorMaximum;

#pragma mark -
#pragma mark initializers / destructors

// init
- (id)init
{
    if (self = [super init]) {
        self.sampleSize = 50;
		[self performTest];
    }
    return self;
}


//=========================================================== 
// dealloc
//=========================================================== 
- (void)dealloc
{
    self.testData = nil;
	
    [super dealloc];
}

#pragma mark -
#pragma mark data simulation

- (void)performTest
{
	NSUInteger i;
	NSPoint p;
	double timeIncrement = 0.1;
	double startingTime = 10.0;
	double sensorValueMean = 13.2;
	int sensorValueRange = 8;
	
	self.sensorMinimum = sensorValueMean + sensorValueRange;
	self.sensorMaximum = sensorValueMean - sensorValueRange;
    
	self.testData = [NSMutableArray arrayWithCapacity:self.sampleSize];
	for (i = 0; i < self.sampleSize; i++) {
		p.x = startingTime + timeIncrement * i;
		p.y = sensorValueMean - sensorValueRange/2. + ((double)rand()/(double)RAND_MAX * sensorValueRange);
		self.sensorMinimum = MIN(p.y, self.sensorMinimum);
		self.sensorMaximum = MAX(p.y, self.sensorMaximum);
		[self.testData addObject:[NSValue valueWithPoint:p]];
		// Have to use NSValue to convert from C struct (the NSPoint) to something that an NSArray can store.
		// To retrieve it, use something like 
		// NSPoint thePoint = [[testData objectAtIndex:0] pointValue];
	}
//	MyLog(@"%@", self.testData);
//	MyLog(@"sensor range %f to %f", self.sensorMinimum, self.sensorMaximum);
}

- (NSPoint)startingPoint
{
	return [(NSValue *)[self.testData objectAtIndex:0] pointValue];
}

- (NSPoint)endingPoint
{
	return [(NSValue *)[self.testData lastObject] pointValue];
}

- (double)timeMinimum
{
	return self.startingPoint.x;
}
- (double)timeMaximum 
{
	return self.endingPoint.x;	
}

@end
