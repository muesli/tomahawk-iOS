//
//  RadioViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 11/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "CollectionViewCell.h"

//int isSection = 0;

@interface RadioViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property(nonatomic, strong) IBOutlet UICollectionView *recommendedStations;
@property(nonatomic, strong) IBOutlet UICollectionView *recommendedGenres;
@property(strong, nonatomic) IBOutlet UIScrollView *scrollView;

@end
