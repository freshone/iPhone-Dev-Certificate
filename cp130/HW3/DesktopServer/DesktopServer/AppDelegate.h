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
@property (nonatomic, strong) NSNetService *netService;

- (void)handleIncomingConnection:(NSNotification*)notification;
- (void)readIncomingData:(NSNotification*) notification;
- (void)netServiceWillPublish:(NSNetService *)sender;
- (void)netServiceDidPublish:(NSNetService *)sender;
- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict;
- (void)netServiceWillResolve:(NSNetService *)sender;
- (void)netServiceDidResolveAddress:(NSNetService *)sender;
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict;
- (void)netServiceDidStop:(NSNetService *)sender;

@end
