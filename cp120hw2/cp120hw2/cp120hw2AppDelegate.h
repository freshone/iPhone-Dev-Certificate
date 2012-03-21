//
//  cp120hw2AppDelegate.h
//  cp120hw2
//
//  Created by Jeremy McCarthy on 10/24/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import "Meeting.h"

@interface cp120hw2AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
    NSButton *beginButton;
    NSButton *endButton;
    NSTextField *beginLabel;
    NSTextField *endLabel;
    NSTextField *elapsedLabel;
    NSTextField *accruedLabel;
    NSTextField *totalRateLabel;
    NSButton *checkBox1;
    NSButton *checkBox2;
    NSButton *checkBox3;
    NSButton *checkBox4;
    NSTextField *nameField1;
    NSTextField *nameField2;
    NSTextField *nameField3;
    NSTextField *nameField4;
    NSTextField *rateField1;
    NSTextField *rateField2;
    NSTextField *rateField3;
    NSTextField *rateField4;
    Meeting *meeting;
    NSTimer *timer;
}

@property (assign) IBOutlet NSWindow *window;
@property (assign) IBOutlet NSButton *beginButton;
@property (assign) IBOutlet NSButton *endButton;
@property (assign) IBOutlet NSTextField *beginLabel;
@property (assign) IBOutlet NSTextField *endLabel;
@property (assign) IBOutlet NSTextField *elapsedLabel;
@property (assign) IBOutlet NSTextField *accruedLabel;
@property (assign) IBOutlet NSTextField *totalRateLabel;
@property (assign) IBOutlet NSButton *checkBox1;
@property (assign) IBOutlet NSButton *checkBox2;
@property (assign) IBOutlet NSButton *checkBox3;
@property (assign) IBOutlet NSButton *checkBox4;
@property (assign) IBOutlet NSTextField *nameField1;
@property (assign) IBOutlet NSTextField *nameField2;
@property (assign) IBOutlet NSTextField *nameField3;
@property (assign) IBOutlet NSTextField *nameField4;
@property (assign) IBOutlet NSTextField *rateField1;
@property (assign) IBOutlet NSTextField *rateField2;
@property (assign) IBOutlet NSTextField *rateField3;
@property (assign) IBOutlet NSTextField *rateField4;

- (IBAction)updateParticipants:(id)sender;
- (IBAction)stopGo:(id)sender;
- (void)updateGUI:(NSTimer *)aTimer;
- (IBAction)dumpDebug:(id)sender;
- (IBAction)beginMeeting:(id)sender;
- (IBAction)endMeeting:(id)sender;

@end
