//
//  ListenerService.m
//  DesktopService
//
//  Created by Jeremy McCarthy on 7/2/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ListenerService.h"
#import <netinet/in.h>

@implementation ListenerService

@synthesize connectionFileHandle = _connectionFileHandle;
@synthesize netService = _netService;
@synthesize delegate = _delegate;

- (id)initWithDelegate:(id)delegate
{
    NSString* const kServiceTypeString = @"_jdmlistener._tcp.";
    NSString* const kServiceNameString = @"HW5";
    const int kListenPort = 9227;
    const bool reuse = YES;

    // Create socket
    CFSocketRef socket_ = CFSocketCreate(
            kCFAllocatorDefault,
            PF_INET,
            SOCK_STREAM,
            IPPROTO_TCP,
            0,
            NULL,
            NULL
            );

    int fileDescriptor = CFSocketGetNative(socket_);

    setsockopt(
            fileDescriptor,
            SOL_SOCKET,
            SO_REUSEADDR,
            (void *)&reuse,
            sizeof(int)
            );

    struct sockaddr_in address;
    memset(&address, 0, sizeof(address));
    address.sin_len = sizeof(address);
    address.sin_family = AF_INET;
    address.sin_addr.s_addr = htonl(INADDR_ANY);
    address.sin_port = htons(kListenPort);

    CFDataRef addressData =
        CFDataCreate(NULL, (const UInt8 *)&address, sizeof(address));

    // bind socket to the address
    if (CFSocketSetAddress(socket_, addressData) != kCFSocketSuccess)
    {
        NSLog(@"Unable to bind socket to address");
    }
    else
    {
        [self setConnectionFileHandle:[[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor closeOnDealloc:YES]];

        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(handleIncomingConnection:) 
            name:NSFileHandleConnectionAcceptedNotification
            object:nil];

        [[self connectionFileHandle] acceptConnectionInBackgroundAndNotify];

        [self setNetService:[[NSNetService alloc] initWithDomain:@"" 
            type:kServiceTypeString
            name:kServiceNameString 
            port:kListenPort]];
        [[self netService] setDelegate:self];
        [[self netService] publish];
    }

    CFRelease(socket_);
    CFRelease(addressData);
    
    [self setDelegate:delegate];

    return self;
}

- (void)handleIncomingConnection:(NSNotification*)notification
{
    NSDictionary*   userInfo            =   [notification userInfo];
    NSFileHandle*   readFileHandle      =   [userInfo objectForKey:NSFileHandleNotificationFileHandleItem];

    if(readFileHandle)
    {
        [[NSNotificationCenter defaultCenter]
            addObserver:self
            selector:@selector(readIncomingData:)
            name:NSFileHandleDataAvailableNotification
            object:readFileHandle];

        NSLog(@"Opened an incoming connection");

        [readFileHandle waitForDataInBackgroundAndNotify];
    }

    [[self connectionFileHandle] acceptConnectionInBackgroundAndNotify];
}

- (void)readIncomingData:(NSNotification*) notification
{
    NSFileHandle* readFileHandle = [notification object];
    NSData* data = [readFileHandle availableData];

    // Check if we have everything
    if([data length] == 0)
    {
        NSLog(@"No more data in file handle, closing");
        [[NSNotificationCenter defaultCenter]
            removeObserver:self
            name:NSFileHandleDataAvailableNotification
            object:readFileHandle];
    }
    else
    {
        NSString* message = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        NSLog(@"Got a message: ");
        NSLog(@"%@", message);
        
        if([self delegate])
        {
            [[self delegate] messageReceived:message];
        }

        // wait for a read again
        [readFileHandle waitForDataInBackgroundAndNotify];
    }
}

- (void)netServiceWillPublish:(NSNetService *)sender
{
    NSLog(@"publish imminent");
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    NSLog(@"publish successful");
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    NSLog(@"publish failed");
    NSLog(@"%@", [errorDict valueForKey:NSNetServicesErrorCode]);
}

- (void)netServiceWillResolve:(NSNetService *)sender
{
    NSLog(@"service will resolve");
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
    NSLog(@"service resolved");
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
    NSLog(@"service did not resolve");
    NSLog(@"%@", [errorDict valueForKey:NSNetServicesErrorCode]);
}

- (void)netServiceDidStop:(NSNetService *)sender
{
    NSLog(@"service stopped");   
}

@end
