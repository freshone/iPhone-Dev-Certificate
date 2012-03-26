//
//  NSMutableData+MGMultipartFormData.h
//  Minigram 2
//
//  Created by Luke Adamson on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSData (MGMultipartFormData)
// For use in the content-type header of the request
+ (NSString *)mg_contentTypeForMultipartFormData;
@end

@interface NSMutableData (MGMultipartFormData)

- (void)mg_appendFormValue:(NSString *)stringValue forKey:(NSString *)formKey;

// Filename is required. If you don't have one, use something like: no-filename-given.jpg
// mimeType should be something like: image/jpeg
- (void)mg_appendFileData:(NSData *)data forKey:(NSString *)formKey filename:(NSString *)filename mimeType:(NSString *)mimeType;

// You must call this at the end to close the multipart body
- (void)mg_appendMultipartFooter;

@end

