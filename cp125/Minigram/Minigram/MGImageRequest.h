//
//  MGImageRequest.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGRequest.h"
#import "MGPhoto.h"

@interface MGImageRequest : MGRequest
@property (nonatomic, strong) MGPhoto *photo;
@property (nonatomic, assign) long long expectedFilesize;
@end
