//
//  MasterViewController.h
//  WishList
//
//  Created by Jeremy McCarthy on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishList.h"

@class WishListItemViewController;

@interface WishListViewController : UITableViewController

@property (nonatomic, retain) WishList *wishList;

- (void)addPushed;

@end
