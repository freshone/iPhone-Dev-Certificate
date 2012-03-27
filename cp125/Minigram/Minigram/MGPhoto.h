//
//  MGPhoto.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/19/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MGPhoto : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *username;
@property (nonatomic, strong) NSDate *createdAt;
@property (nonatomic, strong) NSURL *url;
@property (nonatomic, strong) NSURL *imageUrl;
@property (nonatomic, strong) NSURL *thumbnailUrl;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSString *longitude;
@property (nonatomic, strong) NSString *latitude;

@end
