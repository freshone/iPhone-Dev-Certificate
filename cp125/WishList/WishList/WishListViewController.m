//
//  MasterViewController.m
//  WishList
//
//  Created by Jeremy McCarthy on 2/4/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "WishListViewController.h"

#import "WishListItemViewController.h"

@implementation WishListViewController

@synthesize wishList;

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        self.title = @"Wish List";
    }
    return self;
}
							
- (void)dealloc
{
    [super dealloc];
}

- (void)addPushed
{
    WishListItemViewController *wishListItemViewController = 
        [[[WishListItemViewController alloc] initWithWishList:wishList] autorelease];
    [self.navigationController pushViewController:wishListItemViewController animated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (BOOL)canBecomeFirstResponder
{
    return YES;
}

#pragma mark - View lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Load from file if possible, otherwise create a new list
    self.wishList = [WishList loadWishListFromFile];
    if(!wishList) {
        self.wishList = [[[WishList alloc] init] autorelease];
    }
    self.clearsSelectionOnViewWillAppear = YES;
    self.navigationItem.title = @"Wish List";
    self.navigationItem.leftBarButtonItem = self.editButtonItem;
    self.navigationItem.rightBarButtonItem = [[[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemAdd target:self action:@selector(addPushed)] autorelease];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.wishList = nil;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.tableView reloadData];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
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

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [wishList countOfList];
}

// Customize the appearance of table view cells.
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:CellIdentifier] autorelease];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    WishListItem *itemForRow = [wishList objectInListAtIndex:indexPath.row];
    cell.textLabel.text = itemForRow.name;
    cell.detailTextLabel.text = [itemForRow.priceFormatter stringFromNumber:itemForRow.price];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Update the model
        [self.wishList removeObjectFromListAtIndex:indexPath.row];
        
        // Delete the row from the data source.
        [self.tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
    // Update the model
    WishListItem *itemToMove = [[self.wishList objectInListAtIndex:fromIndexPath.row] retain];
    [self.wishList removeObjectFromListAtIndex:fromIndexPath.row];
    [self.wishList insertObject:itemToMove inItemsAtIndex:toIndexPath.row];
    [itemToMove release];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    WishListItem *item = [wishList objectInListAtIndex:[indexPath row]];
    WishListItemViewController *wishListItemViewController = 
        [[[WishListItemViewController alloc] initWithWishListItem:item] autorelease];
    [self.navigationController pushViewController:wishListItemViewController animated:YES];
}

@end
