//
//  MGPostRequest.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGPostRequest.h"
#import "NSMutableData+MGMultipartFormData.h"

@implementation MGPostRequest

@synthesize photo = _photo;

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
    // Create the request object
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"%@%@", BASE_URL, PHOTOS_URL]]];
    
    // Build request
    [request setHTTPMethod:@"POST"];
    [request setValue:API_KEY forHTTPHeaderField:API_KEY_FIELD];
    [request setValue:FORMAT forHTTPHeaderField:FORMAT_FIELD];
    [request setValue:[NSData mg_contentTypeForMultipartFormData] forHTTPHeaderField:@"content-type"];
    
    // Build body
    NSMutableData *body = [NSMutableData data];
    NSData *jpegPhoto = UIImageJPEGRepresentation([[self photo] image], 1.0f);
    [body mg_appendFormValue:[[self photo] title] forKey:PHOTO_TITLE_FIELD];
    [body mg_appendFileData:jpegPhoto forKey:PHOTO_IMAGE_FIELD filename:PHOTO_FILENAME mimeType:PHOTO_MIME_TYPE];
    [body mg_appendMultipartFooter];
    [request setHTTPBody:body];
    
    // Connect
    [self setHttpConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
    [super send];
}

- (void)connection:(NSURLConnection*)connection didSendBodyData:(NSInteger)bytesWritten totalBytesWritten:(NSInteger)totalBytesWritten totalBytesExpectedToWrite:(NSInteger)totalBytesExpectedToWrite
{
    [self setPercentComplete:((float)totalBytesWritten / totalBytesExpectedToWrite)];
    [[self delegate] requestDidUpdate:self];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [self setResponseData:nil];
    [self setHttpConnection:nil];
    [[self delegate] requestDidComplete:self];
}

@end
