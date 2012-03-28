//
//  MGRequest.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGRequest.h"

@implementation MGRequest

@synthesize delegate = _delegate;
@synthesize responseData = _responseData;
@synthesize encoding = _encoding;
@synthesize httpConnection = _httpConnection;

#pragma mark -
#pragma mark Constant Declarations

static NSString * const BASE_URL = @"http://minigram.herokuapp.com";
static NSString * const PHOTOS_URL = @"/photos";
static NSString * const API_KEY = @"73edf8a0-3fb7-012f-5dee-48bcc8c61670";
static NSString * const API_KEY_FIELD = @"X-Minigram-Auth";
static NSString * const FORMAT = @"application/json";
static NSString * const FORMAT_FIELD = @"Accept";
static NSString * const CONTENT_TYPE = @"content-type";
static NSString * const PHOTO_TITLE_FIELD = @"photo[title]";
static NSString * const PHOTO_IMAGE_FIELD = @"photo[image]";
static NSString * const PHOTO_MIME_TYPE = @"image/jpeg";
static NSString * const PHOTO_FILENAME = @"no-filename.jpg";

- (void)send
{
    [self setResponseData:[[NSMutableData alloc] init]];
}

- (void)cancel
{
    [[self httpConnection] cancel];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Implementation

- (void)connection:(MGRequest*)connection didFailWithError:(NSError *)error
{
    [[self delegate] requestDidFail:self];
}

- (void)connection:(NSURLConnection*)connection didReceiveData:(NSData*)data
{
    [[self responseData] appendData:data];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    NSLog(@"Response:\n\n%@", [[NSString alloc]initWithData:[self responseData] encoding:[self encoding]]);
}


@end
