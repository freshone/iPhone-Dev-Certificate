//
//  MGServiceInterface.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/19/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGServiceClient.h"
#import "NSMutableData+MGMultipartFormData.h"

@interface MGServiceClient ()
@property (nonatomic, assign) NSStringEncoding encoding;
@end

@implementation MGServiceClient

@synthesize delegate = _delegate;
@synthesize encoding = _encoding;

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
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
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
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)httpPostPhotos:(UIImage*)photo :(NSString*)title :(NSString*)latitude :(NSString*)longitude
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
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:self];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSString *responseEncoding = [[NSString alloc] initWithString:[response textEncodingName]];
    self.encoding = CFStringConvertEncodingToNSStringEncoding(CFStringConvertIANACharSetNameToEncoding((__bridge CFStringRef) responseEncoding));
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Response:\n\n%@", [[NSString alloc]initWithData:data encoding:self.encoding]);
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    // Finish and clean up
    
}

@end
