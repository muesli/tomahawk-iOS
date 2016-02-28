//
//  SearchTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 29/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "SearchTableViewController.h"
#import "TEngine.h"
#import "dispatch_cancelable_block.h"
#import "UIImageView+AFNetworking.h"
#import "CustomTableViewCell.h"
#import "DetailTableViewController.h"
#import "ArtistDetailCollectionViewController.h"
#import "NowPlayingViewController.h"

@interface SearchTableViewController (){
    NSArray *songNames, *songArtists, *albumNames, *albumArtists, *albumImages, *songAlbums, *songImages, *artistImages, *artistNames, *artistFollowers, *playlistCount, *playlistNames, *playlistImages, *playlistArtists;
    __block dispatch_cancelable_block_t searchBlock;
    UILabel *messageLabel;
    UIImageView *image;

}

@property (strong, nonatomic) NSError *myError;

@end

static CGFloat searchBlockDelay = 0.25;

@implementation SearchTableViewController


-(IBAction)seeAll:(UIButton *)button {
    if (button.tag == 0) {
        DetailTableViewController *seeAll = [[DetailTableViewController alloc]initWithStyle:UITableViewStylePlain];
        seeAll.query = self.searchController.searchBar.text;
        seeAll.title = @"Songs";
        [self.navigationController pushViewController:seeAll animated:YES];
    }
    
}

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
    self.searchController.searchBar.hidden = NO;
    [self.searchController.searchBar becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.searchController.searchBar.hidden = YES;
    [self.searchController.searchBar resignFirstResponder];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
}

