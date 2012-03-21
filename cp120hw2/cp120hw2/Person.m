//
//  Person.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person

- (id)init {
    self = [super init];
    if (self) {
        // Initialization code here.
    }
    
    return self;
}

- (NSString *)name {
    return name;
}

- (float)hourlyPay {
    return hourlyPay;
}

- (void)setName:(NSString *)inputName {
    name = inputName;
}

- (void)setHourlyPay:(float)inputHourlyPay {
    hourlyPay = inputHourlyPay;
}


@end
