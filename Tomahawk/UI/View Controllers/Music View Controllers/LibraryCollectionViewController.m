//
//  LibraryCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 17/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

/*
#import "LibraryCollectionViewController.h"
#import "StickyHeaderFlowLayout.h"
#import "CustomUIButton.h"
#import "TableViewCollectionViewCell.h"
#import "NowPlayingViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TEngine.h"

@interface LibraryCollectionViewController () {
    NSArray *songNames, *songArtists, *songImages;
}

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
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"LibraryHeader" bundle:nil] forSupplementaryViewOfKind:StickyHeaderParallaxHeader withReuseIdentifier:@"header"];
    [self.collectionView.collectionViewLayout registerClass:[TableViewCollectionViewCell class] forDecorationViewOfKind:@"Separator"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TableViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [TEngine getTopTracksWithCompletionBlock:^(id response) {
        if ([response isKindOfClass:[NSError class]]) {
            
        } else {
            songNames = [response objectForKey:@"songNames"];
            songArtists = [response objectForKey:@"songArtists"];
            songImages = [response objectForKey:@"songImages"];
            [self.collectionView reloadData];
        }
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [songNames objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = [songArtists objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[songImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderSongs"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return songNames.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        UICollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        sectionHeader.backgroundColor = [UIColor whiteColor];
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        button.layer.borderWidth = 1;
        button.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
        [button setImage:[UIImage imageNamed:@"Down Chevron"] forState:UIControlStateNormal];
        [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 130.0)];
        [button setContentEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
        [button setTitle:@"TRACKS" forState:UIControlStateNormal];
        [button.titleLabel setFont:[UIFont systemFontOfSize:11 weight: UIFontWeightBold]];
        [button setTintColor:[UIColor blackColor]];
        button.layer.cornerRadius = 5;
        [sectionHeader addSubview:button];
        [button setTranslatesAutoresizingMaskIntoConstraints:NO];
        [sectionHeader addConstraint:[NSLayoutConstraint constraintWithItem:sectionHeader attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [sectionHeader addConstraint:[NSLayoutConstraint constraintWithItem:sectionHeader attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        [sectionHeader addConstraint:[NSLayoutConstraint constraintWithItem:sectionHeader attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
        [sectionHeader addConstraint:[NSLayoutConstraint constraintWithItem:sectionHeader attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
        [sectionHeader addConstraint:[NSLayoutConstraint constraintWithItem:sectionHeader attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1 constant:20]];
        return sectionHeader;
    } else {
        LibraryHeader *header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        header.delegate = self;
        return header;
    }
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
*/