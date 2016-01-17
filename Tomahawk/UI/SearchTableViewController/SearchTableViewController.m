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

@end

static CGFloat searchBlockDelay = 0.25;

@implementation SearchTableViewController

-(IBAction)moreButtonTouched:(UIButton *)button forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSString *textLabel;
    NSString *detailTextLabel;
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    switch (indexPath.section) {
        case 0:
            textLabel = [songNames objectAtIndex:indexPath.row];
            detailTextLabel = [songArtists objectAtIndex:indexPath.row];
            break;
        case 1:
            textLabel = [albumNames objectAtIndex:indexPath.row];
            detailTextLabel = [albumArtists objectAtIndex:indexPath.row];
            break;
        case 2:
            textLabel = [artistNames objectAtIndex:indexPath.row];
            detailTextLabel = [[artistFollowers objectAtIndex:indexPath.row] stringValue];
            break;
        case 3:
            textLabel = [playlistNames objectAtIndex:indexPath.row];
            detailTextLabel = [playlistArtists objectAtIndex:indexPath.row];
            break;
        default:
            break;
    }
    
    UIAlertController *more = [UIAlertController alertControllerWithTitle:textLabel message:detailTextLabel preferredStyle:UIAlertControllerStyleActionSheet];
    
    [more addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Save song
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Play Next" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Play next
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Add to Queue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Add to queue
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Share
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Start Radio" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Start Radio
    }]];
    
    indexPath.section == 2 ?: [more addAction:[UIAlertAction actionWithTitle:@"Go to Artist" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Goto Artist
    }]];
    
    indexPath.section == 0 ?[more addAction:[UIAlertAction actionWithTitle:@"Go to Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Goto Artist
    }]] : nil;
    [more addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:more animated:YES completion:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.toolbar.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.navigationItem.titleView = self.searchBar;
    [self.tableView setDelaysContentTouches:NO];
    [self.searchBar sizeToFit];
    [self.searchBar becomeFirstResponder];
    loadingDimmer = [[UIView alloc]initWithFrame:self.view.frame];
    loadingDimmer.backgroundColor = [UIColor blackColor];
    loadingDimmer.alpha = 0.3;
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    
}

#pragma mark - Search Controller


- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar {
    if (!activityIndicatorView) {
        activityIndicatorView = [[DGActivityIndicatorView alloc] initWithType:DGActivityIndicatorAnimationTypeLineScalePulseOut tintColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] size:20.0f];
    }
    [activityIndicatorView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.tableView addSubview:activityIndicatorView];
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
    
    [self.tableView addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self.tableView attribute:NSLayoutAttributeCenterY multiplier:1 constant:-40]];
    
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
        //If there is nothing in the search field, force remove everything from table View
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
- (void)search:(NSString *)searchText {
    
    [self.tableView setUserInteractionEnabled:NO];
    loadingDimmer.hidden = NO;
    [activityIndicatorView setHidden:NO];
    [activityIndicatorView startAnimating];
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
        [TEngine searchAlbumsByAlbumName:searchText resolver:RDeezer completion:^(id response) {
            if ([response isKindOfClass:[NSError class]]) {
                UIAlertController *error = [self error:response];
                [self presentViewController:error animated:YES completion:nil];
                [self.tableView setUserInteractionEnabled:YES];
                loadingDimmer.hidden = YES;
                [activityIndicatorView stopAnimating];
                [activityIndicatorView setHidden:YES];
                return;
            }else {
                albumNames = [response objectForKey:@"albumNames"];
                albumArtists = [response objectForKey:@"artistNames"];
                albumImages = [response objectForKey:@"mediumImages"];
            }
            dispatch_group_leave(group);
        }];

    dispatch_group_enter(group);
        [TEngine searchSongsBySongName:searchText resolver:RDeezer completion:^(id response) {
            if ([response isKindOfClass:[NSError class]]) {
                UIAlertController *error = [self error:response];
                [self presentViewController:error animated:YES completion:nil];
                [self.tableView setUserInteractionEnabled:YES];
                loadingDimmer.hidden = YES;
                [activityIndicatorView stopAnimating];
                [activityIndicatorView setHidden:YES];
                return;
            }else {
                songNames = [response objectForKey:@"songNames"];
                songAlbums = [response objectForKey:@"albumNames"];
                songArtists = [response objectForKey:@"artistNames"];
                songImages = [response objectForKey:@"mediumImages"];
            }
            dispatch_group_leave(group);
        }];
    
    dispatch_group_enter(group);
        [TEngine searchArtistsByArtistName:searchText resolver:RDeezer completion:^(id response) {
            if ([response isKindOfClass:[NSError class]]) {
                UIAlertController *error = [self error:response];
                [self presentViewController:error animated:YES completion:nil];
                [self.tableView setUserInteractionEnabled:YES];
                loadingDimmer.hidden = YES;
                [activityIndicatorView stopAnimating];
                [activityIndicatorView setHidden:YES];
                return;
            }else {
                artistFollowers = [response objectForKey:@"artistFollowers"];
                artistImages = [response objectForKey:@"mediumImages"];
                artistNames = [response objectForKey:@"artistNames"];
            }
            dispatch_group_leave(group);
        }];
    
//        playlistNames = [myDict objectForKey:@"playlistNames"];
//        playlistArtists = [myDict objectForKey:@"playlistArtists"];
//        playlistCount = [myDict objectForKey:@"trackCount"];
//        playlistImages = [myDict objectForKey:@"mediumImages"];

    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView setUserInteractionEnabled:YES];
        loadingDimmer.hidden = YES;
        [activityIndicatorView stopAnimating];
        [activityIndicatorView setHidden:YES];
        [self.tableView reloadData];
    });
}

