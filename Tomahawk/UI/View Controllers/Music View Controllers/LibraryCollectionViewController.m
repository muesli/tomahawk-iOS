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
#import "TableViewCollectionViewCell.h"

@interface LibraryCollectionViewController ()

@end

@implementation LibraryCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    StickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[StickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 230);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"LibraryHeader" bundle:nil] forSupplementaryViewOfKind:StickyHeaderParallaxHeader withReuseIdentifier:@"header"];
    [self.collectionView.collectionViewLayout registerClass:[TableViewCollectionViewCell class] forDecorationViewOfKind:@"Separator"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TableViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = @"Title";
    cell.detailTextLabel.text = @"Detail Title";
    cell.imageView.image = [UIImage imageNamed:@"PlaceholderSongs"];
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

- (void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCollectionViewCell* cell = (TableViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0];
}

- (void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCollectionViewCell* cell = (TableViewCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
}

@end
