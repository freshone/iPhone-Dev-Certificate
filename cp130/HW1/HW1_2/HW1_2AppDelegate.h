//
//  HW1_2AppDelegate.h
//  HW1_2
//
//  Created by 23 on 3/28/10.
//  Copyright 2010 RogueSheep. All rights reserved.
//

#import <Cocoa/Cocoa.h>
#import <Quartz/Quartz.h>

@interface HW1_2AppDelegate : NSObject <NSApplicationDelegate>
{
    NSWindow*					window_;
	IKImageBrowserView*			imageBrowserView_;
	NSTextField*				timeTextField_;
	
	NSMutableArray*				images_;
}

@property (assign) IBOutlet NSWindow*			window;
@property (assign) IBOutlet IKImageBrowserView* imageBrowserView;
@property (assign) IBOutlet NSTextField*		timeTextField;

- (IBAction) loadButtonPress:(id)sender;
- (IBAction) displayButtonPressed:(id)sender;

@end
