//
//  MGImageRequest.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGImageRequest.h"

@implementation MGImageRequest

@synthesize photo = _photo;
@synthesize expectedFilesize = _expectedFilesize;

#pragma mark -
#pragma mark Constant Declarations

- (void)send
{
    [[self photo] setImage:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[[self photo] imageUrl]];
    [self setHttpConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
    [super send];
}

- (void)connection:(NSURLConnection*)connection didReceiveResponse:(NSURLResponse*)response
{
    [self setExpectedFilesize:[response expectedContentLength]];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [super connection:connection didReceiveData:data];
    [self setPercentComplete:((float)[[self responseData] length] / [self expectedFilesize])];
    [[self delegate] requestDidUpdate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [[self photo] setImage:[UIImage imageWithData:[self responseData]]];
    [self setResponseData:nil];
    [self setHttpConnection:nil];
    [[self delegate] requestDidComplete:self];
}

@end
