//
//  FirstViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "FMEngine.h"
#import "dispatch_cancelable_block.h"

@interface FeedViewController : UIViewController <UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITableViewDelegate, UISearchControllerDelegate, UISearchBarDelegate, UITableViewDataSource, UIScrollViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *songsCollectionView;
@property(nonatomic, strong) IBOutlet UICollectionView *playlistsCollectionView;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UISearchBar *searchBar;
@property(nonatomic, strong) NSIndexPath *editingIndexPath;


@end

