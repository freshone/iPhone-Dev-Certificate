//
//  MeetingParticipant.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MeetingParticipant.h"

@implementation MeetingParticipant

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (BOOL)isPresent {
    return isPresent;
}

- (void)setIsPresent:(BOOL)inputFlag {
    isPresent = inputFlag;
}

@end
