//
//  AppController.m
//  cp120hw4
//
//  Created by Jeremy McCarthy on 11/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "AppController.h"
#import "PreferenceController.h"

@implementation AppController

+ (void)initialize
{
    // Create a dictionary
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    // Archive the color object
    NSData *colorAsData = [NSKeyedArchiver archivedDataWithRootObject:
                           [NSColor yellowColor]];
    NSNumber *payRate = [NSNumber numberWithFloat:10.0f];
    NSString *name = [NSString stringWithString:@"New Participant"];    
    
    // Put defaults in the dictionary
    [defaultValues setObject:colorAsData forKey:JDMBgColorKey];
    [defaultValues setObject:payRate forKey:JDMHourlyRateKey];
    [defaultValues setObject:name forKey:JDMParticipantNameKey];
    
    // Register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (IBAction)showPreferencePanel:(id)sender
{
    if (!preferenceController) {
        preferenceController = [[PreferenceController alloc] init];
    }
    [preferenceController showWindow:self];
}

@end