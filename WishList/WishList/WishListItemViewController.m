//
//  DetailViewController.m
//  WishList
//
//  Created by Jeremy McCarthy on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishListItemViewController.h"

@implementation WishListItemViewController

@synthesize wishList;
@synthesize wishListItem;
@synthesize nameField;
@synthesize priceField;

- (id)initWithWishList:(WishList *)list
{
    self = [super init];
    self.wishList = list;
    self.title = @"Add Item";
    return self;
}

- (id)initWithWishListItem:(WishListItem *)listItem
{
    self = [super init];
    self.wishListItem = listItem;
    self.title = @"Edit Item";
    return self;
}

- (void)dealloc
{
    self.wishList = nil;
    self.wishListItem = nil;
    self.nameField = nil;
    self.priceField = nil;
    
    [super dealloc];
}

#pragma mark - Managing the detail item

- (void)donePushed
{
    // if creating a new item, init and add to the list
    if(wishListItem == nil) {
        self.wishListItem = [[[WishListItem alloc] init] autorelease];
        [self.wishList insertObject:self.wishListItem inItemsAtIndex:[self.wishList countOfList]];
    }
    
    self.wishListItem.name = nameField.text;
    self.wishListItem.price = (NSDecimalNumber *)[self.wishListItem.priceFormatter numberFromString:self.priceField.text];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)cancelPushed
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.navigationItem.leftBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancelPushed)] autorelease];
    
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePushed)] autorelease];
}

- (void)viewDidUnload
{
    self.nameField = nil;
    self.priceField = nil;
    
    [super viewDidUnload];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if(wishListItem) {
        self.nameField.text = self.wishListItem.name;
        self.priceField.text = [self.wishListItem.priceFormatter stringFromNumber:self.wishListItem.price];
    }
    
    if([self.priceField.text isEqualToString:@""] || self.priceField.text == nil) {
        self.priceField.text = @"$";
    }
    
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self.nameField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
	[super viewWillDisappear:animated];
}

- (void)viewDidDisappear:(BOOL)animated
{
	[super viewDidDisappear:animated];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"";
    }
    return self;
}
							
@end
