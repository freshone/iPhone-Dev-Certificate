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
@synthesize connectionFileHandle = _connectionFileHandle;

- (void)applicationDidFinishLaunching:(NSNotification *)aNotification
{
    NSString* const	kServiceTypeString = @"_jdmlistener._tcp.";
    NSString* const kServiceNameString = @"HW3 listen service";
    const int kListenPort = 8082;
    const bool reuse = YES;
    
    [self appendStringToLog:@"Initializing..."];
    
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
		[self appendStringToLog:@"Unable to bind socket to address"];
		return;
	}
    
    [self setConnectionFileHandle:[[NSFileHandle alloc] initWithFileDescriptor:fileDescriptor closeOnDealloc:YES]];
	
	[[NSNotificationCenter defaultCenter]
     addObserver:self
     selector:@selector(handleIncomingConnection:) 
     name:NSFileHandleConnectionAcceptedNotification
     object:nil];
    
    [[self connectionFileHandle] acceptConnectionInBackgroundAndNotify];
	
    NSNetService* netService = [[NSNetService alloc] initWithDomain:@"" 
        type:kServiceTypeString
        name:kServiceNameString 
        port:kListenPort];
    
	// publish on the default domains
    [netService setDelegate:self];
    [netService publish];
}

- (void)handleIncomingConnection:(NSNotification*)notification
{
	NSDictionary*	userInfo			=	[notification userInfo];
	NSFileHandle*	readFileHandle		=	[userInfo objectForKey:NSFileHandleNotificationFileHandleItem];
	
    if(readFileHandle)
	{
		[[NSNotificationCenter defaultCenter]
		 addObserver:self
		 selector:@selector(readIncomingData:)
		 name:NSFileHandleDataAvailableNotification
		 object:readFileHandle];
		
		[self appendStringToLog:@"Opened an incoming connection"];
		
        [readFileHandle waitForDataInBackgroundAndNotify];
    }
	
	[[self connectionFileHandle] acceptConnectionInBackgroundAndNotify];
}

- (void)readIncomingData:(NSNotification*) notification
{
	NSFileHandle*	readFileHandle	= [notification object];
	NSData*			data			= [readFileHandle availableData];
	
    // Check if we have everything
	if([data length] == 0)
	{
		[self appendStringToLog:@"No more data in file handle, closing"];
        [[NSNotificationCenter defaultCenter]
         removeObserver:self
         name:NSFileHandleDataAvailableNotification
         object:readFileHandle];
	}
    else
    {
        [self appendStringToLog:@"Got a message: "];
        [self appendStringToLog:[NSString stringWithUTF8String:[data bytes]]];
        
        // wait for a read again
        [readFileHandle waitForDataInBackgroundAndNotify];
    }
}

- (void)netServiceDidPublish:(NSNetService *)sender
{
    [self appendStringToLog:@"publish successful"];
}

- (void)netService:(NSNetService *)sender didNotPublish:(NSDictionary *)errorDict
{
    [self appendStringToLog:[errorDict valueForKey:NSNetServicesErrorCode]];
}

- (void)appendStringToLog:(NSString *)aString
{
    [[[self logTextView] textStorage] appendAttributedString:[[NSAttributedString alloc] initWithString:aString]];
    [[self logTextView] setFont:[NSFont fontWithName:@"Courier" size:12.0f]];
}

@end
