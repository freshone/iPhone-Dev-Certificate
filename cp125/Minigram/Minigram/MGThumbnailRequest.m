//
//  MGThumbnailRequest.m
//  Minigram
//
//  Created by Jeremy McCarthy on 3/27/12.
//  Copyright (c) 2012 Luke Adamson. All rights reserved.
//

#import "MGThumbnailRequest.h"

@implementation MGThumbnailRequest

@synthesize photo = _photo;
@synthesize indexPath = _indexPath;

#pragma mark -
#pragma mark Constant Declarations

- (void)send
{
    [[self photo] setThumbnail:nil];
    NSURLRequest *request = [NSURLRequest requestWithURL:[[self photo] thumbnailUrl]];
    [self setHttpConnection:[[NSURLConnection alloc] initWithRequest:request delegate:self]];
    [super send];
}

- (void)connectionDidFinishLoading:(NSURLConnection*)connection
{
    UIImage *image = [UIImage imageWithData:[self responseData]];
    UIImage *placeholder = [UIImage imageNamed:@"Placeholder.png"];
    
    // Make a square thumbnail out of this badboy
    if (image.size.width != placeholder.size.width && image.size.height != placeholder.size.height)
	{
        CGSize itemSize = CGSizeMake(placeholder.size.width, placeholder.size.height);
		UIGraphicsBeginImageContext(itemSize);
		CGRect imageRect = CGRectMake(0.0, 0.0, itemSize.width, itemSize.height);
		[image drawInRect:imageRect];
		image = UIGraphicsGetImageFromCurrentImageContext();
		UIGraphicsEndImageContext();
    }
    
    [[self photo] setThumbnail:image];
    [self setResponseData:nil];
    [self setHttpConnection:nil];
    [[self delegate] requestDidComplete:self];
}

@end
