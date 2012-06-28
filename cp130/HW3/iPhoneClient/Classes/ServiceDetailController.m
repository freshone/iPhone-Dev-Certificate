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
@property (nonatomic, retain) IBOutlet UITextField*	messageTextView;

@property (nonatomic, retain) NSOutputStream* outputStream;

- (IBAction) sendMessage:(id)sender;

- (void) connectToService;
- (void) releaseStream;

@end

@implementation ServiceDetailController

#pragma mark - Life Cycle

- (void)dealloc
{
	self.service = nil;
	[self releaseStream];
    
    [super dealloc];
}

#pragma mark - Private Properties

@synthesize	service = service_;
@synthesize statusLabel = statusLabel_;
@synthesize messageTextView = messageTextView_;
@synthesize outputStream = outputStream_;

#pragma mark - UIViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

	[self.messageTextView becomeFirstResponder];
	self.messageTextView.returnKeyType = UIReturnKeySend;
	self.messageTextView.enablesReturnKeyAutomatically = YES;
	
	if (self.service)
		[self connectToService];
}

- (void)viewDidUnload
{
    [super viewDidUnload];

	self.statusLabel = nil;
	self.messageTextView = nil;
	self.service = nil;
    self.messageTextView = nil;
    
	[self releaseStream];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
	[self releaseStream];
}

- (void)releaseStream
{
	[self.outputStream close];
	self.outputStream = nil;
}

#pragma mark -
#pragma mark Service

- (void)connectToService
{
	[[self service] getInputStream:NULL outputStream:&outputStream_];
	
	if(outputStream_ != nil)
	{
		[[self outputStream] open];
		[[self statusLabel] setText:@"Connected to service."];
	}
	else
	{
		[[self statusLabel] setText:@"Could not connect to service"];
	}
}

#pragma mark -
#pragma mark Actions

- (IBAction)sendMessage:(id)sender
{
	if(self.outputStream == nil)
	{
		[[self statusLabel] setText:@"Failed to send message, not connected."];
		return;
	}
	
	NSString* messageText = [[self messageTextView] text];
	
	const uint8_t*	messageBuffer = (const uint8_t*)[messageText UTF8String];
	NSUInteger length = [messageText lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	[[self outputStream] write:messageBuffer maxLength:length];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	[self sendMessage:textField];
	return YES;
}

- (BOOL)textFieldShouldEndEditing:(UITextField *)textField
{
	return YES;
}

@end
