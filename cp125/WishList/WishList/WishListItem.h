//
//  WishlistItem.h
//  WishList
//
//  Created by Jeremy McCarthy on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WishListItem : NSObject <NSCoding>

@property (readwrite, retain) NSString *name;
@property (readwrite, retain) NSDecimalNumber *price;
@property (readwrite, retain) NSNumberFormatter *priceFormatter;

- (id)initWithCoder:(NSCoder *)coder;
- (void)encodeWithCoder:(NSCoder *)coder;

@end
