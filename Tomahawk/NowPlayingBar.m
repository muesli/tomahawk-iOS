//
//  NowPlayingBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NowPlayingBar.h"

@interface NowPlayingBar (){
    UIButton *searchSongsSeeAllButton, *searchAlbumsSeeAllButton, *searchPlaylistsSeeAllButton;
    UILabel  *searchSongsHeader, *searchAlbumsHeader, *searchPlaylistsHeader;
    NSArray *songNames, *songArtists, *albumNames, *albumArtists, *albumImages, *songAlbums, *songImages;
    TEngine *apiCall;
    __block dispatch_cancelable_block_t searchBlock;
}

@end

static CGFloat searchBlockDelay = 0.25;

@implementation NowPlayingBar

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
    
    self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 65, self.view.frame.size.width, (self.view.frame.size.height-20)) style:UITableViewStyleGrouped];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.delaysContentTouches = NO;
    self.tableView.contentInset = UIEdgeInsetsZero;
    self.tableView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
    self.tableView.separatorColor = [UIColor colorWithRed:52.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1];

}

#pragma mark - Search Controller


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    searchBar.showsCancelButton = YES;
    [self.searchBar sizeToFit];
    return YES;
}
-(void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    self.viewControllers[0].navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
    self.viewControllers[0].tabBarController.tabBar.hidden = NO;
    searchBar.showsCancelButton = NO;
    [self.tableView removeFromSuperview];
}
-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar{
    self.viewControllers[0].navigationItem.rightBarButtonItem = nil;
    self.viewControllers[0].tabBarController.tabBar.hidden = YES;
    NSString *searchString = self.searchBar.text;
    NSLog(@"%@",searchString);
    [self.view addSubview:self.tableView];
    
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
        [self.tableView reloadData];
    }
    
}

-(void)search:(NSString *)searchText{
    NSLog(@"text after wait is %@", searchText);
    
    if(!apiCall){
        apiCall = [TEngine new];
    }
    dispatch_queue_t getSongInfo = dispatch_queue_create("getSongInfo", NULL);
    dispatch_async(getSongInfo, ^{
        NSDictionary *myDict = [apiCall searchSongs:searchText];
        songNames = [myDict objectForKey:@"songNames"];
        songAlbums = [myDict objectForKey:@"albumName"];
        songArtists = [myDict objectForKey:@"artistNames"];
        songImages = [myDict objectForKey:@"mediumImages"];
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    });
    dispatch_queue_t getAlbumInfo = dispatch_queue_create("getAlbumInfo", NULL);
    dispatch_async(getAlbumInfo, ^{
        NSDictionary *myDict = [apiCall searchAlbums:searchText];
        albumNames = [myDict objectForKey:@"albumNames"];
        albumArtists = [myDict objectForKey:@"artistNames"];
        albumImages = [myDict objectForKey:@"mediumImages"];
        dispatch_async(dispatch_get_main_queue(), ^{
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
        
        //Create temp variables so selected code will only run once
        int j = indexPath.row;
        j++;
        for (int i = indexPath.row; i<j && i<songNames.count; i++) {
            searchCell.textLabel.text =  [songNames objectAtIndex:i];
            NSString *text = [NSString stringWithFormat:@"%@ • %@", [songArtists objectAtIndex:i], [songAlbums objectAtIndex:i]];
            searchCell.detailTextLabel.text = text;
            searchCell.imageView.image = [songImages objectAtIndex:i];
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
