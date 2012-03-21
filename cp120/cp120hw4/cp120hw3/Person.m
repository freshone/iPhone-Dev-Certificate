//
//  Person.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"

@implementation Person

@synthesize name;
@synthesize hourlyPay;

- (id)init {
    self = [super init];
    if (self) {
        name = @"New Person";
        hourlyPay = 0.0;
    }
    
    return self;
}

- (void)dealloc {
    [name release];
    [super dealloc];
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeFloat:hourlyPay forKey:@"hourlyPay"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    name = [[coder decodeObjectForKey:@"name"] retain];
    hourlyPay = [coder decodeFloatForKey:@"hourlyPay"];
    return self;
}

@end
