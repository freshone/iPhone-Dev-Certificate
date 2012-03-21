//
//  DetailViewController.h
//  WishList
//
//  Created by Jeremy McCarthy on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WishList.h"
#import "WishListItem.h"

@interface WishListItemViewController : UIViewController

@property (strong, nonatomic) WishList *wishList;
@property (strong, nonatomic) WishListItem *wishListItem;
@property (nonatomic, retain) IBOutlet UITextField *nameField;
@property (nonatomic, retain) IBOutlet UITextField *priceField;

- (id)initWithWishList:(WishList *)list;
- (id)initWithWishListItem:(WishListItem *)listItem;
- (IBAction)donePushed;
- (IBAction)cancelPushed;

@end
