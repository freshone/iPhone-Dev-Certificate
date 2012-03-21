//
//  MyDocument.h
//  cp120hw3
//
//  Created by Jeremy McCarthy on 10/29/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Meeting.h"
#import "Person.h"

@interface MyDocument : NSDocument {
    Meeting *meeting;
    NSTimer *timer;
    NSTextField *beginLabel;
    NSTextField *endLabel;
    NSTextField *elapsedLabel;
    NSTextField *accruedLabel;
    NSTextField *totalRateLabel;
    NSButton *beginButton;
    NSButton *endButton;
    NSArrayController *participantArrayController;
    NSTableView *tableView;
}

@property (readwrite, retain) Meeting *meeting;
@property (assign) IBOutlet NSTableView *tableView;
@property (assign) IBOutlet NSTextField *beginLabel;
@property (assign) IBOutlet NSTextField *endLabel;
@property (assign) IBOutlet NSTextField *elapsedLabel;
@property (assign) IBOutlet NSTextField *accruedLabel;
@property (assign) IBOutlet NSTextField *totalRateLabel;
@property (assign) IBOutlet NSButton *beginButton;
@property (assign) IBOutlet NSButton *endButton;
@property (assign) IBOutlet NSArrayController *participantArrayController;

- (IBAction)stopGo:(id)sender;
- (void)updateGUI:(NSTimer *)aTimer;
- (IBAction)dumpDebug:(id)sender;
- (IBAction)beginMeeting:(id)sender;
- (IBAction)endMeeting:(id)sender;
- (IBAction)createMeetingWith2Members:(id)sender;
- (IBAction)createMeetingWith3Members:(id)sender;
- (IBAction)createMeetingWith4Members:(id)sender;

@end