//
//  AppDelegate.h
//  DesktopServer
//
//  Created by Jeremy McCarthy on 6/10/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate,NSNetServiceDelegate>

@property (assign) IBOutlet NSWindow *window;
@property (unsafe_unretained) IBOutlet NSTextView *logTextView;
@property (nonatomic, strong) NSFileHandle *connectionFileHandle;

- (void)handleIncomingConnection:(NSNotification*)notification;
- (void)readIncomingData:(NSNotification*) notification;
- (void)netServiceDidPublish:(NSNetService *)sender;
- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict;

@end
