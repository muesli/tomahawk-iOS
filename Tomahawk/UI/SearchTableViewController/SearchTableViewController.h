//
//  SearchTableViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 29/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TEngine.h"
#import "dispatch_cancelable_block.h"
#import "DGActivityIndicatorView.h"
#import "UIImageView+AFNetworking.h"
#import "CustomTableViewCell.h"
#import "DetailTableViewController.h"

@interface SearchTableViewController : UITableViewController <UISearchBarDelegate>

@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;

@end
