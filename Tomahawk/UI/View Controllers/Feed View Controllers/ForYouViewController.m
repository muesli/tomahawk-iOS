//
//  ForYouViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ForYouViewController.h"
#import "THKCollectionViewCell.h"

@implementation ForYouViewController

//@implementation LibraryHeader  {
//    BDKCollectionIndexView *index;
//}
//
//
//-(void)awakeFromNib {
//    [super awakeFromNib];
//    [self.collectionView registerNib:[UINib nibWithNibName:@"THKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
//    index = [[BDKCollectionIndexView alloc]initWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 28, 10, 28, self.view.frame.size.height - 160) indexTitles:@[@"A",@"B",@"C", @"D", @"E", @"F", @"G", @"H", @"I", @"J", @"K", @"L", @"M", @"N", @"O", @"P", @"Q", @"R", @"S", @"T", @"U", @"V", @"W", @"X", @"Y", @"Z", @"#"]];
//    index.tintColor = [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)];
//    index.touchStatusViewAlpha = 0.0;
//    index.alpha = 0;
//    [self.view addSubview:index];
//}


-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self.recommendedGenres registerNib:[UINib nibWithNibName:@"THKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.recommendedStations registerNib:[UINib nibWithNibName:@"THKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:_recommendedStations]) {
        THKCollectionViewCell *recommendedStations = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedStations.imageView.image = [UIImage imageNamed:@"PlaceholderRadios"];
        return recommendedStations;
    }else{
        THKCollectionViewCell *recommendedGenres = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedGenres.imageView.image = [UIImage imageNamed:@"PlaceholderGenres"];
        return recommendedGenres;
    }
}

@end
