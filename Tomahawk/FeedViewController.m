//
//  FirstViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController (){
    UIButton *songsSeeAllButton;
    UIButton *songsSeeAllInvisible;
    UIButton *playlistsSeeAllButton;
    UIButton *playlistsSeeAllInvisible;
    UILabel *playlistsHeader, *songsHeader;
}



@end

@implementation FeedViewController

- (IBAction)inboxButton:(id *)sender {
    //Insert Code Here
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


- (void)viewDidLoad {
    [super viewDidLoad];
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    //Set See All Button Stuff
    songsHeader = [[UILabel alloc]init];
    songsHeader.text = @"RECENT SONGS";
    songsHeader.font = [UIFont systemFontOfSize:12 weight:0.2];
    songsHeader.alpha = 0.5;
    songsHeader.textColor = [UIColor whiteColor];
    [songsHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
    [_scrollView addSubview:songsHeader];
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
    playlistsHeader.text = @"RECENT PLAYLISTS";
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
        recentSongsCell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        recentSongsCell.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample1"]];
        recentSongsCell.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        recentSongsCell.title = [[UILabel alloc]init];
        recentSongsCell.artist = [[UILabel alloc]init];
        recentSongsCell.detailText = [[UILabel alloc]init];
        recentSongsCell.title.text = @"Label";
        recentSongsCell.artist.text = @"Label";
        recentSongsCell.detailText.text = @"1234";
        recentSongsCell.big = NO;
        return recentSongsCell;
    }else if (collectionView == _playlistsCollectionView){
        CollectionViewCell *recentPlaylistsCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"recentPlaylistsCell" forIndexPath:indexPath];
        recentPlaylistsCell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        recentPlaylistsCell.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample7"]];
        recentPlaylistsCell.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        recentPlaylistsCell.title = [[UILabel alloc]init];
        recentPlaylistsCell.artist = [[UILabel alloc]init];
        recentPlaylistsCell.detailText = [[UILabel alloc]init];
        recentPlaylistsCell.title.text = @"Label";
        recentPlaylistsCell.artist.text = @"Label";
        recentPlaylistsCell.detailText.text = @"1234";
        recentPlaylistsCell.big = NO;
        return recentPlaylistsCell;
    }
    return nil;
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
                                                             constant:20]];
    
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
                                                             constant:20]];
    
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
                                                             constant:267]];
    
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
                                                             constant:267]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
