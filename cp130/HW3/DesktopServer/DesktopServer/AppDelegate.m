//
//  AppDelegate.m
//  DesktopServer
//
//  Created by Jeremy McCarthy on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "AppDelegate.h"
//#import <sys/socket.h>
#import <netinet/in.h>

@implementation AppDelegate

@synthesize window = _window;
@synthesize logTextView = _logTextView;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    [[[self logTextView] textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:@"Initializing..."]];
    
    // Create socket
    CFSocketRef socket_ = CFSocketCreate(
        kCFAllocatorDefault,
        PF_INET,
        SOCK_STREAM,
        IPPROTO_TCP,
        0,
        NULL,
        NULL);
    
    
    
    
    
    
    
    
    
    [[self logTextView] setFont:[NSFont fontWithName:@"Courier" size:12.0f]];
}

@end