#pragma mark - UITableViewDelegate

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *searchCell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [searchCell.myAccessoryButton addTarget:self action:@selector(moreButtonTouched:forEvent:)forControlEvents:UIControlEventTouchUpInside];
    
    switch (indexPath.section) {
        case 0: {
            searchCell.myTextLabel.text =  [songNames objectAtIndex:indexPath.row];
            NSString *text = [songAlbums objectAtIndex:indexPath.row] ? [NSString stringWithFormat:@"%@ • %@", [songArtists objectAtIndex:indexPath.row], [songAlbums objectAtIndex:indexPath.row]] : [songArtists objectAtIndex:indexPath.row];
            searchCell.myDetailTextLabel.text = text;
            [[songImages objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] ? [searchCell.myImageView setImage:[UIImage imageNamed:@"PlaceholderSongs"]] : [searchCell.myImageView setImageWithURL:[NSURL URLWithString:[songImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderSongs"]];
        } break;
        case 1: {
            searchCell.myTextLabel.text = [albumNames objectAtIndex:indexPath.row];
            searchCell.myDetailTextLabel.text = [albumArtists objectAtIndex:indexPath.row];
            [[albumImages objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] ? [searchCell.myImageView setImage:[UIImage imageNamed:@"PlaceholderAlbums"]] :[searchCell.myImageView setImageWithURL:[NSURL URLWithString:[albumImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderAlbums"]];
        } break;
        case 2: {
            searchCell.myTextLabel.text = [artistNames objectAtIndex:indexPath.row];
            NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
            [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
            NSString *followers = [NSString stringWithFormat:@"Followers: %@", [numberFormatter stringFromNumber:[artistFollowers objectAtIndex:indexPath.row]]];
            searchCell.myDetailTextLabel.text = followers;
            [[artistImages objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] ? [searchCell.myImageView setImage:[UIImage imageNamed:@"PlaceholderArtists"]] : [searchCell.myImageView setImageWithURL:[NSURL URLWithString:[artistImages objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderArtists"]];
        } break;
        default:
            break;
    }
    return searchCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    if (indexPath.section == 0) {
        NowPlayingViewController *nowPlaying = (NowPlayingViewController *) [storyboard instantiateViewControllerWithIdentifier:@"NowPlayingViewController"];
        CustomTableViewCell *selectedCell = [tableView cellForRowAtIndexPath:indexPath];
        [self presentViewController:nowPlaying animated:YES completion:^{
            nowPlaying.backgroundImageView.image = selectedCell.myImageView.image;
            nowPlaying.currentSongImageView.image = selectedCell.myImageView.image;
            nowPlaying.songTitle.text = selectedCell.myTextLabel.text;
            nowPlaying.songArtist.text = selectedCell.myDetailTextLabel.text;
            [nowPlaying extractColors];
        }];
    }
    if (indexPath.section == 2) {
        ArtistDetailCollectionViewController *artistDetail = (ArtistDetailCollectionViewController *) [storyboard instantiateViewControllerWithIdentifier:@"ArtistDetailCollectionViewController"];
        artistDetail.artistName = artistNames[indexPath.row];
        CustomTableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        artistDetail.artistImage = cell.myImageView.image;
        [self.navigationController pushViewController:artistDetail animated:YES];
    }
}

#pragma mark - UITableViewDataSource

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
    if (songNames.count == 0 && artistNames.count == 0 && albumNames.count == 0 && ![self.searchController.searchBar.text isEqualToString:@""]) {
        
        messageLabel = messageLabel ? :[[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        image = image ? : [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        if (self.myError) {
            messageLabel.text = [self.myError.userInfo objectForKey:NSLocalizedDescriptionKey];
            image.image = [UIImage imageNamed:@"Error"];
        } else {
            messageLabel.text = [NSString stringWithFormat:@"No results found for %@", self.searchController.searchBar.text];
            image.image = [UIImage imageNamed:@"Search"];
        }
        UIView *message = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.bounds.size.width, self.tableView.bounds.size.height)];
        [message addSubview:messageLabel];
        [message addSubview:image];
        messageLabel.textColor = [UIColor darkGrayColor];
        messageLabel.numberOfLines = 2;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        messageLabel.center = message.center;
        image.center = CGPointMake(message.center.x, message.center.y - 60);
        self.tableView.backgroundView = message;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        return 0;
    }else {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 4;
    }
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
    headerTitle.textColor = [UIColor blackColor];
    [headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:headerTitle];
    
    
    UIButton *seeAll = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [seeAll setImage:[UIImage imageNamed:@"Right Chevron"] forState:UIControlStateNormal];
    [seeAll setTitleEdgeInsets:UIEdgeInsetsMake(0, -105.0, 0, 0)];
    [seeAll setImageEdgeInsets:UIEdgeInsetsMake(3, -2, 3, 18)];
    [seeAll setContentEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
    [seeAll setTitle:@"SEE ALL" forState:UIControlStateNormal];
    [seeAll setReversesTitleShadowWhenHighlighted:YES];
    [[seeAll titleLabel] setFont:[UIFont systemFontOfSize:12]];
    [seeAll setTranslatesAutoresizingMaskIntoConstraints:NO];
    [seeAll addTarget:self action:@selector(seeAll:) forControlEvents:UIControlEventTouchUpInside];
    seeAll.tag = section;
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

#pragma mark - UISearchBarDelegate

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar {
    [searchBar resignFirstResponder];
}


-(void)updateSearchResultsForSearchController:(UISearchController *)searchController {
    if (![searchController.searchBar.text isEqualToString:@""]) {
        if (searchBlock != nil) {
            cancel_block(searchBlock);
        }
        searchBlock = dispatch_after_delay(searchBlockDelay, ^{
            [self search:searchController.searchBar.text];
        });
    }else {
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
        
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = self.tableView.center;
        self.tableView.backgroundView = indicator;
        [indicator sizeToFit];
        [indicator startAnimating];
        
    }
}

- (void)search:(NSString *)searchText {
    dispatch_group_t group = dispatch_group_create();
    dispatch_group_enter(group);
    [TEngine searchAlbumsByAlbumName:searchText resolver:RDeezer limit:4 page:0 completion:^(id response) {
        if ([response isKindOfClass:[NSError class]]) {
            self.myError = response;
        }else {
            self.myError = nil;
            albumNames = [response objectForKey:@"albumNames"];
            albumArtists = [response objectForKey:@"artistNames"];
            albumImages = [response objectForKey:@"albumImages"];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [TEngine searchSongsBySongName:searchText resolver:RGenius limit:4 page:0 completion:^(id response) {
        if ([response isKindOfClass:[NSError class]]) {
            self.myError = response;
        }else {
            self.myError = nil;
            songNames = [response objectForKey:@"songNames"];
            songAlbums = [response objectForKey:@"albumNames"];
            songArtists = [response objectForKey:@"artistNames"];
            songImages = [response objectForKey:@"songImages"];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_enter(group);
    [TEngine searchArtistsByArtistName:searchText resolver:RDeezer limit:4 page:0 completion:^(id response) {
        if ([response isKindOfClass:[NSError class]]) {
            self.myError = response;
        }else {
            self.myError = nil;
            artistFollowers = [response objectForKey:@"artistFollowers"];
            artistImages = [response objectForKey:@"artistImages"];
            artistNames = [response objectForKey:@"artistNames"];
        }
        dispatch_group_leave(group);
    }];
    
    dispatch_group_notify(group, dispatch_get_main_queue(), ^{
        [self.tableView reloadData];
    });
}




@end
