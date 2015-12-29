//
//  NavigationController.h
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchTableViewController.h"

@interface NavigationController : UINavigationController <UISearchBarDelegate>

@property (strong, nonatomic) UISearchBar *searchBar;

@end
