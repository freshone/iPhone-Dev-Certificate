//
//  Wishlist.h
//  WishList
//
//  Created by Jeremy McCarthy on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "WishListItem.h"

@interface WishList : NSObject

@property (readwrite, retain) NSArray *list;

- (id)initWithCoder:(NSCoder *)decoder;
- (void)encodeWithCoder:(NSCoder *)coder;
+ (id)loadWishListFromFile;
- (void)saveWishListToFile;
- (NSUInteger)countOfList;
- (WishListItem *)objectInListAtIndex:(NSUInteger)index;
- (void)insertObject:(WishListItem *)item inItemsAtIndex:(NSUInteger)index;
- (void)removeObjectFromListAtIndex:(NSUInteger)index;
- (void)removeItemsAtIndexes:(NSIndexSet *)indexes;
- (void)exchangeObjectAtIndex:(NSUInteger)fromIndexPath withObjectAtIndex:(NSUInteger)toIndexPath;

@end
