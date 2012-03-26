//
//  MGAppDelegate.m
//  Minigram
//
//  Created by Luke Adamson on 2/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGAppDelegate.h"
#import "MGServiceClient.h"

@implementation MGAppDelegate

@synthesize window = _window;

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    MGServiceClient *client = [[MGServiceClient alloc] init];
    [client httpGetPhotos];
    return YES;
}

@end
