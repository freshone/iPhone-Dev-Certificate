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
@synthesize imageThumbnailUrl = _imageThumbnailUrl;
@synthesize image = _image;
@synthesize imageThumbnail = _imageThumbnail;


- (UIImage*)getImage
{
    if(self.image == nil)
    {
        //hydrate image from url
    }
    
    return self.imageThumbnail;
}

- (UIImage*)getImageThumnail
{
    if(self.imageThumbnail == nil)
    {
        //hydrate image from url
    }
    
    return self.imageThumbnail;
}

- (bool)isImageLoaded
{
    return self.image == nil;
}

- (bool)isImageThumbnailLoaded
{
    return self.imageThumbnail == nil;
}

@end
