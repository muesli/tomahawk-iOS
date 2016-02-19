//
//  LibraryCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 17/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "LibraryCollectionViewController.h"
#import "LibraryHeader.h"
#import "StickyHeaderFlowLayout.h"
#import "CustomUIButton.h"

@interface LibraryCollectionViewController ()

@end

@implementation LibraryCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    StickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[StickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 230);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 230);
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"LibraryHeader" bundle:nil] forSupplementaryViewOfKind:StickyHeaderParallaxHeader withReuseIdentifier:@"header"];
    [self.collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor redColor];
    return cell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LibraryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    return header;
}



@end
