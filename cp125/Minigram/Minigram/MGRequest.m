//
//  MGRequest.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGRequest.h"

@implementation MGRequest

@synthesize requestType = _requestType;
@synthesize requestPhoto = _requestPhoto;
@synthesize requestIndexPath = _requestIndexPath;
@synthesize responseData = _responseData;
@synthesize encoding = _encoding;

- (id)init
{
    self = [super init];
    self.responseData = [[NSMutableData alloc] init];
    return self;
}

@end
