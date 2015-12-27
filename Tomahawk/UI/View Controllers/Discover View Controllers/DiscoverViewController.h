//
//  DIscoverViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "CollectionViewCell.h"

int isSection = 0;

@interface DiscoverViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *recommendedSongs;
@property(nonatomic, strong) IBOutlet UICollectionView *recommendedPlaylists;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;



@end
