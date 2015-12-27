//
//  ForYouDiscoverViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdditions.h"
#import "CollectionViewCell.h"

@interface ForYouDiscoverViewController : UIViewController<UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *recommendedSongs;
@property(nonatomic, strong) IBOutlet UICollectionView *recommendedPlaylists;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
