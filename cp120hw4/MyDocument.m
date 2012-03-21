//
//  MyDocument.m
//  cp120hw3
//
//  Created by Jeremy McCarthy on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "MyDocument.h"
#import "PreferenceController.h"

@implementation MyDocument

@synthesize tableView;
@synthesize meeting;
@synthesize beginLabel;
@synthesize endLabel;
@synthesize elapsedLabel;
@synthesize accruedLabel;
@synthesize totalRateLabel;
@synthesize beginButton;
@synthesize endButton;
@synthesize participantArrayController;

- (id)init
{
    self = [super init];
    if (self) {
        meeting = [[Meeting alloc] init];
        [self.undoManager setLevelsOfUndo:100];
        self.meeting.undoManager = self.undoManager;
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

- (IBAction)createMeetingWith2Members:(id)sender {
    [meeting setParticipantList:[NSMutableArray arrayWithCapacity:2]];        
    [[self meeting] addParticipantWithName:@"Spongebob Squarepants" andHourlyRate:10.0f];
    [[self meeting] addParticipantWithName:@"Patrick Star" andHourlyRate:10.0f];
}

- (IBAction)createMeetingWith3Members:(id)sender {
    [meeting setParticipantList:[NSMutableArray arrayWithCapacity:3]];        
    [[self meeting] addParticipantWithName:@"Ingmar Bergman" andHourlyRate:1000.0f];
    [[self meeting] addParticipantWithName:@"Sven Nykvist" andHourlyRate:200.0f];
    [[self meeting] addParticipantWithName:@"Gunnar Björnstrand" andHourlyRate:350.0f];
}

- (IBAction)createMeetingWith4Members:(id)sender {
    [meeting setParticipantList:[NSMutableArray arrayWithCapacity:4]];        
    [[self meeting] addParticipantWithName:@"Jeremy McCarthy" andHourlyRate:12.0f];
    [[self meeting] addParticipantWithName:@"Mike Johnson" andHourlyRate:120.0f];
    [[self meeting] addParticipantWithName:@"Christian Claiborn" andHourlyRate:1200.0f];
    [[self meeting] addParticipantWithName:@"Jeff Bezos" andHourlyRate:9999999.0f];
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
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSData *colorAsData;
    colorAsData = [defaults objectForKey:JDMBgColorKey];
    [tableView setBackgroundColor:[NSKeyedUnarchiver unarchiveObjectWithData:colorAsData]];
}

- (NSData *)dataOfType:(NSString *)aType
                 error:(NSError **)outError
{
    // End editing
    [[tableView window] endEditingFor:nil];
    // Create an NSData object from the employees array
    NSMutableDictionary *rootObject = [NSMutableDictionary dictionary];
    [rootObject setValue:[self meeting] forKey:@"meeting"];
    return [NSKeyedArchiver archivedDataWithRootObject:rootObject];
}

- (BOOL)readFromData:(NSData *)data
              ofType:(NSString *)typeName
               error:(NSError **)outError
{
    NSLog(@"About to read data of type %@", typeName);
    NSDictionary *rootObject = nil;
    
    @try {
        rootObject = [NSKeyedUnarchiver unarchiveObjectWithData:data];
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
    
    [self setMeeting:(Meeting *)[rootObject objectForKey:@"meeting"]];
    return YES;
}

+ (BOOL)autosavesInPlace
{
    return YES;
}

@end
