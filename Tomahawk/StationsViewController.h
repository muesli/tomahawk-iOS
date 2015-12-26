//
//  StationsViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"

@interface StationsViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *followedArtists;
@property(nonatomic, strong) IBOutlet UICollectionView *internetRadio;
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property(strong, nonatomic) IBOutlet UIButton *artistsSeeAllButton;
@property(strong, nonatomic) IBOutlet UIButton *artistsSeeAllInvisibleButton;
@property(strong, nonatomic) IBOutlet UIButton *internetRadioSeeAllButton;
@property(strong, nonatomic) IBOutlet UIButton *internetRadioSeeAllInvisibleButton;

@end
