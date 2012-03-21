//
//  MyDocument.m
//  cp120hw3
//
//  Created by Jeremy McCarthy on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"

@implementation MyDocument

@synthesize meeting;
@synthesize tableView;
@synthesize beginLabel;
@synthesize endLabel;
@synthesize elapsedLabel;
@synthesize accruedLabel;
@synthesize totalRateLabel;
@synthesize beginButton;
@synthesize endButton;

- (id)init
{
    self = [super init];
    if (self) {
        meeting = [[Meeting alloc] init];
    }
    return self;
}

- (void)dealloc
{
    [meeting release];
    [timer release];
    [super dealloc];
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
    //[totalRateLabel setObjectValue:[NSNumber numberWithFloat:[meeting hourlyMeetingCost]]];
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


- (NSString *)windowNibName
{
    // Override returning the nib file name of the document
    // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
    return @"MyDocument";
}

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    [super windowControllerDidLoadNib:aController];
    // Add any code here that needs to be executed once the windowController has loaded the document's window.
}

- (NSData *)dataOfType:(NSString *)aType
                 error:(NSError **)outError
{
    // End editing
    [[tableView window] endEditingFor:nil];
    // Create an NSData object from the employees array
    return [NSKeyedArchiver archivedDataWithRootObject:meeting];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSLog(@"About to read data of type %@", typeName);
    Meeting *newMeeting = nil;
    @try {
        newMeeting = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    }
    @catch (NSException *e) {
        if (outError) {
            NSDictionary *d = [NSDictionary
                               dictionaryWithObject:@"The data is corrupted."
                               forKey:NSLocalizedFailureReasonErrorKey];
            *outError = [NSError errorWithDomain:NSOSStatusErrorDomain
                            code:unimpErr
                            userInfo:d];
        }
        return NO;
    }
    
    [self setMeeting:newMeeting];
    return YES;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
