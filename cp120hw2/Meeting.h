//
//  Meeting.h
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject {
    NSDate* startDateTime;
    NSDate* endDateTime;
    NSMutableDictionary* participantList;
}

- (NSDate *)startDateTime;
- (NSDate *)endDateTime;
- (void)setStartDateTime:(NSDate *)inputDate;
- (void)setEndDateTime:(NSDate *)inputDate;
- (void)addParticipant:(NSString *)memberId withName:(NSString *)name withHourlyPay:(float)hourlyPay withIsPresent:(BOOL)isPresent;
- (void)startMeeting;
- (void)stopMeeting;
- (NSTimeInterval)elapsedTime;
- (NSString *)elapsedTimeAsString;
- (float)hourlyMeetingCost;
- (float)accruedCost;

@end
