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
#import "NowPlayingViewController.h"

@interface LibraryCollectionViewController ()

@end

@implementation LibraryCollectionViewController

- (void)viewDidAppear:(BOOL)animated {
    [self performBlock:^{
        NSArray *indexPath = [self.collectionView indexPathsForSelectedItems];
        if (indexPath.count != 0) {
            [self updateCellColorWithTint:NO atIndexPath:indexPath[0] animated:YES];
            [self.collectionView deselectItemAtIndexPath:indexPath[0] animated:NO];
        }
    } afterDelay:0.2];
}

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

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    LibraryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    return header;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self updateCellColorWithTint:YES atIndexPath:indexPath animated:NO];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateCellColorWithTint:NO atIndexPath:indexPath animated:NO];
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateCellColorWithTint:YES atIndexPath:indexPath animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self updateCellColorWithTint:NO atIndexPath:indexPath animated:NO];
}

- (void)updateCellColorWithTint:(BOOL)tint atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    TableViewCollectionViewCell* cell = (TableViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        cell.backgroundColor = tint ? [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0] : [UIColor clearColor];
        [UIView commitAnimations];
    } else {
       cell.backgroundColor = tint ? [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0] : [UIColor clearColor];
    }
    
}

@end
