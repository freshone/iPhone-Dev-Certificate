//
//  ListenerService.h
//  DesktopService
//
//  Created by Jeremy McCarthy on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ListenerServiceDelegate;

@interface ListenerService : NSObject <NSApplicationDelegate,NSNetServiceDelegate>
@property (nonatomic, strong) NSFileHandle *connectionFileHandle;
@property (nonatomic, strong) NSNetService *netService;
@property (nonatomic, strong) id<ListenerServiceDelegate> delegate;
- (id)initWithDelegate:(id<ListenerServiceDelegate>)delegate;
- (void)handleIncomingConnection:(NSNotification*)notification;
- (void)readIncomingData:(NSNotification*)notification;
- (void)netServiceWillPublish:(NSNetService *)sender;
- (void)netServiceDidPublish:(NSNetService *)sender;
- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict;
- (void)netServiceWillResolve:(NSNetService *)sender;
- (void)netServiceDidResolveAddress:(NSNetService *)sender;
- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict;
- (void)netServiceDidStop:(NSNetService *)sender;
@end

@protocol ListenerServiceDelegate <NSObject>
- (void)messageReceived:(NSString*)aMessage;
@end