- (UIAlertController *) error:(NSError *)message {
    UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[message userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
    [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    return error;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *searchCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [searchCell.myAccessoryButton addTarget:self action:@selector(moreButtonTouched:forEvent:)forControlEvents:UIControlEventTouchUpInside];
    
    switch (indexPath.section) {
        case 0:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<songNames.count; i++) {
                searchCell.myTextLabel.text =  [songNames objectAtIndex:i];
                NSString *albums = [songAlbums objectAtIndex:i];
                NSString *text = albums ? [NSString stringWithFormat:@"%@ • %@", [songArtists objectAtIndex:i], albums] : [songArtists objectAtIndex:i];
                searchCell.myDetailTextLabel.text = text;
                [searchCell.myImageView setImageWithURL:[NSURL URLWithString:[songImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderSongs"]];
            }
            break;
        case 1:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<albumNames.count; i++) {
                searchCell.myTextLabel.text = [albumNames objectAtIndex:i];
                searchCell.myDetailTextLabel.text = [albumArtists objectAtIndex:i];
                [searchCell.myImageView setImageWithURL:[NSURL URLWithString:[albumImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderAlbums"]];
            }
            break;
        case 2:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<artistNames.count; i++) {
                searchCell.myTextLabel.text = [artistNames objectAtIndex:i];
                NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSString *followers = [NSString stringWithFormat:@"Followers: %@", [numberFormatter stringFromNumber:[artistFollowers objectAtIndex:i]]];
                searchCell.myDetailTextLabel.text = followers;
                [searchCell.myImageView setImageWithURL:[NSURL URLWithString:[artistImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderArtists"]];
            }
            break;
        case 3:
            for (NSUInteger i = indexPath.row; i<=indexPath.row && i<playlistNames.count; i++) {
                searchCell.myTextLabel.text = [playlistNames objectAtIndex:i];
                NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSString *count = [NSString stringWithFormat:@"%@ • Songs: %@", [[playlistArtists objectAtIndex:i] capitalizedString], [numberFormatter stringFromNumber:[playlistCount objectAtIndex:i]]];
                searchCell.myDetailTextLabel.text = count;
                [searchCell.myImageView setImageWithURL:[NSURL URLWithString:[playlistImages objectAtIndex:i]] placeholderImage:[UIImage imageNamed:@"PlaceholderPlaylists"]];;
            }
            break;
        default:
            break;
    }
    return searchCell;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 4;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
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
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:-5]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [seeAll addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:15]];
    
    [seeAll addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:70]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerTitle attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:20]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    return headerView;
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return CGFLOAT_MIN;
}

@end
