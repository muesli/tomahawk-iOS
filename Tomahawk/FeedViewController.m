//
//  FirstViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "FeedViewController.h"

@interface FeedViewController (){
    UIButton *songsSeeAllButton, *songsSeeAllInvisible, *playlistsSeeAllButton, *playlistsSeeAllInvisible, *searchSongsSeeAllButton, *searchAlbumsSeeAllButton, *searchPlaylistsSeeAllButton;
    UILabel *playlistsHeader, *songsHeader, *searchSongsHeader, *searchAlbumsHeader, *searchPlaylistsHeader;
    UITableView *searchResultsTableView;
    NSArray *songNames, *songArtists, *albumNames, *albumArtists, *albumImages;
    FMEngine *apiCall;
    __block dispatch_cancelable_block_t searchBlock;
}

@end

static CGFloat searchBlockDelay = 0.2;

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
    //Regester for keyboard notifications so you can resize tableview when it closes
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    searchResultsTableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, (self.view.frame.size.height - 110)) style:UITableViewStyleGrouped];
    searchResultsTableView.delegate = self;
    searchResultsTableView.dataSource = self;
    searchResultsTableView.delaysContentTouches = NO;
    searchResultsTableView.contentInset = UIEdgeInsetsZero;
    searchResultsTableView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
    searchResultsTableView.separatorColor = [UIColor colorWithRed:52.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1];

    
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
    
}

#pragma mark - Search Controller


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    self.definesPresentationContext = YES;
    [self.searchBar sizeToFit];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
    searchBar.showsCancelButton = NO;
    [searchResultsTableView removeFromSuperview];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.navigationItem.rightBarButtonItem = nil;
     NSString *searchString = self.searchBar.text;
    NSLog(@"%@",searchString);
    [self.view addSubview:searchResultsTableView];
    
}
-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![searchText isEqualToString:@""]){
        // to limit network activity, reload half a second after last key press.
        if (searchBlock != nil) {
            //We cancel the currently scheduled block
            cancel_block(searchBlock);
        }
        searchBlock = dispatch_after_delay(searchBlockDelay, ^{
            //We "enqueue" this block with a certain delay. It will be canceled if the user types faster than the delay, otherwise it will be executed after the specified delay
            [self search:searchText];
        });
    }
    //If there is nothing in the search field, force remove everything from table View;
    songArtists = nil;
    songNames = nil;
    albumArtists = nil;
    albumImages = nil;
    albumNames = nil;
    [searchResultsTableView reloadData];

}

-(void)search:(NSString *)searchText{
    NSLog(@"text after wait is %@", searchText);
    
    if(!apiCall){
        apiCall = [FMEngine new];
    }
    dispatch_queue_t getSongInfo = dispatch_queue_create("getSongInfo", NULL);
    dispatch_async(getSongInfo, ^{
        NSDictionary *myDict = [apiCall searchSongs:searchText artist:nil];
        songNames = [myDict objectForKey:@"songNames"];
        songArtists = [myDict objectForKey:@"artistNames"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchResultsTableView reloadData];
        });
    });
    dispatch_queue_t getAlbumInfo = dispatch_queue_create("getAlbumInfo", NULL);
    dispatch_async(getAlbumInfo, ^{
        NSDictionary *myDict = [apiCall searchAlbums:searchText];
        albumNames = [myDict objectForKey:@"albumNames"];
        albumArtists = [myDict objectForKey:@"artistNames"];
        albumImages = [myDict objectForKey:@"mediumImages"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [searchResultsTableView reloadData];
        });
    });
a:;
}

#pragma mark - Table View

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *searchCell = [searchResultsTableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!searchCell) {
        searchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    if (indexPath.section == 0) {
        
        searchCell.imageView.image = [UIImage new];
        
        //Create temp variables so selected code will only run once
        int j = indexPath.row;
        j++;
        for (int i = indexPath.row; i<j && i<songNames.count; i++) {
            searchCell.textLabel.text = [songNames objectAtIndex:i];
            searchCell.detailTextLabel.text = [songArtists objectAtIndex:i];
        }

    }else if (indexPath.section == 1){
        //Create temp variables so selected code will only run once
        int j = indexPath.row;
        j++;
        for (int i = indexPath.row; i<j && i<albumNames.count; i++) {
            searchCell.textLabel.text = [albumNames objectAtIndex:i];
            searchCell.detailTextLabel.text = [albumArtists objectAtIndex:i];
            searchCell.imageView.image = [albumImages objectAtIndex:i];
        }
    }
    
    
    searchCell.backgroundColor = [UIColor clearColor];
    searchCell.textLabel.textColor = [UIColor whiteColor];
    searchCell.detailTextLabel.textColor = [UIColor whiteColor];
    searchCell.detailTextLabel.alpha = 0.5;
    searchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return searchCell;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        if (songNames.count >= 4) {
            return 4;
        }else{
            return songNames.count;
        }
    }else if (section == 1){
        if (albumNames.count >= 4) {
            return 4;
        }else{
            return albumNames.count;
        }
    }else{
//        if ( >= 4) {
//            return 4;
//        }
//        else{
            return 0;
        }
    
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    if([tableView numberOfRowsInSection:section] == 0){
        return headerView;
    }
    NSArray *myArray;
    if (section == 0) {
        searchSongsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myArray = @[searchSongsSeeAllButton];
    }else if (section == 1){
        searchAlbumsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myArray = @[searchAlbumsSeeAllButton];
    }else{
        searchPlaylistsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        myArray = @[searchPlaylistsSeeAllButton];
    }
    
    for (UIButton *buttons in myArray) {
        [buttons setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [buttons setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [buttons setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [buttons setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[buttons titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [buttons setEnabled:NO];
        [buttons setUserInteractionEnabled:NO];
        [buttons setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:buttons];

        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:1
                                                                constant:38]];
        
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
        
    }
    
    if (section == 0) {
        searchSongsHeader = [[UILabel alloc]init];
        searchSongsHeader.text = @"SONGS";
        myArray = @[searchSongsHeader];
    }else if (section == 1){
        searchAlbumsHeader = [[UILabel alloc]init];
        searchAlbumsHeader.text = @"ALBUMS";
        myArray = @[searchAlbumsHeader];
    }else{
        searchPlaylistsHeader = [[UILabel alloc]init];
        searchPlaylistsHeader.text = @"PLAYLISTS";
        myArray = @[searchPlaylistsHeader];
    }

    for (UILabel *headers in myArray) {
        headers.font = [UIFont systemFontOfSize:12 weight:0.2];
        headers.alpha = 0.5;
        headers.textColor = [UIColor whiteColor];
        [headers setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:headers];
        
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headers
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                              multiplier:1
                                                                constant:20]];
        
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headers
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
    }
    return headerView;
}


-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
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





#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
    UIEdgeInsets contentInsets;
    if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height - 85), 0.0);
    } else {
        contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
    }
    searchResultsTableView.contentInset = contentInsets;
    searchResultsTableView.scrollIndicatorInsets = contentInsets;
    [searchResultsTableView scrollToRowAtIndexPath:self.editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
    searchResultsTableView.contentInset = UIEdgeInsetsZero;
    searchResultsTableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
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
