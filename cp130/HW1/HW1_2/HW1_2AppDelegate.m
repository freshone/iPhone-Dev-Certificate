//
//  HW1_2AppDelegate.m
//  HW1_2
//
//  Created by 23 on 3/28/10.
//  Copyright 2010 RogueSheep. All rights reserved.
//

#import "HW1_2AppDelegate.h"
#import "SimpleImage.h"
#import <mach/mach_time.h>

const int kImageCount = 500;


@implementation HW1_2AppDelegate

@synthesize window = window_;
@synthesize imageBrowserView = imageBrowserView_;
@synthesize timeTextField = timeTextField_;

- (void) dealloc
{
	[images_ release];
	[super dealloc];
}


- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
}


#pragma mark -
#pragma mark Actions


- (IBAction) loadButtonPress:(id)sender
{
	[images_ release];
	images_ = [[NSMutableArray arrayWithCapacity:kImageCount] retain];
	
	mach_timebase_info_data_t info;
	uint64_t start, end, elapsed;
	mach_timebase_info( &info );
	
	start = mach_absolute_time();
	
	// fill up the image view
	
    NSString* imagePath = [[NSBundle mainBundle] pathForImageResource:@"image.jpg"];
    NSData* imageData = [NSData dataWithContentsOfFile:imagePath options:NSDataReadingUncached error:nil];
    NSImage* sampleImage = [[NSImage alloc] initWithData:imageData];
	for (int i = 0; i < kImageCount; i++) 
	{
        NSString* imageUID = [NSString stringWithFormat:@"%d", i];
        SimpleImage* image = [[[SimpleImage alloc] initWithImage:sampleImage andImageUID:imageUID] autorelease];
        [images_ addObject:image];
	}
    [sampleImage release];
	
	end = mach_absolute_time();
	
	elapsed = end - start;
	float millis = elapsed * (info.numer / info.denom) * pow(10.0f, -6.0f);
	
	[timeTextField_ setStringValue:[NSString stringWithFormat:@"%5.2f milliseconds", millis]];
}

- (IBAction) displayButtonPressed:(id)sender
{
	// force the image browser view to reload its view
	[imageBrowserView_ reloadData];	
}


#pragma mark -
#pragma mark IKImageBrowserDataSource

- (NSUInteger) numberOfItemsInImageBrowser:(IKImageBrowserView *) aBrowser
{
	return [images_ count];
}

- (id) imageBrowser:(IKImageBrowserView *) aBrowser itemAtIndex:(NSUInteger)index
{
	return [images_ objectAtIndex:index];
}




@end
