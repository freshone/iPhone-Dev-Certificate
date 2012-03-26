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
- (void)serviceClientDidCompletePostPhotosRequest:(MGPhoto*)response;
- (void)serviceClientDidCompleteHydrateImage:(NSIndexPath*)index;
- (void)serviceClientDidCompleteHydrateThumbnail:(NSIndexPath*)index;
- (void)serviceClientUpdatedPostPhotosProgress:(float)percentComplete;
@end

@interface MGServiceClient : NSObject <NSURLConnectionDelegate>
@property (nonatomic, assign) id<MGServiceClientDelegate> delegate;
- (void)httpGetPhotos;
- (void)httpGetPhoto:(NSString*)photoId;
- (void)httpPostPhotos:(UIImage*)photo withTitle:(NSString*)title withLatitude:(NSString*)latitude withLongitude:(NSString*)longitude;
- (void)httpHydrateImage:(MGPhoto*)photo forIndexPath:(NSIndexPath*)indexPath;
- (void)httpHydrateThumbnail:(MGPhoto*)photo forIndexPath:(NSIndexPath*)indexPath;
- (void)closeOpenConnections;
- (NSArray*)createArrayFromJSON:(NSData*)data;
@end