//
//  SimpleImage.m
//  HW1_2
//
//  Created by 23 on 3/28/10.
//  Copyright 2010 RogueSheep. All rights reserved.
//

#import "SimpleImage.h"
#import <Quartz/Quartz.h>

@implementation SimpleImage

@synthesize image = image_;
@synthesize imageUID = imageUID_;



- (id) initWithImage:(NSImage*)image andImageUID:(NSString*)imageUID
{
	self = [super init];
	if (self != nil)
	{
		self.image = image;
		self.imageUID = imageUID;
	}
	return self;
}

- (void) dealloc
{
	self.image = nil;
	self.imageUID = nil;
	
	[super dealloc];
}


- (NSString *)  imageRepresentationType
{
    return IKImageBrowserNSImageRepresentationType;
}

- (id)  imageRepresentation
{
    return image_;
}

- (NSString *) imageUID
{
    return imageUID_;
}


@end
