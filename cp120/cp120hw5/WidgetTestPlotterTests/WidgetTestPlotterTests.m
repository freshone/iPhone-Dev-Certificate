//
//  WidgetTestPlotterTests.m
//  WidgetTestPlotterTests
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import "WidgetTestPlotterTests.h"
#import "WidgetTester.h"

@implementation WidgetTestPlotterTests

- (void)setUp
{
    [super setUp];
    
    // Set-up code here.
}

- (void)tearDown
{
    // Tear-down code here.
    
    [super tearDown];
}

- (void)testProduction
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    
    STAssertTrue((oscilloscope.sampleSize > 0), @"WidgetTester has no points");
}

- (void)testVoltageBounds
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    
    STAssertTrue((oscilloscope.sensorMaximum >= oscilloscope.sensorMinimum), 
                 @"reported sensor minimum %f greater than reported sensor maximum %f",
                 oscilloscope.sensorMaximum, oscilloscope.sensorMinimum);
}

- (void)testTimeBounds
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    
    STAssertTrue((oscilloscope.timeMaximum >= oscilloscope.timeMinimum), 
                 @"reported time minimum %f greater than reported time maximum %f",
                 oscilloscope.timeMaximum, oscilloscope.timeMinimum);
}

- (void)testVoltageIsInRange
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    for (id pointData in oscilloscope.testData) {
        NSPoint point = [pointData pointValue];
        STAssertTrue((point.y <= oscilloscope.sensorMaximum), 
                     @"found point with sensor value exceeding reported maximum");
        STAssertTrue((point.y >= oscilloscope.sensorMinimum), 
                     @"found point with sensor value below reported minimum");
    }
}

- (void)testTimesAreInRange
{
    WidgetTester *oscilloscope = [[[WidgetTester alloc] init] autorelease];
    [oscilloscope.testData enumerateObjectsUsingBlock:^(id pointData, NSUInteger idx, BOOL *stop) {
        NSPoint point = [pointData pointValue];
        STAssertTrue((point.x <= oscilloscope.timeMaximum), 
                     @"found point with time value exceeding reported maximum");
        STAssertTrue((point.x >= oscilloscope.timeMinimum), 
                     @"found point with time value below reported minimum");
    }];
}
@end
