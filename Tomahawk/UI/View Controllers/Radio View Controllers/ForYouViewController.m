//
//  ForYouViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ForYouViewController.h"
#import "CollectionViewCell.h"

@implementation ForYouViewController


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.recommendedGenres registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.recommendedStations registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_recommendedStations]) {
        CollectionViewCell *recommendedStations = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedStations.image.image = [UIImage imageNamed:@"PlaceholderRadios"];
        return recommendedStations;
    }else{
        CollectionViewCell *recommendedGenres = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedGenres.image.image = [UIImage imageNamed:@"PlaceholderGenres"];
        return recommendedGenres;
    }
}

@end
