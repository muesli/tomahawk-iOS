//
//  ArtistDetailCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 05/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "ArtistDetailCollectionViewController.h"
#import "StickyHeaderFlowLayout.h"
#import "ArtistsHeader.h"


@implementation ArtistDetailCollectionViewController

-(IBAction)back:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.hidden = YES;
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.navigationBar.hidden = NO;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    StickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    UIImageView *statusBarBG = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    statusBarBG.image = [self.artistImage crop:CGRectMake(0, 0, self.view.frame.size.width, 20)];
    UIVisualEffectView *view = [[UIVisualEffectView alloc]initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    view.frame = statusBarBG.frame;
    view.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.45];
    [self.view addSubview:statusBarBG];
    [statusBarBG addSubview:view];
    if ([layout isKindOfClass:[StickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 300);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 95);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
        layout.parallaxHeaderAlwaysOnTop = YES;
        layout.disableStickyHeaders = YES;
    }
    
    [self.collectionView registerNib:[UINib nibWithNibName:@"ArtistsHeader" bundle:nil] forSupplementaryViewOfKind:StickyHeaderParallaxHeader withReuseIdentifier:@"header"];
    
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 20;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    ArtistsHeader *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
    cell.navigationBarArtistImage.image = self.artistImage;
    cell.artistImage.image = self.artistImage;
    cell.titleLabel.text = self.artistName;
    cell.backgroundImageView.image = self.artistImage;
    return cell;
}



@end
