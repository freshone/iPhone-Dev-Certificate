//
//  MGRequest.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGPhotostream.h"
#import "MGPhoto.h"

@interface MGRequest : NSURLConnection

typedef enum _MGRequestType
{
    GET_PHOTOS_REQUEST,
    GET_PHOTO_REQUEST,
    POST_PHOTOS_REQUEST,
    HYDRATE_IMAGE_REQUEST,
    HYDRATE_THUMBNAIL_REQUEST
} MGRequestType;

@property (nonatomic, assign) MGRequestType requestType;
@property (nonatomic, retain) MGPhoto *requestPhoto;
@property (nonatomic, retain) NSIndexPath *requestIndexPath;
@property (nonatomic, retain) NSMutableData *responseData;
@property (nonatomic, assign) NSStringEncoding encoding;

@end


