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

- (IBAction)seeAllReal:(UIButton *)sender {
    [_seeAll setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)seeAllRealReleased:(UIButton *)sender {
    [_seeAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

- (IBAction)seeAllPlaylistsReal:(UIButton *)sender {
    [_seeAllPlaylists setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)seeAllPlaylistsRealReleased:(UIButton *)sender {
    [_seeAllPlaylists setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [_button setBackgroundColor:[UIColor redColor]];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    //Set See All Button Stuff
    [_seeAll setImage: [UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
    [_seeAll setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
    [_seeAll setTitle:@"SEE ALL" forState:UIControlStateNormal];
    [_seeAll setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [_seeAllPlaylists setImage: [UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
    [_seeAllPlaylists setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
    [_seeAllPlaylists setTitle:@"SEE ALL" forState:UIControlStateNormal];
    [_seeAllPlaylists setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    //Remove Background on Collection Views
    _songsCollectionView.backgroundColor = [UIColor clearColor];
    _songsCollectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _playlistsCollectionView.backgroundColor = [UIColor clearColor];
    _playlistsCollectionView.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    //Remove 1px border on Navigation controller and set statusbar style to light
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
-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 3;
}
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _songsCollectionView) {
        CollectionViewCell *recentSongsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recentSongsCell" forIndexPath:indexPath];
            return recentSongsCell;
    }else if (collectionView == _playlistsCollectionView){
    CollectionViewCell *recentPlaylistsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recentPlaylistsCell" forIndexPath:indexPath];
    return recentPlaylistsCell;
    }
    return nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
