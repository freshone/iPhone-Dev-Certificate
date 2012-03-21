//
//  Meeting.h
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Person.h"

@interface Meeting : NSObject <NSCoding> {
    NSDate *startDateTime;
    NSDate *endDateTime;
    NSMutableArray *participantList;
    NSUndoManager *undoManager;
}

@property (readwrite, retain) NSDate *startDateTime;
@property (readwrite, retain) NSDate *endDateTime;
@property (readwrite, retain) NSMutableArray *participantList;
@property (readwrite, retain) NSUndoManager *undoManager;

- (void)startMeeting;
- (void)stopMeeting;
- (NSTimeInterval)elapsedTime;
- (NSString *)elapsedTimeAsString;
- (float)hourlyMeetingCost;
- (float)accruedCost;
- (void)addParticipantWithName:(NSString *)name andHourlyRate:(float)rate;
- (void)insertObject:(Person *)p inParticipantListAtIndex:(int)index;
- (void)removeObjectFromParticipantListAtIndex:(int)index;

@end
