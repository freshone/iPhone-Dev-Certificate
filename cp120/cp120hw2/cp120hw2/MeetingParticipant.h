//
//  MeetingParticipant.h
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@interface MeetingParticipant : Person {
    BOOL isPresent;
}

- (BOOL)isPresent;
- (void)setIsPresent:(BOOL)inputFlag;

@end
