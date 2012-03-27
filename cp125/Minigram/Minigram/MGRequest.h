//
//  MGRequest.h
//  Minigram
//
//  Created by Jeremy McCarthy on 3/26/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol MGRequestDelegate;

@interface MGRequest : NSObject <NSURLConnectionDelegate>
@property (nonatomic, strong) id<MGRequestDelegate> delegate;
@property (nonatomic, strong) NSMutableData *responseData;
@property (nonatomic, assign) NSStringEncoding encoding;
@property (nonatomic, strong) NSURLConnection *httpConnection;
- (void)send;
- (void)cancel;
@end

@protocol MGRequestDelegate <NSObject>
@optional
- (void)requestDidComplete:(MGRequest*)request;
- (void)requestDidFail:(MGRequest*)request;
- (void)requestDidUpdate:(MGRequest*)request;
@end