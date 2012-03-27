//
//  MGStreamRequest.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGRequest.h"
#import "MGPhoto.h"

@interface MGStreamRequest : MGRequest
@property (nonatomic, strong) NSMutableArray *photoStream;
@end
