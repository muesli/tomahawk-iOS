//
//  NowPlayingBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NavigationController.h"

//UI BUG WHERE IF THERE ARE NONE OF A CERTAIN FIELD, EG. ARTISTS, THE HEADER WILL NOT FULLY REMOVE MEANING THE HEADER FOR THE OTHER ONES WILL DOUBLE IN SIZE


@interface NavigationController (){
    UIButton *searchSongsSeeAllButton, *searchAlbumsSeeAllButton, *searchPlaylistsSeeAllButton, *searchArtistsSeeAllButton;
    UILabel  *searchSongsHeader, *searchAlbumsHeader, *searchPlaylistsHeader, *searchArtistsHeader;
    NSArray *songNames, *songArtists, *albumNames, *albumArtists, *albumImages, *songAlbums, *songImages, *artistImages, *artistNames, *artistFollowers, *playlistCount, *playlistNames, *playlistImages, *playlistArtists;
    TEngine *apiCall;
    __block dispatch_cancelable_block_t searchBlock;
    DGActivityIndicatorView *activityIndicatorView;
    UIView *loadingDimmer;
}

@end

static CGFloat searchBlockDelay = 0.25;

@implementation NavigationController

- (IBAction)inboxButton:(id *)sender {
    //Insert Code Here
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect targetRect = self.toolbar.frame;
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(targetRect, touchLocation)) {
        [self performSegueWithIdentifier:@"showNowPlaying" sender:self];
    }
}

-(void)viewDidLoad{
    [super viewDidLoad];
    loadingDimmer = [[UIView alloc]initWithFrame:self.view.frame]; //View to dim whats behind it when new content is loading
    loadingDimmer.backgroundColor = [UIColor blackColor];
    loadingDimmer.alpha = 0.3;
    UIBarButtonItem *inboxButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
    self.viewControllers[0].navigationItem.rightBarButtonItem = inboxButton;
    //Regester for keyboard notifications so you can resize tableview when it closes
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillShow:)
                                                 name:UIKeyboardWillShowNotification
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(keyboardWillHide:)
                                                 name:UIKeyboardWillHideNotification
                                               object:nil];
    
    self.searchBar = [[SearchBar alloc] init];
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.barTintColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1.0];
    self.searchBar.placeholder = @"Search for Music, Playlists and Artists";
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.searchBar sizeToFit];
    self.searchBar.tintColor = self.view.window.tintColor;
    [self.searchBar setTintColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)]];
    self.searchBar.delegate = self;
    self.viewControllers[0].navigationItem.titleView = self.searchBar;
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 63, self.view.frame.size.width, (self.view.frame.size.height-63)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delaysContentTouches = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:52.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1];

}

#pragma mark - Search Controller


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    self.viewControllers[0].view.userInteractionEnabled = NO;
    if (!activityIndicatorView) {
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] size:20.0f];
    }
    searchBar.showsCancelButton = YES;
    [self.searchBar sizeToFit];
    self.viewControllers[0].navigationItem.rightBarButtonItem = nil;
    self.viewControllers[0].tabBarController.tabBar.hidden = YES;
    [self.view addSubview:self.tableView];
    [activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView addSubview:activityIndicatorView];
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.tableView
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1
                                                           constant:0]];
    
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView
                                                            attribute:NSLayoutAttributeCenterY
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:self.tableView
                                                            attribute:NSLayoutAttributeCenterY
                                                           multiplier:1
                                                             constant:-40]];
    activityIndicatorView.hidden = YES;
    [self.tableView addSubview:loadingDimmer];
    loadingDimmer.hidden = YES;
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    self.viewControllers[0].view.userInteractionEnabled = YES;
    [searchBar resignFirstResponder];
    self.viewControllers[0].navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
    self.viewControllers[0].tabBarController.tabBar.hidden = NO;
    searchBar.showsCancelButton = NO;
    [activityIndicatorView removeFromSuperview];
    [self.tableView removeFromSuperview];
    [loadingDimmer removeFromSuperview];
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
    }else{
        //If there is nothing in the search field, force remove everything from table View;
        songArtists = nil;
        songNames = nil;
        albumArtists = nil;
        albumImages = nil;
        albumNames = nil;
        artistNames = nil;
        artistFollowers = nil;
        artistImages = nil;
        playlistNames = nil;
        playlistImages = nil;
        playlistCount = nil;
        [self.tableView reloadData];
    }
    
}

