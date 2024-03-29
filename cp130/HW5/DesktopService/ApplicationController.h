//
// IPHONE AND COCOA DEVELOPMENT AUSP10
//	
//  DesktopServiceAppDelegate.h
//	HW5
//
//  Copyright 2010 Chris Parrish
//
//  App controller is a singleton object

#import <Cocoa/Cocoa.h>
#import "FractalGenerator.h"
#import "ListenerService.h"

@class FractalControl;
@class ListenService;

@interface ApplicationController : NSObject <ListenerServiceDelegate>

- (void) startService;
- (void) appendStringToLog:(NSString*)logString;

@end
