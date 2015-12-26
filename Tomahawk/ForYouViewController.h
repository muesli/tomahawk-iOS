//
//  ForYouViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"

@interface ForYouViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *recommendedStations;
@property(nonatomic, strong) IBOutlet UICollectionView *recommendedGenres;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(strong, nonatomic) IBOutlet UIButton *stationsSeeAllButton;
@property(strong, nonatomic) IBOutlet UIButton *stationsSeeAllInvisibleButton;
@property(strong, nonatomic) IBOutlet UIButton *genresSeeAllButton;
@property(strong, nonatomic) IBOutlet UIButton *genresSeeAllInvisibleButton;

@end
