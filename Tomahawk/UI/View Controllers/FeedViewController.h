//
//  FirstViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"

@interface FeedViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *songsCollectionView;
@property(nonatomic, strong) IBOutlet UICollectionView *playlistsCollectionView;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;


@end
