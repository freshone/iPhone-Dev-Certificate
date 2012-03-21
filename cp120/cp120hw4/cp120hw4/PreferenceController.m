//
//  PreferenceController.m
//  cp120hw4
//
//  Created by Jeremy McCarthy on 11/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"

NSString * const JDMBgColorKey = @"BackgroundColor";
NSString * const JDMHourlyRateKey = @"HourlyRate";
NSString * const JDMParticipantNameKey = @"ParticipantName";

@implementation PreferenceController

- (id)init
{
    if (![super initWithWindowNibName:@"Preferences"])
        return nil;
    return self;
}

- (NSColor *)bgColor
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData = [defaults objectForKey:JDMBgColorKey];
    return [NSKeyedUnarchiver unarchiveObjectWithData:colorAsData];
}

- (float)hourlyRate
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults floatForKey:JDMHourlyRateKey];
}

- (NSString *)participantName
{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    return [defaults objectForKey:JDMParticipantNameKey];
}

- (void)windowDidLoad
{
    [colorWell setColor:[self bgColor]];
    [hourlyRateField setFloatValue:[self hourlyRate]];
    [participantNameField setStringValue:[self participantName]];
}

- (IBAction)changeBgColor:(id)sender
{
    NSColor *color = [colorWell color];
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:color];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:colorAsData forKey:JDMBgColorKey];
}

- (IBAction)changeHourlyRate:(id)sender
{
    float newRate = [hourlyRateField floatValue];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setFloat:newRate forKey:JDMHourlyRateKey];
}

- (IBAction)changeParticipantName:(id)sender
{
    NSString *newName = [NSString stringWithString:[participantNameField stringValue ]];
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:newName forKey:JDMParticipantNameKey];
}


@end

