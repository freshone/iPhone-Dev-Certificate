//
//  cp120hw2AppDelegate.m
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "cp120hw2AppDelegate.h"

@implementation cp120hw2AppDelegate

@synthesize window;
@synthesize beginButton;
@synthesize endButton;
@synthesize beginLabel;
@synthesize endLabel;
@synthesize elapsedLabel;
@synthesize accruedLabel;
@synthesize totalRateLabel;
@synthesize checkBox1;
@synthesize checkBox2;
@synthesize checkBox3;
@synthesize checkBox4;
@synthesize nameField1;
@synthesize nameField2;
@synthesize nameField3;
@synthesize nameField4;
@synthesize rateField1;
@synthesize rateField2;
@synthesize rateField3;
@synthesize rateField4;

- (id)init {
    self = [super init];
    if(self) {
        meeting = [[Meeting alloc] init];
    }
    return self;
}

- (void)dealloc {
    [meeting release];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
    [beginLabel setStringValue:@""];
    [endLabel setStringValue:@""];
    [beginButton setEnabled:YES];
    [endButton setEnabled:NO];
}

- (IBAction)updateParticipants:(id)sender {
    [meeting addParticipant:@"1" withName:[nameField1 stringValue] withHourlyPay:[rateField1 floatValue] withIsPresent:[checkBox1 state]]; 
    [meeting addParticipant:@"2" withName:[nameField2 stringValue] withHourlyPay:[rateField2 floatValue] withIsPresent:[checkBox2 state]];
    [meeting addParticipant:@"3" withName:[nameField3 stringValue] withHourlyPay:[rateField3 floatValue] withIsPresent:[checkBox3 state]];
    [meeting addParticipant:@"4" withName:[nameField4 stringValue] withHourlyPay:[rateField4 floatValue] withIsPresent:[checkBox4 state]];
    [totalRateLabel setObjectValue:[NSNumber numberWithFloat:[meeting hourlyMeetingCost]]];
}

- (IBAction)stopGo:(id)sender {
    if (timer == nil) {
        // Create a timer
        timer = [[NSTimer scheduledTimerWithTimeInterval:0.1
                          target:self
                          selector:@selector(updateGUI:)
                          userInfo:nil
                          repeats:YES]
                 retain];
    }
    else {
        // Invalidate and release the timer
        [timer invalidate];
        [timer release];
        timer = nil;
    }
}

- (void)updateGUI:(NSTimer *)aTimer {
    [elapsedLabel setStringValue:[meeting elapsedTimeAsString]];
    [accruedLabel setObjectValue:[NSNumber numberWithFloat:[meeting accruedCost]]];
}

- (IBAction)dumpDebug:(id)sender {
    NSLog(@"startDateTime:\t %@", [[meeting startDateTime] description]);
    NSLog(@"endDateTime:\t\t %@", [[meeting endDateTime] description]);
    NSLog(@"elapsedTime:\t\t %f", [meeting elapsedTime]);
    NSLog(@"hourlyRate:\t\t %f", [meeting hourlyMeetingCost]);
    NSLog(@"accruedCost:\t\t %f", [meeting accruedCost]);
}

- (IBAction)beginMeeting:(id)sender {
    [meeting startMeeting];
    [beginLabel setObjectValue:[meeting startDateTime]];
    [endLabel setStringValue:@"Meeting in Progress..."];
    [beginButton setEnabled:NO];
    [endButton setEnabled:YES];
    [self stopGo:nil];
}

- (IBAction)endMeeting:(id)sender {
    [self stopGo:nil];
    [meeting stopMeeting];
    [endLabel setObjectValue:[meeting endDateTime]];
    [beginButton setEnabled:YES];
    [endButton setEnabled:NO];
}
@end
