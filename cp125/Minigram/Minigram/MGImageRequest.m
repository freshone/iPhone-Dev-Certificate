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

#pragma mark -
#pragma mark Constant Declarations

- (void)send
{
    [[self photo] setImage:nil];
    // Create the request object and connect
    NSURLRequest *request = [NSURLRequest requestWithURL:[[self photo] imageUrl]];
    [self setHttpConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
    [super send];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [[self photo] setImage:[UIImage imageWithData:[self responseData]]];
}

@end
