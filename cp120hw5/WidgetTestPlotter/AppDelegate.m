//
//  AppDelegate.m
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import "AppDelegate.h"
#import "KeyStrings.h"
#import "WidgetTester.h"
#import "WidgetTestRunView.h"

@implementation AppDelegate

@synthesize window;
@synthesize widgetTester;

- (void)dealloc
{
    [super dealloc];
}

NSString *drawingStyleKey = @"drawingStyle";

+ (void)initialize
{
	LogMethod();
	NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
	[defaultValues setObject:[NSNumber numberWithInt:0] forKey:drawingStyleKey];
	
	[[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification {
	stylePicker.selectedSegment = [[NSUserDefaults standardUserDefaults] integerForKey:drawingStyleKey];
	self.widgetTester = [[[WidgetTester alloc] init] autorelease];
	[testView setNeedsDisplay:YES];
}

- (IBAction)changeDrawingStyle:(id)sender
{
	LogMethod();
	[[NSUserDefaults standardUserDefaults] setInteger:stylePicker.selectedSegment 
											   forKey:drawingStyleKey];
	[testView setNeedsDisplay:YES];
}

- (IBAction)performNewTest:(id)sender
{
	LogMethod();
	[self.widgetTester performTest];
	[testView setNeedsDisplay:YES];
}

@end
