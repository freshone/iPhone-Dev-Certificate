//
//  AppDelegate.h
//  NSTaskExercise
//
//  Created by Jeremy McCarthy on 4/23/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (weak) IBOutlet NSTextField *inputTextField;
@property (unsafe_unretained) IBOutlet NSTextView *outputTextView;
@property (strong) NSTask *lsTask;

- (IBAction)runButtonPushed:(id)sender;

@end
