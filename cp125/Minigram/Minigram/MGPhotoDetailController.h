//
//  MGPhotoDetailController.h
//  Minigram
//
//  Created by Luke Adamson on 2/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGPhoto.h"
#import "MGRequest.h"

@interface MGPhotoDetailController : UIViewController <MGRequestDelegate>
@property (nonatomic, strong) MGPhoto *photo;
@end
