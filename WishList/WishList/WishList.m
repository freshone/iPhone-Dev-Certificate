//
//  Wishlist.m
//  WishList
//
//  Created by Jeremy McCarthy on 2/12/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishList.h"
#import "WishListItem.h"

@implementation WishList

static NSString *WISHLIST_FILENAME = @"WishList.archive";

@synthesize list;

- (id)init
{
    self = [super init];
    self.list = [NSMutableArray array];
    return self;
}

- (void)dealloc
{
    [list release];
    [super dealloc];    
}

- (id)initWithCoder:(NSCoder *)decoder
{
    if ((self = [super init])) {
        self.list = [decoder decodeObjectForKey:@"list"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)coder
{
    [coder encodeObject:self.list forKey:@"list"];
}

+ (id)loadWishListFromFile
{
    NSURL *documentsURL = [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    NSURL *wishListURL = [documentsURL URLByAppendingPathComponent:WISHLIST_FILENAME];
    NSData *wishListData = [NSData dataWithContentsOfURL:wishListURL];
    
    WishList *wishList = nil;
    
    if (wishListData) {
        wishList = [NSKeyedUnarchiver unarchiveObjectWithData:[NSData dataWithContentsOfURL:wishListURL]];
    }
    
    return wishList;
}

- (void)saveWishListToFile
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSURL *documentsURL = [[fileManager URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
    [fileManager createDirectoryAtURL:documentsURL withIntermediateDirectories:YES attributes:nil error:nil];
    NSURL *wishListURL = [documentsURL URLByAppendingPathComponent:WISHLIST_FILENAME];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self];
    [data writeToURL:wishListURL atomically:YES];
}

- (NSUInteger)countOfList
{
    return self.list.count;
}

- (WishListItem *)objectInListAtIndex:(NSUInteger)index
{
    return [self.list objectAtIndex:index];
}

- (void)insertObject:(WishListItem *)item inItemsAtIndex:(NSUInteger)index;
{
    [(NSMutableArray *)(self.list) insertObject:item atIndex:index];
}

- (void)removeObjectFromListAtIndex:(NSUInteger)index
{
    [(NSMutableArray *)(self.list) removeObjectAtIndex:index];
}

- (void)removeItemsAtIndexes:(NSIndexSet *)indexes
{
    [(NSMutableArray *)(self.list) removeObjectsAtIndexes:indexes];
}

- (void)exchangeObjectAtIndex:(NSUInteger)fromIndexPath withObjectAtIndex:(NSUInteger)toIndexPath
{
    [(NSMutableArray *)(self.list) exchangeObjectAtIndex:fromIndexPath withObjectAtIndex:toIndexPath];
}

@end
