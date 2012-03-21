//
//  Meeting.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"

@implementation Meeting

@synthesize startDateTime;
@synthesize endDateTime;
@synthesize participantList;
@synthesize undoManager;

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
    self = [super init];
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

- (void)addParticipantWithName:(NSString *)name andHourlyRate:(float)rate {
    Person *temp = [[[Person alloc] init] autorelease];
    [temp setName:name];
    [temp setHourlyPay:rate];
    [temp setUndoManager:self.undoManager];
    [self willChangeValueForKey:@"participantList"];
    [participantList addObject:temp];
    [self didChangeValueForKey:@"participantList"];
}

- (void)insertObject:(Person *)p inParticipantListAtIndex:(int)index
{
    // Add the inverse of this operation to the undo stack
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] removeObjectFromParticipantListAtIndex:index];
    if(![undo isUndoing]) {
        [undo setActionName:@"Insert Person"];
    }
    
    // Add the Person to the array
    [p setUndoManager:self.undoManager];
    [participantList insertObject:p atIndex:index];
}

- (void)removeObjectFromParticipantListAtIndex:(int)index
{
    Person *p = [participantList objectAtIndex:index];
    // Add the inverse of this operation to the undo stack
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] insertObject:p
                                         inParticipantListAtIndex:index];
    if (![undo isUndoing]) {
        [undo setActionName:@"Delete Person"];
    }
    [participantList removeObjectAtIndex:index];
}

@end
