//
//  SimpleImage.h
//  HW1_2
//
//  Created by 23 on 3/28/10.
//  Copyright 2010 RogueSheep. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface SimpleImage : NSObject
{
	NSImage*			image_;
	NSString*			imageUID_;
}

@property (nonatomic, retain)	NSImage*	image;
@property (nonatomic, retain)	NSString*	imageUID;

- (id) initWithImage:(NSImage*)image andImageUID:(NSString*)imageUID;

@end
