//
//  NSMutableData+MGMultipartFormData.m
//  Minigram 2
//
//  Created by Luke Adamson on 2/27/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "NSMutableData+MGMultipartFormData.h"

static NSString *MGMultipartBoundary = @"multipart-form-data-boundary-marker";

@interface NSString (MGMultipartFormData)
- (NSData *)mg_UTF8Data; // Shorter to type than [someString dataUsingEncoding:UTF8StringEncoding];
@end

@implementation NSData (MGMultipartFormData)

+ (NSString *)mg_contentTypeForMultipartFormData;
{
    return [NSString stringWithFormat:@"multipart/form-data; boundary=%@", MGMultipartBoundary];
}

@end

@implementation NSMutableData (MGMultipartFormData)

- (void)mg_appendFormValue:(NSString *)stringValue forKey:(NSString *)formKey;
{
    [self appendData:[[NSString stringWithFormat:@"--%@\r\n", MGMultipartBoundary] mg_UTF8Data]];
    [self appendData:[[NSString stringWithFormat:@"content-disposition: form-data; name=\"%@\"\r\n\r\n", formKey] mg_UTF8Data]];
    [self appendData:[[NSString stringWithFormat:@"%@\r\n", stringValue] mg_UTF8Data]];
}

- (void)mg_appendFileData:(NSData *)data forKey:(NSString *)formKey filename:(NSString *)filename mimeType:(NSString *)mimeType;
{
    [self appendData:[[NSString stringWithFormat:@"--%@\r\n", MGMultipartBoundary] mg_UTF8Data]];
    [self appendData:[[NSString stringWithFormat:@"content-disposition: form-data; name=\"%@\"; filename=\"%@\"\r\n", formKey, filename] mg_UTF8Data]];
    [self appendData:[[NSString stringWithFormat:@"content-type: %@\r\n\r\n", mimeType] mg_UTF8Data]];

    [self appendData:data];
    
    [self appendData:[@"\r\n" mg_UTF8Data]];
}

- (void)mg_appendMultipartFooter;
{
    [self appendData:[[NSString stringWithFormat:@"--%@--\r\n", MGMultipartBoundary] mg_UTF8Data]];
}

@end

@implementation NSString (MGMultipartFormData)

- (NSData *)mg_UTF8Data;
{
    return [self dataUsingEncoding:NSUTF8StringEncoding];
}

@end


