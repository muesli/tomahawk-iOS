//
//  StationsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "StationsViewController.h"

@implementation StationsViewController

-(IBAction)buttonHighlight:(UIButton *)button{
    if (button == self.artistsSeeAllInvisibleButton) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.artistsSeeAllButton.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }else if (button == self.internetRadioSeeAllInvisibleButton){
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.internetRadioSeeAllButton.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }
    
}
-(IBAction)buttonUnhighlight:(UIButton *)button{
    if (button == self.artistsSeeAllInvisibleButton) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.artistsSeeAllButton.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }else if (button == self.internetRadioSeeAllInvisibleButton){
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [self.internetRadioSeeAllButton.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }
}
-(IBAction)buttonSelected:(UIButton *)button{
    if (button == self.artistsSeeAllInvisibleButton) {
        [self.artistsSeeAllButton.titleLabel setAlpha:1];
    }else if (button == self.internetRadioSeeAllInvisibleButton){
        [self.internetRadioSeeAllButton.titleLabel setAlpha:1];
    }
}

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.internetRadio registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.followedArtists registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.internetRadio.backgroundColor = [UIColor clearColor];
    self.internetRadio.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.followedArtists.backgroundColor = [UIColor clearColor];
    self.followedArtists.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    NSArray *myArray = @[self.artistsSeeAllButton, self.internetRadioSeeAllButton];
    for (UIButton *buttons in myArray) {
        [buttons setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [buttons setTitleEdgeInsets:UIEdgeInsetsMake(0, -105.0, 0, 0)];
        [buttons setTitle:@"SEE ALL" forState:UIControlStateNormal];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.followedArtists]) {
        CollectionViewCell *followedArtists = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        followedArtists.image.image = [UIImage imageNamed:@"blurExample1"];
        followedArtists.detailImage.image = [UIImage imageNamed:@"headphone4.png"];
        followedArtists.title.text = @"Label";
        followedArtists.artist.text = @"Label";
        followedArtists.detailText.text = @"1234";
        return followedArtists;
    }else{
        CollectionViewCell *internetRadio = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        internetRadio.image.image = [UIImage imageNamed:@"blurExample2"];
        internetRadio.detailImage.image = [UIImage imageNamed:@"headphone4.png"];
        internetRadio.title.text = @"Label";
        internetRadio.artist.text = @"Label";
        internetRadio.detailText.text = @"1234";
        return internetRadio;
    }
}

@end