-(void)search:(NSString *)searchText{
    if(!apiCall){
        apiCall = [TEngine new];
    }
    
    dispatch_queue_t getSongInfo = dispatch_queue_create("getSongInfo", NULL);
    dispatch_async(getSongInfo, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:NO];
            loadingDimmer.hidden = NO;
            [activityIndicatorView setHidden:NO];
            [activityIndicatorView startAnimating];
        });
        NSDictionary *myDict = [apiCall searchSongsSoundcloud:searchText];
        songNames = [myDict objectForKey:@"songNames"];
        songAlbums = [myDict objectForKey:@"albumNames"];
        songArtists = [myDict objectForKey:@"artistNames"];
        songImages = [myDict objectForKey:@"mediumImages"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:YES];
            loadingDimmer.hidden = YES;
            [activityIndicatorView stopAnimating];
            [activityIndicatorView setHidden:YES];
            [self.tableView reloadData];
            
        });
    });
    
    dispatch_queue_t getAlbumInfo = dispatch_queue_create("getAlbumInfo", NULL);
    dispatch_async(getAlbumInfo, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:NO];
            loadingDimmer.hidden = NO;
            [activityIndicatorView setHidden:NO];
            [activityIndicatorView startAnimating];
        });
        NSDictionary *myDict = [apiCall searchAlbumsDeezer:searchText];
        albumNames = [myDict objectForKey:@"albumNames"];
        albumArtists = [myDict objectForKey:@"artistNames"];
        albumImages = [myDict objectForKey:@"mediumImages"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:YES];
            loadingDimmer.hidden = YES;
            [activityIndicatorView stopAnimating];
            [activityIndicatorView setHidden:YES];
            [self.tableView reloadData];
        });
    });
    
    dispatch_queue_t getArtistInfo = dispatch_queue_create("getArtistInfo", NULL);
    dispatch_async(getArtistInfo, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:NO];
            loadingDimmer.hidden = NO;
            [activityIndicatorView setHidden:NO];
            [activityIndicatorView startAnimating];
        });
        NSDictionary *myDict = [apiCall searchArtistsSoundcloud:searchText];
        artistFollowers = [myDict objectForKey:@"artistFollowers"];
        artistImages = [myDict objectForKey:@"mediumImages"];
        artistNames = [myDict objectForKey:@"artistNames"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:YES];
            loadingDimmer.hidden = YES;
            [activityIndicatorView stopAnimating];
            [activityIndicatorView setHidden:YES];
            [self.tableView reloadData];
            
        });
    });
    
    dispatch_queue_t getPlaylistInfo = dispatch_queue_create("getPlaylistInfo", NULL);
    dispatch_async(getPlaylistInfo, ^{
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:NO];
            loadingDimmer.hidden = NO;
            [activityIndicatorView setHidden:NO];
            [activityIndicatorView startAnimating];
        });
        NSDictionary *myDict = [apiCall searchPlaylistsSpotify:searchText];
        playlistNames = [myDict objectForKey:@"playlistNames"];
        playlistArtists = [myDict objectForKey:@"playlistArtists"];
        playlistCount = [myDict objectForKey:@"trackCount"];
        playlistImages = [myDict objectForKey:@"mediumImages"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView setUserInteractionEnabled:YES];
            loadingDimmer.hidden = YES;
            [activityIndicatorView stopAnimating];
            [activityIndicatorView setHidden:YES];
            [self.tableView reloadData];
            
        });
    });
}

