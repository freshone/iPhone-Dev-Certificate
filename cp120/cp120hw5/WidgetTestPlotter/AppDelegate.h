//
//  AppDelegate.h
//  WidgetTestPlotter
//
//  Created by CP120 on 11/8/11.
//  Copyright (c) 2011 Hal Mueller. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@class WidgetTester;
@class WidgetTestRunView;
@interface AppDelegate : NSObject <NSApplicationDelegate> {
    NSWindow *window;
	WidgetTester *widgetTester;
	IBOutlet WidgetTestRunView *testView;
	IBOutlet NSSegmentedControl *stylePicker;
}

@property (assign) IBOutlet NSWindow *window;
@property(nonatomic,retain)WidgetTester *widgetTester;
- (IBAction)changeDrawingStyle:(id)sender;
- (IBAction)performNewTest:(id)sender;

@end
