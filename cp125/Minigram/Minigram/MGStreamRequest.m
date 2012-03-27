//
//  MGStreamRequest.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGStreamRequest.h"

@implementation MGStreamRequest

@synthesize photoStream = _photoStream;

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

#pragma mark -
#pragma mark Service API

- (void)send
{    
    // Create the request object and connect
    NSMutableURLRequest *request =
    [NSMutableURLRequest requestWithURL:
     [NSURL URLWithString:
      [NSString stringWithFormat:@"%@%@", BASE_URL, PHOTOS_URL]]];
    [request setHTTPMethod:@"GET"];
    [request setValue:API_KEY forHTTPHeaderField:API_KEY_FIELD];
    [request setValue:FORMAT forHTTPHeaderField:FORMAT_FIELD];
    [self setHttpConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
    [self setPhotoStream:nil];
    [super send];
}

#pragma mark -
#pragma mark NSURLConnectionDelegate Implementation

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    //parse json and store photostream
    NSError *error = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:[self responseData] options:0 error:&error];
    
    for(NSDictionary *element in response)
    {
        MGPhoto *parsedPhoto = [[MGPhoto alloc] init];
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
        [dateFormat setTimeZone:[NSTimeZone systemTimeZone]];
        
        [parsedPhoto setCreatedAt:[dateFormat dateFromString:[element objectForKey:@"created_at"]]];
        [parsedPhoto setTitle:[element objectForKey:@"title"]];
        [parsedPhoto setUsername:[element objectForKey:@"username"]];
        [parsedPhoto setUrl:[NSURL URLWithString:[element objectForKey:@"url"]]];
        [parsedPhoto setImageUrl:[NSURL URLWithString:[element objectForKey:@"image_url"]]];
        [parsedPhoto setThumbnailUrl:[NSURL URLWithString:[element objectForKey:@"image_thumbnail_url"]]];
        [parsedPhoto setLongitude:[element objectForKey:@"longitude"]];
        [parsedPhoto setLatitude:[element objectForKey:@"latitude"]];
        
        [[self photoStream] addObject:parsedPhoto];
    }
    
    [[self delegate] requestDidComplete:self];
}

@end
