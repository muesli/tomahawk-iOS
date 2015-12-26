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

-(void)viewDidLoad{
    [super viewDidLoad];
    self.internetRadio.backgroundColor = [UIColor clearColor];
    self.internetRadio.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    self.followedArtists.backgroundColor = [UIColor clearColor];
    self.followedArtists.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [self.scrollView setContentSize:CGSizeMake(self.view.frame.size.width,1000)];
    
    NSArray *myArray = @[self.artistsSeeAllButton, self.internetRadioSeeAllButton];
    for (UIButton *buttons in myArray) {
        [buttons setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [buttons setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [buttons setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [buttons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[buttons titleLabel] setFont:[UIFont systemFontOfSize:12]];
    }
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.followedArtists]) {
        CollectionViewCell *followedArtists = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        followedArtists.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample1"]];
        followedArtists.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        followedArtists.title = [[UILabel alloc]init];
        followedArtists.artist = [[UILabel alloc]init];
        followedArtists.detailText = [[UILabel alloc]init];
        followedArtists.title.text = @"Label";
        followedArtists.artist.text = @"Label";
        followedArtists.detailText.text = @"1234";
        return followedArtists;
    }else{
        CollectionViewCell *internetRadio = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        internetRadio.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample2"]];
        internetRadio.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        internetRadio.title = [[UILabel alloc]init];
        internetRadio.artist = [[UILabel alloc]init];
        internetRadio.detailText = [[UILabel alloc]init];
        internetRadio.title.text = @"Label";
        internetRadio.artist.text = @"Label";
        internetRadio.detailText.text = @"1234";
        return internetRadio;
    }
}

@end
