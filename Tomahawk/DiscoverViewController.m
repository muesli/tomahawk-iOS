//
//  DiscoverViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "DiscoverViewController.h"


@interface DiscoverViewController (){
    UIButton *songsSeeAllButton;
    UIButton *songsSeeAllInvisible;
    UIButton *playlistsSeeAllButton;
    UIButton *playlistsSeeAllInvisible;
    UILabel *playlistsHeader, *songsHeader;
    UIImageView *imageView;
}

@end

@implementation DiscoverViewController

- (IBAction)inboxButton:(id)sender {
    //TODO: Insert Code
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

-(void)reloadView{
    NSLog(@"Section is: %d", isSection);
    if (isSection == 0) {
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
        songsHeader = [[UILabel alloc]init];
        songsHeader.text = @"RECOMMENDED SONGS";
        playlistsHeader = [[UILabel alloc]init];
        playlistsHeader.text = @"RECOMMENDED PLAYLISTS";
        myArray = [[NSArray alloc]initWithObjects:songsHeader,playlistsHeader, nil];
        
        for (UILabel *headers in myArray) {
            headers.font = [UIFont systemFontOfSize:12 weight:0.2];
            headers.alpha = 0.5;
            headers.textColor = [UIColor whiteColor];
            [headers setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self.scrollView addSubview:headers];
        }
    
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, CGRectGetWidth(self.view.frame), 140.0)];
        [self.scrollView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"12.png"]];
        
        //Create Invisible Buttons to Act as Pressers
        songsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        playlistsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        myArray = @[songsSeeAllInvisible, playlistsSeeAllInvisible];
        
        for (UIButton *buttons in myArray) {
            [buttons setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_scrollView addSubview:buttons];
            [buttons addTarget:self action:@selector(simulateButtonPress:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
            [buttons addTarget:self action:@selector(simulateButtonRelease:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        }

        
        [self autoLayoutConstraints];

    }else{
    }
    

}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadView];
    
    //Set Height of ScrollView
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width, 1000)];
    //Set background colour to invisible
    _recommendedSongs.backgroundColor = [UIColor clearColor];
    _recommendedSongs.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _recommendedPlaylists.backgroundColor = [UIColor clearColor];
    _recommendedPlaylists.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
    
#pragma mark - Custom Segmented Control
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"FOR YOU", @"CHARTS", @"LIKED", @" NEW SONGS"]];
    //First value: Left padding Second value: Top padding Third Value: Width Fourth Value: Height
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    segmentedControl.frame = CGRectMake(0, 0, viewWidth *0.97, 40);
    segmentedControl.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    [segmentedControl addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    UIView *barbackground = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(segmentedControl.frame), viewWidth, CGRectGetHeight(segmentedControl.frame))];
    barbackground.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    [self.view addSubview:barbackground];
    [self.view addSubview:segmentedControl];
    

}

#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    if (isSection == 0) {
        return 14;
    }else{
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (collectionView == _recommendedSongs) {
        CollectionViewCell *recommendedSongs = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedSongs" forIndexPath:indexPath];
        recommendedSongs.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        recommendedSongs.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample3"]];
        recommendedSongs.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        recommendedSongs.title = [[UILabel alloc]init];
        recommendedSongs.artist = [[UILabel alloc]init];
        recommendedSongs.detailText = [[UILabel alloc]init];
        recommendedSongs.title.text = @"Label";
        recommendedSongs.artist.text = @"Label";
        recommendedSongs.detailText.text = @"1234";
        recommendedSongs.big = NO;
        return recommendedSongs;
    }else if (collectionView == _recommendedPlaylists){
        CollectionViewCell *recommendedPlaylists = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedPlaylists" forIndexPath:indexPath];
        recommendedPlaylists.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        recommendedPlaylists.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample4"]];
        recommendedPlaylists.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        recommendedPlaylists.title = [[UILabel alloc]init];
        recommendedPlaylists.artist = [[UILabel alloc]init];
        recommendedPlaylists.detailText = [[UILabel alloc]init];
        recommendedPlaylists.title.text = @"Label";
        recommendedPlaylists.artist.text = @"Label";
        recommendedPlaylists.detailText.text = @"1234";
        recommendedPlaylists.big = NO;
        return recommendedPlaylists;
    }
    return nil;

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if (segmentedControl.selectedSegmentIndex == 0) {
        isSection = 0;
    }else if (segmentedControl.selectedSegmentIndex == 1){
        isSection = 1;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }

    }else if (segmentedControl.selectedSegmentIndex == 2){
        isSection = 2;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
    }else if (segmentedControl.selectedSegmentIndex == 3){
        isSection = 3;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
    }
    [_recommendedSongs reloadData];
    [_recommendedPlaylists reloadData];
    [self reloadView];
}

#pragma mark - Auto Layout Constraints

- (void)autoLayoutConstraints{
    
    //Songs Button Right Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1
                                                           constant:50.0]];
    
    //Songs Button Top Constraint
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:165]];
    
    //Songs Invisible Button Right Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:songsSeeAllButton
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:-49.0]];
    
    //Songs Invisible Button Top Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:songsSeeAllButton
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    //Songs Invisible Button Height Constraint
    [songsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:20.0
                                                                      constant:15.0]];
    
    //Songs Invisible Button Width Constraint
    [songsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:songsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:20.0
                                                                      constant:60.0]];
    
    //Songs Header Right Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:songsHeader
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1
                                                           constant:10.0]];
    
    //Songs Header Top Constraint
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:songsHeader
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:165]];
    
    //Playlists Button Right Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1
                                                           constant:50.0]];
    
    //Playlists Button Top Constraint
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:412]];
    
    //Invisible Playlists Button Right Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:playlistsSeeAllButton
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:-49.0]];
    
    //Invisible Playlists Button Top Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:playlistsSeeAllButton
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    //Invisible Playlists Button Height Constraint
    [playlistsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:20.0
                                                                          constant:15.0]];
    
    //Invisible Playlists Button Width Constraint
    [playlistsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:playlistsSeeAllInvisible
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:20.0
                                                                          constant:60.0]];
    
    //Playlists Header Right Constraint
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:playlistsHeader
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1
                                                           constant:10.0]];
    
    //Playlists Header Top Constraint
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:playlistsHeader
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:412]];
}


@end