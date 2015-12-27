//
//  StationsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "StationsViewController.h"

@implementation StationsViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.internetRadio registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.followedArtists registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
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
