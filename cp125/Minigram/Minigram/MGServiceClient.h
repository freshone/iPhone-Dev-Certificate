//
//  MGServiceInterface.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/19/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MGPhotostream.h"
#import "MGPhoto.h"

@protocol MGServiceClientDelegate <NSObject>
@optional
- (void)serviceClientDidCompleteGetPhotosRequest:(MGPhotostream*)response;
- (void)serviceClientDidCompleteGetPhotoRequest:(MGPhoto*)response;
- (void)serviceClientDidCompletePostPhotos:(bool)didSucceed;
- (void)serviceClientDidCompleteImageLoad:(MGPhoto*)loadedPhoto;
- (void)serviceClientDidCompleteImageThumbnail:(MGPhotostream*)loadedStream;
- (void)serviceClientUpdatedPostPhotosProgress:(float)percentComplete;
@end

@interface MGServiceClient : NSObject <NSURLConnectionDelegate>
@property (nonatomic, assign) id<MGServiceClientDelegate> delegate;
- (void)httpGetPhotos;
- (void)httpGetPhoto:(NSString*)photoId;
- (void)httpPostPhotos:(UIImage*)photo :(NSString*)title :(NSString*)latitude :(NSString*)longitude;
- (void)httpLoadImage:(MGPhoto*)photo;
@end