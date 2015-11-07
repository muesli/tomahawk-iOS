//
//  DiscoverViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "DiscoverViewController.h"


@interface DiscoverViewController (){
    UIButton *seeAllButton;
    UIButton *seeAllInvisible;
}

@end

@implementation DiscoverViewController

- (IBAction)inboxButton:(id)sender {
    //Insert Code
}

- (IBAction)simulateButtonPress:(UIButton *)sender {
    [seeAllButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonRelease:(UIButton *)sender {
    [seeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)reloadView{
    NSLog(@"Section is: %d", isSection);
    if (isSection == 0) {
        //Create Invisible See All Button to Act as A Presser
        seeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        seeAllInvisible.frame = CGRectMake(0, 0, 100, 50);
        [seeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [seeAllInvisible setBackgroundColor:[UIColor redColor]];
        [self.view addSubview:seeAllInvisible];
        [seeAllInvisible addTarget:self action:@selector(simulateButtonPress:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [seeAllInvisible addTarget:self action:@selector(simulateButtonRelease:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        //Create See All Button
        seeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [seeAllButton setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [seeAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [seeAllButton setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [seeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [seeAllButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[seeAllButton titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [seeAllButton setEnabled:NO];
        [seeAllButton setUserInteractionEnabled:NO];
        [self.view addSubview:seeAllButton];
        
        //Real Button Right
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:seeAllButton
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                             multiplier:0.95
                                                               constant:0.0]];
        
        //Real Button Top
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:seeAllButton
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:0.7
                                                               constant:0.0]];
        
        //Simulated Button Right
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:seeAllInvisible
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:seeAllButton
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:-49.0]];
        
        //Simulated Button Top
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:seeAllInvisible
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:seeAllButton
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        [seeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:seeAllInvisible
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationLessThanOrEqual
                                                                toItem:nil
                                                              attribute:NSLayoutAttributeHeight
                                                             multiplier:20.0
                                                               constant:15.0]];
        
        [seeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:seeAllInvisible
                                                                    attribute:NSLayoutAttributeWidth
                                                                    relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                       toItem:nil
                                                                    attribute:NSLayoutAttributeWidth
                                                                   multiplier:20.0
                                                                     constant:60.0]];
        
    }else{
    }
    

}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadView];
    _recommendedSongs.backgroundColor = [UIColor clearColor];
    _recommendedSongs.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
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
    
#pragma mark - Now Playing Bar
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    UITabBar *nowPlayingBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.tabBarController.tabBar.frame) - tabBarHeight*2.3 , viewWidth, CGRectGetHeight(self.tabBarController.tabBar.frame))];
    nowPlayingBar.barTintColor = [UIColor colorWithRed:37.0f/255.0f green:37.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    nowPlayingBar.translucent = YES;
    nowPlayingBar.barStyle = UIBarStyleBlack;
    _showNowPlaying.tintColor = [UIColor clearColor]; //Create invisible button to trigger the now playing segue
    [self.view addSubview:nowPlayingBar];
    [nowPlayingBar addSubview:_showNowPlaying]; //Add button to now playing bar
    
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
    UICollectionViewCell *recommendedSongs = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedSongs" forIndexPath:indexPath];
        return recommendedSongs;
    

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
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
            }
        }

    }else if (segmentedControl.selectedSegmentIndex == 2){
        isSection = 2;
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
            }
        }
    }else if (segmentedControl.selectedSegmentIndex == 3){
        isSection = 3;
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIButton class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    [_recommendedSongs reloadData];
    [self reloadView];
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end