//
//  FirstViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController ()



@end

@implementation FeedViewController

- (IBAction)inboxButton:(id *)sender {
    //Insert Code Here
}



- (void)viewDidLoad {
    _collectionView.backgroundColor = [UIColor clearColor];
    _collectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    [super viewDidLoad];
    
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
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionViewCell *recentSongsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recentSongsCell" forIndexPath:indexPath];
    return recentSongsCell;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
