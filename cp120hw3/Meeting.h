//
//  Meeting.h
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Meeting : NSObject {
    NSDate *startDateTime;
    NSDate *endDateTime;
    NSMutableArray *participantList;
}

@property (readwrite, retain) NSDate *startDateTime;
@property (readwrite, retain) NSDate *endDateTime;
@property (readwrite, retain) NSMutableArray *participantList;

- (void)startMeeting;
- (void)stopMeeting;
- (NSTimeInterval)elapsedTime;
- (NSString *)elapsedTimeAsString;
- (float)hourlyMeetingCost;
- (float)accruedCost;

@end
