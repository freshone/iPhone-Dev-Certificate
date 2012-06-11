//
//  RootViewController.m
//  iPhoneClient
//
//	HW3_1
//
//  Copyright 2010 Chris Parrish

#import "RootViewController.h"
#import "ServiceDetailController.h"
#import <sys/socket.h>
#import <netinet/in.h>
#include <netdb.h>

NSString* const			kServiceTypeString		= @"_uwcelistener._tcp.";
NSString* const			kSearchDomain			= @"";
// Bonjour automatically puts everything in the .local domain,
// ie your mac is something like MyMacSharingName.local
// using an empty search domain will result in all the default domains
// including .local and Back to My Mac

@interface RootViewController()<NSNetServiceBrowserDelegate, NSNetServiceDelegate>

@property (nonatomic, retain) NSNetServiceBrowser*	browser;
@property (nonatomic, retain) NSMutableArray* services;	

@end

@implementation RootViewController


#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (void)dealloc
{
    self.services = nil;

    [super dealloc];
}

#pragma mark - Private Properties

@synthesize browser = browser_;
@synthesize services = services_;


#pragma mark -  NSNetService

// < YOU NEED TO MAKE ALL THESE METHODS DO THE RIGHT THING >

- (void) startServiceSearch
{
	
	NSLog(@"Started browsing for services: %@", browser_);	
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
           didFindService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreComing 
{
    NSLog(@"Adding new service");
    
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
         didRemoveService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreComing 
{
    NSLog(@"Removing service");
	
}

- (void)netServiceWillResolve:(NSNetService *)sender
{
	NSLog(@"RESOLVING net service with name %@ and type %@", [sender name], [sender type]);
}


- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"RESOLVED net service with name %@ and type %@", [sender name], [sender type]);
}

- (void)netService:(NSNetService *)sender didNotResolve:(NSDictionary *)errorDict
{
	NSLog(@"DID NOT RESOLVE net service with name %@ and type %@", [sender name], [sender type]);
	NSLog(@"Error Dict: %@", [errorDict description]);
	
}

#pragma mark -
#pragma mark View lifecycle


- (void)viewDidLoad
{
    [super viewDidLoad];
	
	// <ADD SOME CODE HERE : Create the service browser and start looking for services>

}

- (void)viewDidUnload
{
	self.services = nil;
}


#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.services count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSNetService* service = [self.services objectAtIndex:indexPath.row];
	NSArray* addresses = [service addresses];
	
	if ([addresses count] == 0)
	{
		cell.textLabel.text = @"Could not resolve address";
	}
	else
	{
		cell.textLabel.text = [service hostName];
	}
	
	
	for (NSData* addressData in addresses)
	{
		struct sockaddr_in* address = (struct sockaddr_in*)[addressData bytes];	
		
		NSLog(@"host : %d port : %d", ntohl(address->sin_addr.s_addr), ntohs(address->sin_port));
		
		char hostname[2048];
		char serv[20];
		
		getnameinfo((const struct sockaddr*)address, sizeof(address), hostname, sizeof(hostname), serv, sizeof(serv), 0);
		
		NSLog(@"hostname : %s service : %s", hostname, serv);
		
		NSLog(@"domain : %@", [service domain]);
	}
	
	
	cell.detailTextLabel.text = [service name]; 
	
	
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	
	// if the selection was not resolved, try to resolve it again, but don't attempt
	// to bring up the details
	
	NSNetService* selectedService = [self.services objectAtIndex:indexPath.row];
	
	// <ADD SOME CODE HERE : 
	// if the selection was not resolved, try to resolve it again, but don't attempt
	// to bring up the details >
	
    ServiceDetailController* detailController = [[ServiceDetailController alloc] initWithNibName:@"ServiceDetailController" bundle:nil];
	
	detailController.service = selectedService;
    [[self navigationController] pushViewController:detailController animated:YES];
    [detailController release];	
}




@end

