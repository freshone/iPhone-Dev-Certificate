//
//  MGThumbnailRequest.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/27/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGRequest.h"
#import "MGPhoto.h"

@interface MGThumbnailRequest : MGRequest
@property (nonatomic, strong) MGPhoto *photo;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end

