//
//  LibraryHeader.m
//  Tomahawk
//
//  Created by Mark Bourke on 17/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "LibraryHeader.h"
#import "CollectionViewCell.h"

@implementation LibraryHeader


-(void)awakeFromNib {
    [super awakeFromNib];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}


@end
