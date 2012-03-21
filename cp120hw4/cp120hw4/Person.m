//
//  Person.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Person.h"
#import "PreferenceController.h"

@implementation Person

@synthesize undoManager;

- (id)init {
    self = [super init];
    if (self) {
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSString *defaultName = [defaults objectForKey:JDMParticipantNameKey];
        float defaultPay = [defaults floatForKey:JDMHourlyRateKey];
        name = [[[NSString alloc]initWithString:defaultName]retain];
        hourlyPay = defaultPay;
    }
    
    return self;
}

- (void)dealloc {
    [name release];
    [super dealloc];
}

- (NSString *)name
{
    return name;
}

- (void)setName:(NSString *)newName
{
    NSString *oldName = self.name;
    NSUndoManager *undo = [self undoManager];
    [(Person *)[undo prepareWithInvocationTarget:self] setName:oldName];
    if (![undo isUndoing]) {
        [undo setActionName:@"Change Name"];
    }
    name = [[NSString alloc] initWithString:newName];
}

- (float)hourlyPay
{
    return hourlyPay;
}

- (void)setHourlyPay:(float)newPay
{
    float oldPay = self.hourlyPay;
    NSUndoManager *undo = [self undoManager];
    [[undo prepareWithInvocationTarget:self] setHourlyPay:oldPay];
    if (![undo isUndoing]) {
        [undo setActionName:@"Change Hourly Pay"];
    }
    hourlyPay = newPay;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeFloat:hourlyPay forKey:@"hourlyPay"];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super init];
    name = [[coder decodeObjectForKey:@"name"] retain];
    hourlyPay = [coder decodeFloatForKey:@"hourlyPay"];
    return self;
}

@end
