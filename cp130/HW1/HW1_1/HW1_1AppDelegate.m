//
//  HW1_1AppDelegate.m
//  HW1_1
//
//  Created by 23 on 3/28/10.
//  Copyright 2010 Chris Parrish. All rights reserved.
//

#import "HW1_1AppDelegate.h"

@interface HW1_1AppDelegate ()

@property (assign) IBOutlet NSWindow*		window;
@property (assign) IBOutlet NSTextField*	textField;

- (NSString*) newZeroString;
- (void) reverseStringsInArray:(NSArray*)objects;

@end



@implementation HW1_1AppDelegate

@synthesize window;
@synthesize textField = textField_;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{	
	// Create an array of numbers and strings
	
	NSString* zeroString		= [[self newZeroString] autorelease];
	NSString* fiveString		= [[[NSString alloc] initWithString:@"five"] autorelease];
	NSString* twentyThreeString	= [[[NSString alloc] initWithString:@"twenty three"] autorelease];

	NSArray* numbersAndStrings = [NSArray arrayWithObjects:zeroString,
														   [NSNumber numberWithInt:2],
														   [NSNumber numberWithInt:3],
														   fiveString,
														   twentyThreeString,
														   [NSNumber numberWithInt:117],
														   nil];
	[self reverseStringsInArray:numbersAndStrings];						
}


- (void) reverseStringsInArray:(NSArray*)objects
{
	NSMutableString*	textFieldContent = [NSMutableString string];
	NSMutableString*	reversedString = nil;
	
	for (NSObject* object in objects)
	{
		if ([object isKindOfClass:[NSString class]])
		{
			NSString* stringToReverse = (NSString*)object;
			NSUInteger length = [stringToReverse length];
			
			reversedString = [[NSMutableString alloc] initWithCapacity:length];
			
			for (NSInteger i = length - 1; i >= 0; i--)
			{
				[reversedString appendFormat:@"%C",[stringToReverse characterAtIndex:i]];
			}
		}
		
		if ( reversedString )
		{
			[textFieldContent appendFormat:@"Reversed a string:%@\n", reversedString];
		}
		
		if ( reversedString != nil )
		{
			[reversedString release];
			reversedString = nil;
		}
	}
		
	[textField_ setStringValue:textFieldContent];
	return;
}


- (NSString*) newZeroString
{
	return [[NSString alloc]initWithString:@"zero"];	
}

@end
