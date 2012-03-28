//
//  MGThumbnailRequest.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/27/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGThumbnailRequest.h"

@implementation MGThumbnailRequest

@synthesize photo = _photo;
@synthesize indexPath = _indexPath;

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
    [[self photo] setThumbnail:nil];
    // Create the request object and connect
    NSURLRequest *request = [NSURLRequest requestWithURL:[[self photo] thumbnailUrl]];
    [self setHttpConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
    [super send];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    [[self photo] setThumbnail:[UIImage imageWithData:[self responseData]]];
    [[self delegate] requestDidComplete:self];
}

@end
