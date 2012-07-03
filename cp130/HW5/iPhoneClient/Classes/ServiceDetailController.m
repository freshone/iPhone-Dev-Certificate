//
//  ServiceDetailController.m
//  iPhoneClient
//
//	HW3_1
//
//  Copyright 2010 Chris Parrish

#import "ServiceDetailController.h"


@interface ServiceDetailController ()
@property (nonatomic, retain) IBOutlet UILabel*	statusLabel;
@property (nonatomic, retain) NSOutputStream* outputStream;
- (void)connectToService;
- (void)releaseStream;
- (void)sendMessage:(NSString*)messageText;
- (IBAction)zoomInPushed:(id)sender;
- (IBAction)zoomOutPushed:(id)sender;
- (IBAction)resetPushed:(id)sender;
@end

@implementation ServiceDetailController

#pragma mark - Life Cycle

- (void)dealloc
{
    [self setService:nil];
	[self releaseStream];
    [super dealloc];
}

#pragma mark - Private Properties

@synthesize	service = _service;
@synthesize statusLabel = _statusLabel;
@synthesize outputStream = _outputStream;

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	if([self service])
    {
		[self connectToService];
    }
}

- (void)viewDidUnload
{
    [super viewDidUnload];
	[self setStatusLabel:nil];
	[self setService:nil];
	[self releaseStream];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self releaseStream];
}

- (void)releaseStream
{
	[[self outputStream] close];
	[self setOutputStream:nil];
}

#pragma mark -
#pragma mark Service

- (void)connectToService
{
	[[self service] getInputStream:NULL outputStream:&_outputStream];
	
	if(_outputStream != nil)
	{
		[[self outputStream] open];
		[[self statusLabel] setText:@"Connected to service."];
	}
	else
	{
		[[self statusLabel] setText:@"Could not connect to service."];
	}
}

#pragma mark -
#pragma mark Actions

- (void)sendMessage:(NSString*)messageText
{
	if([self outputStream] == nil)
	{
		[[self statusLabel] setText:@"Failed to send message, not connected."];
		return;
	}
    
	const uint8_t* messageBuffer = (const uint8_t*)[messageText UTF8String];
	NSUInteger length = [messageText lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	[[self outputStream] write:messageBuffer maxLength:length];
}

#pragma mark -
#pragma mark Button Push Actions

- (IBAction)zoomInPushed:(id)sender
{
    [self sendMessage:@"zoomIn"];
}

- (IBAction)zoomOutPushed:(id)sender
{
    [self sendMessage:@"zoomOut"];
}

- (IBAction)resetPushed:(id)sender
{
    [self sendMessage:@"reset"];
}

@end