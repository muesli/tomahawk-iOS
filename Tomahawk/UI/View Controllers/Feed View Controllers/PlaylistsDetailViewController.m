//
//  PlaylistsDetailViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "PlaylistsDetailViewController.h"
#import "TableViewCollectionViewCell.h"
#import "StickyHeaderFlowLayout.h"
#import "UIImageView+AFNetworking.h"


@interface PlaylistsDetailViewController () {
   NSArray *titles, *subtitles, *secondSubtitles, *images;
}

@property (assign, nonatomic) BOOL isLoading;
@property (strong, nonatomic) PlaylistDetailHeader *header;

@end



@implementation PlaylistsDetailViewController

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = [UIImage new];
    self.navigationController.navigationBar.translucent = YES;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor blackColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor blackColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.navigationController.navigationBar setBackgroundImage:nil forBarMetrics:UIBarMetricsDefault];
    self.navigationController.navigationBar.shadowImage = nil;
    self.navigationController.navigationBar.translucent = NO;
    self.navigationController.navigationBar.barTintColor = [UIColor blackColor];
    self.navigationController.navigationBar.tintColor = [UIColor whiteColor];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setNeedsStatusBarAppearanceUpdate];
    StickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[StickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 230);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
    }
    [self.collectionView registerNib:[UINib nibWithNibName:@"PlaylistDetailHeader" bundle:nil] forSupplementaryViewOfKind:StickyHeaderParallaxHeader withReuseIdentifier:@"header"];
    [self.collectionView.collectionViewLayout registerClass:[TableViewCollectionViewCell class] forDecorationViewOfKind:@"Separator"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TableViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    self.isLoading = YES;
}

- (void)response:(id)response {
    self.header.response = response;
    self.isLoading = NO;
    if ([response isKindOfClass:[NSError class]]) {
        NSLog(@"Error is: %@", response);
        //Error handeling
    } else {
        titles = [response objectForKey:@"songNames"];
        subtitles = [response objectForKey:@"artistNames"];
        images = [response objectForKey:@"songImages"];
        [self.collectionView reloadData];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (images.count == 0 && titles.count == 0 && subtitles.count == 0) {
        if (self.isLoading == YES) {
            UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            indicator.center = self.collectionView.center;
            self.collectionView.backgroundView = indicator;
            [indicator sizeToFit];
            [indicator startAnimating];
        } else {
            //Error;
        }
        return 0;
    } else {
        self.collectionView.backgroundView = nil;
       return 1;
    }
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titles.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = titles[indexPath.row];
    NSString *text = secondSubtitles[indexPath.row] ? [NSString stringWithFormat:@"%@ • %@", secondSubtitles[indexPath.row], subtitles[indexPath.row]] : subtitles[indexPath.row];
    cell.detailTextLabel.text = text;
    [images[indexPath.row] isKindOfClass:[NSNull class]] ? [cell.imageView setImage:[UIImage imageNamed:@"PlaceholderSongs"]] : [cell.imageView setImageWithURL:[NSURL URLWithString:images[indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderSongs"]];
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:StickyHeaderParallaxHeader]) {
        self.header = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
        self.header.frame = CGRectMake(0, -64, self.view.frame.size.width, 230);
        return self.header;
    } else {
        UICollectionReusableView *sectionHeader = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        return sectionHeader;
    }
}

#pragma mark <UICollectionViewDelegate>

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

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleDefault;
}



@end
