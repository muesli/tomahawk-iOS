//
//  ForYouDiscoverViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ForYouDiscoverViewController.h"

@interface ForYouDiscoverViewController ()

@end

@implementation ForYouDiscoverViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.recommendedSongs registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.recommendedPlaylists registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.recommendedSongs]) {
        CollectionViewCell *recommendedSongs = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedSongs.image.image = [UIImage imageNamed:@"blurExample8"];
        recommendedSongs.detailImage.image = [UIImage imageNamed:@"headphone4.png"];
        recommendedSongs.title.text = @"Label";
        recommendedSongs.artist.text = @"Label";
        recommendedSongs.detailText.text = @"1234";
        return recommendedSongs;
    }else{
        CollectionViewCell *recommendedPlaylists = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        if (indexPath.row == 1) {
            recommendedPlaylists.image.image = [UIImage imageNamed:@"blurExample1"];
        }else if (indexPath.row == 2){
            recommendedPlaylists.image.image = [UIImage imageNamed:@"blurExample"];
        }else{
            recommendedPlaylists.image.image = [UIImage imageNamed:@"blurExample4"];
        }
        recommendedPlaylists.detailImage.image = [UIImage imageNamed:@"headphone4.png"];
        recommendedPlaylists.title.text = @"Label";
        recommendedPlaylists.artist.text = @"Label";
        recommendedPlaylists.detailText.text = @"1234";
        return recommendedPlaylists;
    }
}


@end
