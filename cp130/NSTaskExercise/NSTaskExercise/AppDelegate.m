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
@synthesize outputTextField = _outputTextField;
@synthesize inputTextField = _inputTextField;
@synthesize lsTask = _lsTask;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    // yay
}

- (IBAction)runButtonPushed:(id)sender
{
    NSTask *lsTask = [[NSTask alloc] init];
    NSPipe *outputPipe = [[NSPipe alloc] init];
    [lsTask setLaunchPath:@"/bin/ls"];
    [lsTask setArguments:[NSArray arrayWithObjects:@"-al", @"/Users", nil]];
    [lsTask setStandardOutput:outputPipe];
    [lsTask launch];
    [lsTask waitUntilExit];
    NSData *outputData = [[outputPipe fileHandleForReading] readDataToEndOfFile];
    NSString *outputString = [[NSString alloc] initWithData:outputData encoding:NSUTF8StringEncoding];
    NSLog(@"%@", outputString);
    [[[self outputTextField] textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:outputString]];
}

@end