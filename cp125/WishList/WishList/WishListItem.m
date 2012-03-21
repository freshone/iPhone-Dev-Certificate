//
//  WishlistItem.m
//  WishList
//
//  Created by Jeremy McCarthy on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishListItem.h"

@implementation WishListItem

@synthesize name;
@synthesize price;
@synthesize priceFormatter;

- (id)init
{
    self = [super init];
    self.priceFormatter = [[[NSNumberFormatter alloc] init] autorelease];
    self.priceFormatter.numberStyle = NSNumberFormatterCurrencyStyle;
    return self;
}

- (void)dealloc
{
    [name release];
    [price release];
    self.priceFormatter = nil;
    [super dealloc];
}

- (id)initWithCoder:(NSCoder *)coder
{
    self = [self init];
    self.name = [coder decodeObjectForKey:@"name"];
    self.price = [coder decodeObjectForKey:@"price"];
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:name forKey:@"name"];
    [coder encodeObject:price forKey:@"price"];
}

@end
