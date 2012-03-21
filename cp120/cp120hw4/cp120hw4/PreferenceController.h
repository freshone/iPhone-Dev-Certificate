//
//  PreferenceController.h
//  cp120hw4
//
//  Created by Jeremy McCarthy on 11/14/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

extern NSString * const JDMBgColorKey;
extern NSString * const JDMHourlyRateKey;
extern NSString * const JDMParticipantNameKey;

@interface PreferenceController : NSWindowController {
    IBOutlet NSColorWell *colorWell;
    IBOutlet NSTextField *hourlyRateField;
    IBOutlet NSTextField *participantNameField;
}

- (NSColor *)bgColor;
- (float)hourlyRate;
- (NSString *)participantName;

- (IBAction)changeBgColor:(id)sender;
- (IBAction)changeHourlyRate:(id)sender;
- (IBAction)changeParticipantName:(id)sender;

@end