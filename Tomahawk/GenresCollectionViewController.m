//
//  GenresCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "GenresCollectionViewController.h"

@implementation GenresCollectionViewController

-(void)viewDidLoad{
    [super viewDidLoad];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *genres = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    genres.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample5"]];
    genres.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
    genres.title = [[UILabel alloc]init];
    genres.artist = [[UILabel alloc]init];
    genres.detailText = [[UILabel alloc]init];
    genres.title.text = @"Label";
    genres.artist.text = @"Label";
    genres.detailText.text = @"1234";
    return genres;
}

@end
