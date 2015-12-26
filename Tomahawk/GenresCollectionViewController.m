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
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.collectionView.backgroundColor = [UIColor clearColor];
    self.collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 15;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *genres = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    genres.image.image = [UIImage imageNamed:@"blurExample5"];
    genres.detailImage.image = [UIImage imageNamed:@"headphone4.png"];
    genres.title.text = @"Label";
    genres.artist.text = @"Label";
    genres.detailText.text = @"1234";
    return genres;
}

@end
