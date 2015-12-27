//
//  ForYouViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ForYouViewController.h"

@implementation ForYouViewController

-(IBAction)buttonHighlight:(UIButton *)button{
    if (button == self.stationsSeeAllInvisibleButton) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.stationsSeeAllButton.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }else if (button == self.genresSeeAllInvisibleButton){
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.genresSeeAllButton.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }
    
}
-(IBAction)buttonUnhighlight:(UIButton *)button{
    if (button == self.stationsSeeAllInvisibleButton) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.stationsSeeAllButton.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }else if (button == self.genresSeeAllInvisibleButton){
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.genresSeeAllButton.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }
}
-(IBAction)buttonSelected:(UIButton *)button{
    if (button == self.stationsSeeAllInvisibleButton) {
        [self.stationsSeeAllButton.titleLabel setAlpha:1];
    }else if (button == self.genresSeeAllInvisibleButton){
        [self.genresSeeAllButton.titleLabel setAlpha:1];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.recommendedGenres registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.recommendedStations registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.recommendedGenres.backgroundColor = [UIColor clearColor];
    self.recommendedGenres.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.recommendedStations.backgroundColor = [UIColor clearColor];
    self.recommendedStations.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

    NSArray *myArray = @[self.stationsSeeAllButton, self.genresSeeAllButton];
    for (UIButton *buttons in myArray) {
        [buttons setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [buttons setTitleEdgeInsets:UIEdgeInsetsMake(0, -105.0, 0, 0)];
    }

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_recommendedStations]) {
        CollectionViewCell *recommendedStations = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedStations.image.image = [UIImage imageNamed:@"blurExample5"];
        recommendedStations.detailImage.image = [UIImage imageNamed:@"headphone4.png"];
        recommendedStations.title.text = @"Label";
        recommendedStations.artist.text = @"Label";
        recommendedStations.detailText.text = @"1234";
        return recommendedStations;
    }else{
        CollectionViewCell *recommendedGenres = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            recommendedGenres.image.image = [UIImage imageNamed:@"blurExample3"];
        }else if (indexPath.row == 2){
            recommendedGenres.image.image = [UIImage imageNamed:@"blurExample2"];
        }else{
            recommendedGenres.image.image = [UIImage imageNamed:@"blurExample6"];
        }
        recommendedGenres.detailImage.image = [UIImage imageNamed:@"headphone4.png"];
        recommendedGenres.title.text = @"Label";
        recommendedGenres.artist.text = @"Label";
        recommendedGenres.detailText.text = @"1234";
        return recommendedGenres;
    }
}

@end
