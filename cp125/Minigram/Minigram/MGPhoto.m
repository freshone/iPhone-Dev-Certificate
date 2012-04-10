//
//  MGPhoto.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/19/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGPhoto.h"

@implementation MGPhoto

@synthesize title = _title;
@synthesize username = _username;
@synthesize createdAt = _createdAt;
@synthesize url = _url;
@synthesize imageUrl = _imageUrl;
@synthesize thumbnailUrl = _thumbnailUrl;
@synthesize image = _image;
@synthesize thumbnail = _thumbnail;
@synthesize longitude = _longitude;
@synthesize latitude = _latitude;

-(BOOL)isEqual:(id)object
{
    return [[self url] isEqual:[object url]];
}

@end
