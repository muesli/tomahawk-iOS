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
    if (sender == songsSeeAllInvisible) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [songsSeeAllButton.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }else{
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [playlistsSeeAllButton.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }
}
- (IBAction)simulateButtonRelease:(UIButton *)sender {
    if (sender == songsSeeAllInvisible) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [songsSeeAllButton.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }else{
    [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         [playlistsSeeAllButton.titleLabel setAlpha:1];
                     }
                     completion:nil];
    }
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    FMEngine *albumInfo = [[FMEngine alloc]initWithArtist:@"Justin Bieber" album:@"Believe"];
    
    NSArray *searchResults = [albumInfo searchSongs:@"Boyfriend" artist:@"Justin Bieber"];
    
    NSString *imageURLAsString = [[[searchResults objectAtIndex:3]objectForKey:@"images"]objectAtIndex:3];
    NSURL *imageURL = [NSURL URLWithString:imageURLAsString];
    NSData *rawImageData = [[NSData alloc]initWithContentsOfURL:imageURL];
    UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageWithData:rawImageData]];
    [self.view addSubview:image];
    
    
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    songsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    playlistsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
    NSArray *myArray = [[NSArray alloc]initWithObjects:songsSeeAllButton,playlistsSeeAllButton, nil];
    for (UIButton *buttons in myArray) {
        [buttons setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [buttons setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [buttons setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [buttons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[buttons titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [buttons setEnabled:NO];
        [buttons setUserInteractionEnabled:NO];
        [buttons setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:buttons];
    }
    playlistsHeader = [[UILabel alloc]init];
    playlistsHeader.text = @"RECENT PLAYLISTS";
    songsHeader = [[UILabel alloc]init];
    songsHeader.text = @"RECENT SONGS";
    myArray = [[NSArray alloc]initWithObjects:songsHeader,playlistsHeader, nil];
    for (UILabel *headers in myArray) {
        headers.font = [UIFont systemFontOfSize:12 weight:0.2];
        headers.alpha = 0.5;
        headers.textColor = [UIColor whiteColor];
        [headers setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:headers];
    }
    
    //Create Invisible Buttons to Act as Pressers
    playlistsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
    songsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
    myArray = @[playlistsSeeAllInvisible, songsSeeAllInvisible];
    for (UIButton *buttons in myArray) {
        [buttons setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:buttons];
        [buttons addTarget:self action:@selector(simulateButtonPress:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [buttons addTarget:self action:@selector(simulateButtonRelease:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    }
    
    
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
