//
//  AppDelegate.m
//  NSTaskExercise
//
//  Created by Jeremy McCarthy on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

@synthesize window = _window;
@synthesize inputTextField = _inputTextField;
@synthesize lsTask = _lsTask;
@synthesize outputTextView = _outputTextView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    //[[self outputTextView] setFont:[NSFont fontWithName:@"Courier" size:12.0f]];
    //[[self outputTextView] setString:@""];
    //[[self outputTextView] setFont:[NSFont fontWithName:@"Courier" size:12.0f]];
}

- (IBAction)runButtonPushed:(id)sender
{
    NSTask *lsTask = [[NSTask alloc] init];
    NSPipe *outputPipe = [[NSPipe alloc] init];
    [lsTask setLaunchPath:@"/bin/ls"];
    [lsTask setArguments:[NSArray arrayWithObjects:@"-al", [[self inputTextField] stringValue], nil]];
    [lsTask setStandardOutput:outputPipe];
    [lsTask launch];
    [lsTask waitUntilExit];
    NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", outputString);

    [[[self outputTextView] textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:outputString]];
    [[self outputTextView] setFont:[NSFont fontWithName:@"Courier" size:12.0f]];
}

@end