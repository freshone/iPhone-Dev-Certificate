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

NSString* const kServiceTypeString = @"_jdmlistener._tcp.";
NSString* const kSearchDomain = @"";

@interface RootViewController()
@property (nonatomic, retain) NSNetServiceBrowser* browser;
@property (nonatomic, retain) NSMutableArray* services;	
@end

@implementation RootViewController
@synthesize browser = browser_;
@synthesize services = services_;

#pragma mark - Memory management

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)dealloc
{
    [self setServices:nil];
    [super dealloc];
}

#pragma mark -  NSNetService

- (void)startServiceSearch
{
    [self setServices:[[NSMutableArray alloc] init]];
	[self setBrowser:[[NSNetServiceBrowser alloc] init]];
    [[self browser] setDelegate:self];
    [[self browser]  searchForServicesOfType:kServiceTypeString inDomain:kSearchDomain];
	NSLog(@"Started browsing for services: %@", [[self browser] description]);
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser 
           didFindService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreComing 
{
    NSLog(@"Adding new service");
    [[self services] addObject:aNetService];
    
	[aNetService setDelegate:self];
    [aNetService resolveWithTimeout:5.0];
	
    if (!moreComing)
	{
        [[self tableView] reloadData];
    }
}

- (void)netServiceBrowser:(NSNetServiceBrowser *)aNetServiceBrowser
         didRemoveService:(NSNetService *)aNetService 
               moreComing:(BOOL)moreComing 
{
    NSLog(@"Removing service");
	[[self services] removeObject:aNetService];
    [[self tableView] reloadData];
}

- (void)netServiceWillResolve:(NSNetService *)sender
{
	NSLog(@"RESOLVING net service with name %@ and type %@", [sender name], [sender type]);
}

- (void)netServiceDidResolveAddress:(NSNetService *)sender
{
	NSLog(@"RESOLVED net service with name %@ and type %@", [sender name], [sender type]);
    [[self tableView] reloadData];
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
	[self startServiceSearch];
}

- (void)viewDidUnload
{
	[self setServices:nil];
    [self setBrowser:nil];
}

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[self services] count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil)
	{
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier] autorelease];
    }
    
	NSNetService* service = [[self services] objectAtIndex:indexPath.row];
	NSArray* addresses = [service addresses];
	
	if ([addresses count] == 0)
	{
		[[cell textLabel] setText:@"Could not resolve address"];
	}
	else
	{
		[[cell textLabel] setText:[service hostName]];
	}
	
    for(NSData* addressData in addresses)
	{
		struct sockaddr_in* address = (struct sockaddr_in*)[addressData bytes];	
		
		NSLog(@"host : %d port : %d", ntohl(address->sin_addr.s_addr), ntohs(address->sin_port));
		
		char hostname[2048];
		char serv[20];
		
		getnameinfo((const struct sockaddr*)address, sizeof(address), hostname, sizeof(hostname), serv, sizeof(serv), 0);
		
		NSLog(@"hostname : %s service : %s", hostname, serv);
		
		NSLog(@"domain : %@", [service domain]);
	}
    
	[[cell detailTextLabel] setText:[service name]];
    return cell;
}


#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	NSNetService* selectedService = [[self services] objectAtIndex:indexPath.row];
	
    if([[selectedService addresses] count] < 1)
    {
        [selectedService resolveWithTimeout:5.0];
    }
    else
    {
        ServiceDetailController* detailController = [[ServiceDetailController alloc] initWithNibName:@"ServiceDetailController" bundle:nil];
        [detailController setService:selectedService];
        [[self navigationController] pushViewController:detailController animated:YES];
        [detailController release];	
    }
}

@end