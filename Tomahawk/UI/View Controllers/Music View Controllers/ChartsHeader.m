//
//  LibraryHeader.m
//  Tomahawk
//
//  Created by Mark Bourke on 17/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "ChartsHeader.h"
#import "THKCollectionViewCell.h"
#import "StickyHeaderFlowLayoutAttributes.h"

@implementation ChartsHeader


-(void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

//- (void)applyLayoutAttributes:(StickyHeaderFlowLayoutAttributes *)layoutAttributes {
//    NSLog(@"Delegate sent");
//    [self.delegate headerDidScrollWithProgress:layoutAttributes.progressiveness];
//}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    THKCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"Title";
    cell.detailTextLabel.text = @"Artist";
    cell.imageView.image = [UIImage imageNamed:@"PlaceholderCountryCharts"];
    return cell;
}


@end
