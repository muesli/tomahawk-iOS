//
//  DiscoverViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "DiscoverViewController.h"


@interface DiscoverViewController (){
    UIButton *songsSeeAllButton;
    UIButton *songsSeeAllInvisible;
    UIButton *playlistsSeeAllButton;
    UIButton *playlistsSeeAllInvisible;
    UILabel *playlistsHeader, *songsHeader;
    UIImageView *imageView;
}

@end

@implementation DiscoverViewController

- (IBAction)inboxButton:(id)sender {
    //TODO: Insert Code
}

- (IBAction)simulateButtonPress:(UIButton *)sender {
    [songsSeeAllButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonRelease:(UIButton *)sender {
    [songsSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonPress1:(UIButton *)sender {
    [playlistsSeeAllButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonRelease1:(UIButton *)sender {
    [playlistsSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)reloadView{
    NSLog(@"Section is: %d", isSection);
    if (isSection == 0) {
        songsHeader = [[UILabel alloc]init];
        songsHeader.text = @"RECOMMENDED SONGS";
        songsHeader.font = [UIFont systemFontOfSize:12 weight:0.2];
        songsHeader.alpha = 0.5;
        songsHeader.textColor = [UIColor whiteColor];
        [songsHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:songsHeader];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, CGRectGetWidth(self.view.frame), 140.0)];
        [self.scrollView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"12.png"]];
        //Create Invisible See All Button to Act as A Presser
        songsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        //[seeAllInvisible setBackgroundColor:[UIColor redColor]];
        [songsSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:songsSeeAllInvisible];
        [songsSeeAllInvisible addTarget:self action:@selector(simulateButtonPress:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [songsSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        //Create See All Button
        songsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [songsSeeAllButton setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [songsSeeAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [songsSeeAllButton setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [songsSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[songsSeeAllButton titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [songsSeeAllButton setEnabled:NO];
        [songsSeeAllButton setUserInteractionEnabled:NO];
        [songsSeeAllButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:songsSeeAllButton];

        
        playlistsHeader = [[UILabel alloc]init];
        playlistsHeader.text = @"RECOMMENDED PLAYLISTS";
        playlistsHeader.font = [UIFont systemFontOfSize:12 weight:0.2];
        playlistsHeader.alpha = 0.5;
        playlistsHeader.textColor = [UIColor whiteColor];
        [playlistsHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:playlistsHeader];
        //Create Invisible See All Button to Act as A Presser
        playlistsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        //[seeAllInvisible setBackgroundColor:[UIColor redColor]];
        [playlistsSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:playlistsSeeAllInvisible];
        [playlistsSeeAllInvisible addTarget:self action:@selector(simulateButtonPress1:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [playlistsSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease1:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        //Create See All Button
        playlistsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [playlistsSeeAllButton setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [playlistsSeeAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [playlistsSeeAllButton setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [playlistsSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[playlistsSeeAllButton titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [playlistsSeeAllButton setEnabled:NO];
        [playlistsSeeAllButton setUserInteractionEnabled:NO];
        [playlistsSeeAllButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:playlistsSeeAllButton];
        [self autoLayoutConstraints];

    }else{
    }
    

}

#pragma mark - Auto Layout Constraints

- (void)autoLayoutConstraints{
    
    //Real Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1
                                                           constant:50.0]];
    
    //Real Button Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:165]];
    
    //Simulated Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:songsSeeAllButton
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:-49.0]];
    
    //Simulated Button Top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:songsSeeAllButton
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    //Simulated Height
    [songsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:20.0
                                                                      constant:15.0]];
    
    //Simulated Width
    [songsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:20.0
                                                                      constant:60.0]];
    
    //Header Left
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsHeader
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1
                                                           constant:10.0]];
    
    //Header Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:songsHeader
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:165]];
    
    //Real Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1
                                                           constant:50.0]];
    
    //Real Button Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:412]];
    
    //Simulated Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:playlistsSeeAllButton
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:-49.0]];
    
    //Simulated Button Top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:playlistsSeeAllButton
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    //Simulated Height
    [playlistsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:20.0
                                                                      constant:15.0]];
    
    //Simulated Width
    [playlistsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:20.0
                                                                      constant:60.0]];
    
    //Header Left
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsHeader
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1
                                                           constant:10.0]];
    
    //Header Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:playlistsHeader
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:412]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadView];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    _recommendedSongs.backgroundColor = [UIColor clearColor];
    _recommendedSongs.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _recommendedPlaylists.backgroundColor = [UIColor clearColor];
    _recommendedPlaylists.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    //    [self setNeedsStatusBarAppearanceUpdate];
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
#pragma mark - Search Controller
    //Creating Search Controller
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:self];
    // Use the current view controller to update the search results.
    searchController.searchResultsUpdater = self;
    //Setting Style
    searchController.searchBar.barStyle = UIBarStyleBlack;
    searchController.searchBar.barTintColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1.0];
    searchController.searchBar.backgroundImage = [UIImage imageNamed:@"BG"];
    searchController.searchBar.placeholder = @"Search Artists, Songs, Albums etc.";
    searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    self.definesPresentationContext = YES;
    self.navigationItem.titleView = searchController.searchBar;
    
#pragma mark - Custom Segmented Control
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"FOR YOU", @"CHARTS", @"LIKED", @" NEW SONGS"]];
    //First value: Left padding Second value: Top padding Third Value: Width Fourth Value: Height
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    segmentedControl.frame = CGRectMake(0, 0, viewWidth *0.97, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    UIView *barbackground = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(segmentedControl.frame), viewWidth, CGRectGetHeight(segmentedControl.frame))];
    barbackground.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    [self.view addSubview:barbackground];
    [self.view addSubview:segmentedControl];
    

}

#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isSection == 0) {
        return 14;
    }else{
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _recommendedSongs) {
        CollectionViewCell *recommendedSongs = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedSongs" forIndexPath:indexPath];
        return recommendedSongs;
    }else if (collectionView == _recommendedPlaylists){
        CollectionViewCell *recommendedPlaylists = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedPlaylists" forIndexPath:indexPath];
        return recommendedPlaylists;
    }
    return nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        isSection = 0;
    }else if (segmentedControl.selectedSegmentIndex == 1){
        isSection = 1;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }

    }else if (segmentedControl.selectedSegmentIndex == 2){
        isSection = 2;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
    }else if (segmentedControl.selectedSegmentIndex == 3){
        isSection = 3;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    [_recommendedSongs reloadData];
    [_recommendedPlaylists reloadData];
    [self reloadView];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end