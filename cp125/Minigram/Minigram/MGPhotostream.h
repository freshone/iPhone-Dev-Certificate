//
//  MGPhotostream.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/19/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGPhoto.h"

@interface MGPhotostream : NSObject

@property (nonatomic, retain) NSArray *stream;

- (void)initWithJSON:(NSString*)json;

@end
