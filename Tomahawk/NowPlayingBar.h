//
//  NowPlayingBar.h
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchBar.h"
#import "FMEngine.h"
#import "dispatch_cancelable_block.h"

@interface NowPlayingBar : UINavigationController <UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) SearchBar *searchBar;
@property (strong, nonatomic) UITableView *tableView;
@property(nonatomic, strong) NSIndexPath *editingIndexPath;

@end
