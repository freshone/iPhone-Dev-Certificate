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
	// We assume the NSNetService has been resolved at this point
	
	// NSNetService makes it easy for us to connect, we don't have to do any socket management
    
	[service_ getInputStream:NULL outputStream:&outputStream_];
	
	if ( outputStream_ != nil )
	{
		[outputStream_ open];
		statusLabel_.text = @"Connected to service.";
	}
	else
	{
		statusLabel_.text = @"Could not connect to service";
	}
	
	// if we wanted, we could scheudled notifcations or other run loop
	// based reading of the input stream to get messages back from the
	// service we connected to
	
    
    // < ADD CODE HERE : statuaLabel to reflect if we connected or not. 
    //    if we could not get the output stream, we could not connect >	
}

#pragma mark -
#pragma mark Actions

- (IBAction)sendMessage:(id)sender
{
	if(self.outputStream == nil)
	{
		self.statusLabel.text = @"Failed to send message, not connected.";
		return;
	}
	
	NSString* messageText = messageTextView_.text;
	
	const uint8_t*	messageBuffer = (const uint8_t*)[messageText UTF8String];
	NSUInteger		length = [messageText lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
	[outputStream_ write:messageBuffer maxLength:length];
	
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