#pragma mark - Table View

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *searchCell = [self.tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!searchCell) {
        searchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    if (indexPath.section == 0) {
        searchCell.imageView.image = [UIImage new];
        //Create temp variables so code will only run once
        int j = indexPath.row;
        j++;
        for (int i = indexPath.row; i<j && i<songNames.count; i++) {
            searchCell.textLabel.text =  [songNames objectAtIndex:i];
            NSString *albums = [songAlbums objectAtIndex:i];
            NSString *text = [NSString stringWithFormat:@"%@ • %@", [songArtists objectAtIndex:i], albums];
            //If there are no albums, remove the album thing ^
            if (!albums) {
                text = [songArtists objectAtIndex:i];
            }
            searchCell.detailTextLabel.text = text;
            searchCell.imageView.image = [songImages objectAtIndex:i];
        }
        
    }else if (indexPath.section == 1){
        //Create temp variables so code will only run once
        int j = indexPath.row;
        j++;
        for (int i = indexPath.row; i<j && i<albumNames.count; i++) {
            searchCell.textLabel.text = [albumNames objectAtIndex:i];
            searchCell.detailTextLabel.text = [albumArtists objectAtIndex:i];
            searchCell.imageView.image = [albumImages objectAtIndex:i];
        }
    }else if (indexPath.section == 2){
        //Create temp variables so code will only run once
        int j = indexPath.row;
        j++;
        
        for (int i = indexPath.row; i<j && i<artistNames.count; i++) {
            searchCell.textLabel.text = [artistNames objectAtIndex:i];
            NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *followers = [NSString stringWithFormat:@"Followers: %@", [numberFormatter stringFromNumber:[artistFollowers objectAtIndex:i]]];
            searchCell.detailTextLabel.text = followers;
            searchCell.imageView.image = [artistImages objectAtIndex:i];
        }
    }else if (indexPath.section == 3){
        //Create temp variables so code will only run once
        int j = indexPath.row;
        j++;
        
        for (int i = indexPath.row; i<j && i<playlistNames.count; i++) {
            searchCell.textLabel.text = [playlistNames objectAtIndex:i];
            NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *count = [NSString stringWithFormat:@"%@ • Songs: %@", [[playlistArtists objectAtIndex:i] capitalizedString], [numberFormatter stringFromNumber:[playlistCount objectAtIndex:i]]];
            searchCell.detailTextLabel.text = count;
            searchCell.imageView.image = [playlistImages objectAtIndex:i];
        }

    }
    
    
    searchCell.backgroundColor = [UIColor clearColor];
    searchCell.textLabel.textColor = [UIColor whiteColor];
    searchCell.detailTextLabel.textColor = [UIColor whiteColor];
    searchCell.detailTextLabel.alpha = 0.5;
    searchCell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    //Make cell image not the whole size
    CGFloat widthScale = 60 / searchCell.imageView.image.size.width;
    CGFloat heightScale = 60 / searchCell.imageView.image.size.height;
    searchCell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
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
    }else if (section == 2){
        if (artistNames.count >= 4) {
            return 4;
        }else{
            return artistNames.count;
        }
    }else if(section == 3){
        if (playlistNames.count >= 4) {
            return 4;
        }else{
            return playlistNames.count;
        }
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    if([tableView numberOfRowsInSection:section] == 0){
        return headerView;
    }
    NSArray *myArray;
    
    if (section == 0) {
        searchSongsSeeAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
        myArray = @[searchSongsSeeAllButton];
    }else if (section == 1){
        searchAlbumsSeeAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
        myArray = @[searchAlbumsSeeAllButton];
    }else if (section == 2){
        searchArtistsSeeAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
        myArray = @[searchArtistsSeeAllButton];
    }else if (section == 3){
        searchPlaylistsSeeAllButton = [UIButton buttonWithType:UIButtonTypeSystem];
        myArray = @[searchPlaylistsSeeAllButton];
    }
    
    for (UIButton *buttons in myArray) {
        [buttons setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [buttons setTitleEdgeInsets:UIEdgeInsetsMake(0, -105.0, 0, 0)];
        [buttons setImageEdgeInsets:UIEdgeInsetsMake(3, -2, 3, 18)];
        [buttons setContentEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
        [buttons setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [buttons setReversesTitleShadowWhenHighlighted:YES];
        [buttons setTintColor:[UIColor whiteColor]];
        [[buttons titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [buttons setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:buttons];
        
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:1
                                                                constant:-3]];
        
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
        
        [buttons addConstraint:[NSLayoutConstraint constraintWithItem:buttons attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:15]];
        [buttons addConstraint:[NSLayoutConstraint constraintWithItem:buttons attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:70]];
        
    }
    
    if (section == 0) {
        searchSongsHeader = [[UILabel alloc]init];
        searchSongsHeader.text = @"SONGS";
        myArray = @[searchSongsHeader];
    }else if (section == 1){
        searchAlbumsHeader = [[UILabel alloc]init];
        searchAlbumsHeader.text = @"ALBUMS";
        myArray = @[searchAlbumsHeader];
    }else if (section == 2){
        searchArtistsHeader = [[UILabel alloc]init];
        searchArtistsHeader.text = @"ARTISTS";
        myArray = @[searchArtistsHeader];
    }else if (section == 3){
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

#pragma mark - Keyboard

- (void)keyboardWillShow:(NSNotification *)notification{
    
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        UIEdgeInsets contentInsets;
        if (UIInterfaceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation])) {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.height + 5), 0.0);
        } else {
            contentInsets = UIEdgeInsetsMake(0.0, 0.0, (keyboardSize.width), 0.0);
        }
        self.tableView.contentInset = contentInsets;
        self.tableView.scrollIndicatorInsets = contentInsets;
        [self.tableView scrollToRowAtIndexPath:self.editingIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }];
}

- (void)keyboardWillHide:(NSNotification *)notification{
    NSNumber *rate = notification.userInfo[UIKeyboardAnimationDurationUserInfoKey];
    [UIView animateWithDuration:rate.floatValue animations:^{
        self.tableView.contentInset = UIEdgeInsetsZero;
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsZero;
    }];
}





@end
