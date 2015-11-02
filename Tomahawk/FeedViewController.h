//
//  FirstViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"

@interface FeedViewController : UIViewController <UISearchResultsUpdating, UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UIButton *showNowPlaying;
@property(nonatomic, strong) IBOutlet UICollectionView *collectionView;


@end

