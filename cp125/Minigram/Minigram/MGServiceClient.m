//
//  MGServiceInterface.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/19/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//


#import "MGServiceClient.h"
#import "MGRequest.h"
#import "NSMutableData+MGMultipartFormData.h"

@interface MGServiceClient ()
@property (nonatomic, retain) NSMutableArray *openConnections;
@end

@implementation MGServiceClient

@synthesize delegate = _delegate;
@synthesize openConnections = _openConnections;

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

- (id)init
{
    self = [super init];
    self.openConnections = [NSMutableArray array];
    return self;
}

#pragma mark -
#pragma mark Service API

- (void)httpGetPhotos
{
    // Create the request object
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"%@%@", BASE_URL, PHOTOS_URL]]];
    
    // Never trust defaults
    [request setHTTPMethod:@"GET"];
    
    // Build request
    [request setValue:API_KEY forHTTPHeaderField:API_KEY_FIELD];
    [request setValue:FORMAT forHTTPHeaderField:FORMAT_FIELD];
    
    // Start request and save
    MGRequest *connection = [[MGRequest alloc] initWithRequest:request delegate:self];
    [connection setRequestType:GET_PHOTOS_REQUEST];
    [self.openConnections addObject:connection];
}

- (void)httpGetPhoto:(NSString*)photoId
{
    // Create the request object
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"%@%@/%@", BASE_URL, PHOTOS_URL, photoId]]];
    
    // Never trust defaults
    [request setHTTPMethod:@"GET"];
    
    // Build request
    [request setValue:API_KEY forHTTPHeaderField:API_KEY_FIELD];
    [request setValue:FORMAT forHTTPHeaderField:FORMAT_FIELD];
    
    // Start request and save
    MGRequest *connection = [[MGRequest alloc] initWithRequest:request delegate:self];
    [connection setRequestType:GET_PHOTO_REQUEST];
    [self.openConnections addObject:connection];
}

- (void)httpPostPhotos:(UIImage*)photo withTitle:(NSString*)title withLatitude:(NSString*)latitude withLongitude:(NSString*)longitude
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
    NSData *jpegPhoto = UIImageJPEGRepresentation(photo, 1.0f);
    [body mg_appendFormValue:title forKey:PHOTO_TITLE_FIELD];
    [body mg_appendFileData:jpegPhoto forKey:PHOTO_IMAGE_FIELD filename:PHOTO_FILENAME mimeType:PHOTO_MIME_TYPE];
    [body mg_appendMultipartFooter];
    [request setHTTPBody:body];
    
    // Start request and save
    MGRequest *connection = [[MGRequest alloc] initWithRequest:request delegate:self];
    [connection setRequestType:POST_PHOTOS_REQUEST];
    [self.openConnections addObject:connection];
}

#pragma mark -
#pragma mark Image handling

- (void)httpHydrateImage:(MGPhoto*)photo forIndexPath:(NSIndexPath*)indexPath
{    
    // Start request and save
    NSURLRequest *request = [NSURLRequest requestWithURL:[photo imageUrl]];
    MGRequest *connection = [[MGRequest alloc] initWithRequest:request delegate:self];
    [connection setRequestType:HYDRATE_IMAGE_REQUEST];
    [self.openConnections addObject:connection];
}

- (void)httpHydrateThumbnail:(MGPhoto*)photo forIndexPath:(NSIndexPath*)indexPath
{
    // Start request and save
    NSURLRequest *request = [NSURLRequest requestWithURL:[photo imageUrl]];
    MGRequest *connection = [[MGRequest alloc] initWithRequest:request delegate:self];
    [connection setRequestType:HYDRATE_THUMBNAIL_REQUEST];
    [self.openConnections addObject:connection];
}

#pragma mark -
#pragma mark Connection handling

- (void)closeOpenConnections
{
    // close all pending connections
    [self.openConnections makeObjectsPerformSelector:@selector(cancel)];
    self.openConnections = [NSMutableArray array];
}

- (NSArray*)createArrayFromJSON:(NSData*)data
{
    NSMutableArray *array = [NSMutableArray array];
    NSError *error = nil;
    NSDictionary *dictionary = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    NSLog(@"Response:\n\n%@", dictionary);
    return array;
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Implementation

- (void)connection:(MGRequest*)connection didFailWithError:(NSError *)error
{
    // Do something to handle failure
}

- (void)connection:(MGRequest*)connection didReceiveResponse:(NSURLResponse*)response
{
    NSString *responseEncoding = [[NSString alloc] initWithString:[response textEncodingName]];
    [connection setEncoding:CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef) responseEncoding))];
}

- (void)connection:(MGRequest*)connection didReceiveData:(NSData*)data
{
    [[connection responseData] appendData:data];
    //NSLog(@"Response:\n\n%@", [[NSString alloc]initWithData:data encoding:[connection encoding]]);
}

- (void)connectionDidFinishLoading:(MGRequest*)connection
{
    if([connection requestType] == GET_PHOTOS_REQUEST)
    {
        NSArray *array = [self createArrayFromJSON:[connection responseData]];
    }
}

@end
