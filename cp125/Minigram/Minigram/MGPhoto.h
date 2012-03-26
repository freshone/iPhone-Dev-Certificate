//
//  MGPhoto.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/19/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGPhoto : NSObject

@property (nonatomic, assign) NSString *title;
@property (nonatomic, assign) NSString *username;
@property (nonatomic, assign) NSDate *createdAt;
@property (nonatomic, assign) NSURL *url;
@property (nonatomic, assign) NSURL *imageUrl;
@property (nonatomic, assign) NSURL *imageThumbnailUrl;
@property (nonatomic, retain) UIImage *image;
@property (nonatomic, retain) UIImage *imageThumbnail;

- (UIImage*)getImage;
- (UIImage*)getImageThumnail;
- (bool)isImageLoaded;
- (bool)isImageThumbnailLoaded;

@end
