//
//  SearchTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 29/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "SearchTableViewController.h"

@interface SearchTableViewController (){
    NSArray *songNames, *songArtists, *albumNames, *albumArtists, *albumImages, *songAlbums, *songImages, *artistImages, *artistNames, *artistFollowers, *playlistCount, *playlistNames, *playlistImages, *playlistArtists;
    __block dispatch_cancelable_block_t searchBlock;
    DGActivityIndicatorView *activityIndicatorView;
    UIView *loadingDimmer;
}
@property(nonatomic, strong) NSIndexPath *editingIndexPath;

@end

static CGFloat searchBlockDelay = 0.25;

@implementation SearchTableViewController

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.toolbar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.titleView = self.searchBar;
    [self.tableView setDelaysContentTouches:NO];
    [self.searchBar sizeToFit];
    [self.searchBar becomeFirstResponder];
    loadingDimmer = [[UIView alloc]initWithFrame:self.view.frame]; //View to dim whats behind it when new content is loading
    loadingDimmer.backgroundColor = [UIColor blackColor];
    loadingDimmer.alpha = 0.3;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    
}

#pragma mark - Search Controller


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    if (!activityIndicatorView) {
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] size:20.0f];
    }
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


-(void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText{
    if (![searchText isEqualToString:@""]){
        if (searchBlock != nil) {
            cancel_block(searchBlock);
        }
        searchBlock = dispatch_after_delay(searchBlockDelay, ^{
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
    
    [self.tableView setUserInteractionEnabled:NO];
    loadingDimmer.hidden = NO;
    [activityIndicatorView setHidden:NO];
    [activityIndicatorView startAnimating];
    
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0);
    dispatch_group_t group = dispatch_group_create();
    
    dispatch_group_async(group, queue, ^{
        NSDictionary *myDict = [TEngine searchSongsSpotify:searchText];
        songNames = [myDict objectForKey:@"songNames"];
        songAlbums = [myDict objectForKey:@"albumNames"];
        songArtists = [myDict objectForKey:@"artistNames"];
        songImages = [myDict objectForKey:@"mediumImages"];
    });
    
    dispatch_group_async(group, queue, ^{
        NSDictionary *myDict = [TEngine searchAlbumsSpotify:searchText];
        albumNames = [myDict objectForKey:@"albumNames"];
        albumArtists = [myDict objectForKey:@"artistNames"];
        albumImages = [myDict objectForKey:@"mediumImages"];
    });
    
    dispatch_group_async(group, queue, ^{
        NSDictionary *myDict = [TEngine searchArtistsSpotify:searchText];
        artistFollowers = [myDict objectForKey:@"artistFollowers"];
        artistImages = [myDict objectForKey:@"mediumImages"];
        artistNames = [myDict objectForKey:@"artistNames"];
    });
    dispatch_group_async(group, queue, ^{
        NSDictionary *myDict = [TEngine searchPlaylistsSpotify:searchText];
        playlistNames = [myDict objectForKey:@"playlistNames"];
        playlistArtists = [myDict objectForKey:@"playlistArtists"];
        playlistCount = [myDict objectForKey:@"trackCount"];
        playlistImages = [myDict objectForKey:@"mediumImages"];
    });

    dispatch_group_notify(group, queue, ^{
        dispatch_sync(dispatch_get_main_queue(), ^(void){
            [self.tableView setUserInteractionEnabled:YES];
            loadingDimmer.hidden = YES;
            [activityIndicatorView stopAnimating];
            [activityIndicatorView setHidden:YES];
            [self.tableView reloadData];
        });
    });
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 80;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *searchCell = [self.tableView dequeueReusableCellWithIdentifier:@"searchCell"];
    if (!searchCell) {
        searchCell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"searchCell"];
    }
    
    switch (indexPath.section) {
        case 0:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<songNames.count; i++) {
                searchCell.textLabel.text =  [songNames objectAtIndex:i];
                NSString *albums = [songAlbums objectAtIndex:i];
                NSString *text = [NSString stringWithFormat:@"%@ • %@", [songArtists objectAtIndex:i], albums];
                //If there are no albums, remove the album thing ^
                if (!albums) {
                    text = [songArtists objectAtIndex:i];
                }
                searchCell.detailTextLabel.text = text;
                [searchCell.imageView setImageWithURL:[NSURL URLWithString:[songImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderLarge"]];
            }
            break;
        case 1:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<albumNames.count; i++) {
                searchCell.textLabel.text = [albumNames objectAtIndex:i];
                searchCell.detailTextLabel.text = [albumArtists objectAtIndex:i];
                [searchCell.imageView setImageWithURL:[NSURL URLWithString:[albumImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderLarge"]];
            }
            break;
        case 2:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<artistNames.count; i++) {
                searchCell.textLabel.text = [artistNames objectAtIndex:i];
                NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSString *followers = [NSString stringWithFormat:@"Followers: %@", [numberFormatter stringFromNumber:[artistFollowers objectAtIndex:i]]];
                searchCell.detailTextLabel.text = followers;
                [searchCell.imageView setImageWithURL:[NSURL URLWithString:[artistImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderArtistLarge"]];
            }
            break;
        case 3:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<playlistNames.count; i++) {
                searchCell.textLabel.text = [playlistNames objectAtIndex:i];
                NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSString *count = [NSString stringWithFormat:@"%@ • Songs: %@", [[playlistArtists objectAtIndex:i] capitalizedString], [numberFormatter stringFromNumber:[playlistCount objectAtIndex:i]]];
                searchCell.detailTextLabel.text = count;
                [searchCell.imageView setImageWithURL:[NSURL URLWithString:[playlistImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderLarge"]];;
            }
            break;
        default:
            break;
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
    switch (section) {
        case 0:
            if (songNames.count >= 4) return 4;
            else return songNames.count;
        case 1:
            if (albumNames.count >= 4)return 4;
            else return albumNames.count;
        case 2:
            if (artistNames.count >= 4) return 4;
            else return artistNames.count;
        case 3:
            if (playlistNames.count >= 4)return 4;
            else return playlistNames.count;
        default:
            return 0;
    }
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}


-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    if([tableView numberOfRowsInSection:section] == 0){
        return nil;
    }
    
    UILabel *headerTitle = [UILabel new];
    switch (section) {
        case 0:
            headerTitle.text = @"SONGS";
            break;
        case 1:
            headerTitle.text = @"ALBUMS";
            break;
        case 2:
            headerTitle.text = @"ARTISTS";
            break;
        case 3:
            headerTitle.text = @"PLAYLISTS";
            break;
        default:
            break;
    }
    
    headerTitle.font = [UIFont systemFontOfSize:12 weight:0.2];
    headerTitle.alpha = 0.5;
    headerTitle.textColor = [UIColor whiteColor];
    [headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:headerTitle];
    
    
    UIButton *seeAll = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [seeAll setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
    [seeAll setTitleEdgeInsets:UIEdgeInsetsMake(0, -105.0, 0, 0)];
    [seeAll setImageEdgeInsets:UIEdgeInsetsMake(3, -2, 3, 18)];
    [seeAll setContentEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
    [seeAll setTitle:@"SEE ALL" forState:UIControlStateNormal];
    [seeAll setReversesTitleShadowWhenHighlighted:YES];
    [seeAll setTintColor:[UIColor whiteColor]];
    [[seeAll titleLabel] setFont:[UIFont systemFontOfSize:12]];
    [seeAll setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:seeAll];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:seeAll
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                          multiplier:1
                                                            constant:-5]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:seeAll
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1
                                                            constant:0]];
    
    [seeAll addConstraint:[NSLayoutConstraint constraintWithItem:seeAll
                                                       attribute:NSLayoutAttributeHeight
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:0
                                                        constant:15]];
    
    [seeAll addConstraint:[NSLayoutConstraint constraintWithItem:seeAll
                                                       attribute:NSLayoutAttributeWidth
                                                       relatedBy:NSLayoutRelationEqual
                                                          toItem:nil
                                                       attribute:NSLayoutAttributeNotAnAttribute
                                                      multiplier:0
                                                        constant:70]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerTitle
                                                           attribute:NSLayoutAttributeLeadingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeLeadingMargin
                                                          multiplier:1
                                                            constant:20]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerTitle
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1
                                                            constant:0]];
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 40;
}
-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return CGFLOAT_MIN;
}

@end