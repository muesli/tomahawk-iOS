//
//  SearchTableViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 29/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchTableViewController : UITableViewController <UISearchControllerDelegate, UISearchResultsUpdating, UISearchBarDelegate>

@property (strong, nonatomic) UISearchController *searchController;

@end
