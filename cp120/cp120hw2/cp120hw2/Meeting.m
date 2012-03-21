//
//  Meeting.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Meeting.h"
#import "MeetingParticipant.h"

@implementation Meeting

- (id)init {
    self = [super init];
    if (self) {
        participantList = [[NSMutableDictionary alloc] init];
    }
    
    return self;
}

- (void)dealloc {
    [startDateTime release];
    [endDateTime release];
    [participantList release];
}

- (NSDate *)startDateTime {
    return startDateTime;
}

- (NSDate *)endDateTime {
    return endDateTime;
}

- (void)setStartDateTime:(NSDate *)inputDate {
    startDateTime = inputDate;
    [startDateTime retain];
}

- (void)setEndDateTime:(NSDate *)inputDate {
    endDateTime = inputDate;
    [endDateTime retain];
}

- (void)addParticipant:(NSString *)memberId withName:(NSString *)name withHourlyPay:(float)hourlyPay withIsPresent:(BOOL)isPresent {
    MeetingParticipant *newParticipant = [[MeetingParticipant alloc] init];

    [newParticipant setName:name];
    [newParticipant setHourlyPay:hourlyPay];
    [newParticipant setIsPresent:isPresent];
    [participantList setObject:newParticipant forKey:memberId];
    [newParticipant release];
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
    NSArray *roster = [participantList allValues];
    MeetingParticipant *member;
    float totalCost = 0;
    for(member in roster) {
        if([member isPresent]) {
            totalCost += [member hourlyPay];
        }
    }
    return totalCost;
}

- (float)accruedCost {
    return [self hourlyMeetingCost] / 3600 * [self elapsedTime];
}

@end
