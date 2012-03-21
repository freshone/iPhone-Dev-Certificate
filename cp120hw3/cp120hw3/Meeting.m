//
//  Meeting.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"
#import "Person.h"

@implementation Meeting

@synthesize startDateTime;
@synthesize endDateTime;
@synthesize participantList;

- (id)init {
    self = [super init];
    if (self) {
        participantList = [[NSMutableArray alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [startDateTime release];
    [endDateTime release];
    [participantList release];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:startDateTime forKey:@"startDateTime"];
    [coder encodeObject:endDateTime forKey:@"endDateTime"];
    [coder encodeObject:participantList forKey:@"participantList"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    [super init];
    startDateTime = [[coder decodeObjectForKey:@"startDateTime"] retain];
    endDateTime = [[coder decodeObjectForKey:@"endDateTime"] retain];
    participantList = [[coder decodeObjectForKey:@"participantList"] retain];
    return self;
}

- (void)startMeeting {
    [self setEndDateTime:nil];
    [self setStartDateTime:[NSDate date]];
}

- (void)stopMeeting {
    [self setEndDateTime:[NSDate date]];    
}

- (NSTimeInterval)elapsedTime {
    if([self startDateTime] == nil) {
        return 0;
    }
    else if([self endDateTime] == nil) {
        return [[self startDateTime] timeIntervalSinceNow] * -1;
    }
    else {
        return [[self startDateTime] timeIntervalSinceDate:[self endDateTime]] * -1;
    }
}

- (NSString *)elapsedTimeAsString {
    NSTimeInterval elapsedTime = [self elapsedTime];
    int hours = (int)elapsedTime / 3600;
    int minutes = (int)elapsedTime % 3600 / 60;
    int seconds = (int)elapsedTime % 60;
    return [NSString stringWithFormat:@"%02i:%02i:%02i", hours, minutes, seconds];
}

- (float)hourlyMeetingCost {
    Person *member;
    float totalCost = 0;
    for(member in participantList) {
        totalCost += [member hourlyPay];
    }
    return totalCost;
}

- (float)accruedCost {
    return [self hourlyMeetingCost] / 3600 * [self elapsedTime];
}

@end
