//
//  RadioViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 11/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "RadioViewController.h"


@interface RadioViewController (){
    UIButton *stationsSeeAllButton;
    UIButton *stationsSeeAllInvisible;
    UIButton *genresSeeAllButton;
    UIButton *genresSeeAllInvisible;
    UILabel *stationsHeader, *genresHeader;
    UIImageView *imageView;
    int isSection;
    UICollectionView *genresCollectionView;
}

@end

@implementation RadioViewController

- (IBAction)inboxButton:(id)sender {
    //Insert Code
}
- (IBAction)simulateButtonPress:(UIButton *)sender {
    [stationsSeeAllButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonRelease:(UIButton *)sender {
    [stationsSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonPress1:(UIButton *)sender {
    [genresSeeAllButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonRelease1:(UIButton *)sender {
    [genresSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)reloadView{
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width,1000)];
    NSLog(@"Section is: %d", isSection);
    if (isSection == 0) {
        stationsHeader = [[UILabel alloc]init];
        stationsHeader.text = @"RECOMMENDED STATIONS";
        stationsHeader.font = [UIFont systemFontOfSize:12 weight:0.2];
        stationsHeader.alpha = 0.5;
        stationsHeader.textColor = [UIColor whiteColor];
        [stationsHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:stationsHeader];
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(6, 0, CGRectGetWidth(self.view.frame), 140.0)];
        [self.scrollView addSubview:imageView];
        [imageView setImage:[UIImage imageNamed:@"13.png"]];
        //Create Invisible See All Button to Act as A Presser
        stationsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        //[seeAllInvisible setBackgroundColor:[UIColor redColor]];
        [stationsSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:stationsSeeAllInvisible];
        [stationsSeeAllInvisible addTarget:self action:@selector(simulateButtonPress:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [stationsSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        //Create See All Button
        stationsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [stationsSeeAllButton setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [stationsSeeAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [stationsSeeAllButton setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [stationsSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[stationsSeeAllButton titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [stationsSeeAllButton setEnabled:NO];
        [stationsSeeAllButton setUserInteractionEnabled:NO];
        [stationsSeeAllButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:stationsSeeAllButton];
        
        
        genresHeader = [[UILabel alloc]init];
        genresHeader.text = @"RECOMMENDED GENRES";
        genresHeader.font = [UIFont systemFontOfSize:12 weight:0.2];
        genresHeader.alpha = 0.5;
        genresHeader.textColor = [UIColor whiteColor];
        [genresHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:genresHeader];
        //Create Invisible See All Button to Act as A Presser
        genresSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        //[seeAllInvisible setBackgroundColor:[UIColor redColor]];
        [genresSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:genresSeeAllInvisible];
        [genresSeeAllInvisible addTarget:self action:@selector(simulateButtonPress1:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [genresSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease1:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        //Create See All Button
        genresSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [genresSeeAllButton setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
        [genresSeeAllButton setTitleEdgeInsets:UIEdgeInsetsMake(0, -120.0, 0, 0)];
        [genresSeeAllButton setTitle:@"SEE ALL" forState:UIControlStateNormal];
        [genresSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [[genresSeeAllButton titleLabel] setFont:[UIFont systemFontOfSize:12]];
        [genresSeeAllButton setEnabled:NO];
        [genresSeeAllButton setUserInteractionEnabled:NO];
        [genresSeeAllButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.scrollView addSubview:genresSeeAllButton];
        [self autoLayoutConstraints];
        
    }else if(isSection == 1){
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(160, 210);
        [flowLayout setSectionInset:UIEdgeInsetsMake(15, 15, 15, 15)];
        [flowLayout setMinimumInteritemSpacing:20];
        [flowLayout setMinimumLineSpacing:20];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        genresCollectionView = [[UICollectionView alloc] initWithFrame:self.view.frame collectionViewLayout:flowLayout];
        [genresCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"genresCollection"];
        genresCollectionView.frame = CGRectMake(0, 40, self.view.frame.size.width, self.view.frame.size.height);
        genresCollectionView.backgroundColor = [UIColor clearColor];
        genresCollectionView.delegate = self;
        genresCollectionView.dataSource = self;
        [self.view addSubview:genresCollectionView];
    }
}

#pragma mark - Auto Layout Constraints

- (void)autoLayoutConstraints{
    
    //Real Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1
                                                           constant:50.0]];
    
    //Real Button Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:165]];
    
    //Simulated Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:stationsSeeAllButton
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:-49.0]];
    
    //Simulated Button Top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:stationsSeeAllButton
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    //Simulated Height
    [stationsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeHeight
                                                                     relatedBy:NSLayoutRelationLessThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeHeight
                                                                    multiplier:20.0
                                                                      constant:15.0]];
    
    //Simulated Width
    [stationsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                                     attribute:NSLayoutAttributeWidth
                                                                     relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                        toItem:nil
                                                                     attribute:NSLayoutAttributeWidth
                                                                    multiplier:20.0
                                                                      constant:60.0]];
    
    //Header Left
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsHeader
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1
                                                           constant:10.0]];
    
    //Header Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:stationsHeader
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:165]];
    
    //Real Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllButton
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:1
                                                           constant:50.0]];
    
    //Real Button Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllButton
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:412]];
    
    //Simulated Button Right
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:genresSeeAllButton
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1.0
                                                           constant:-49.0]];
    
    //Simulated Button Top
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                          attribute:NSLayoutAttributeCenterY
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:genresSeeAllButton
                                                          attribute:NSLayoutAttributeCenterY
                                                         multiplier:1.0
                                                           constant:0.0]];
    
    //Simulated Height
    [genresSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                                         attribute:NSLayoutAttributeHeight
                                                                         relatedBy:NSLayoutRelationLessThanOrEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeHeight
                                                                        multiplier:20.0
                                                                          constant:15.0]];
    
    //Simulated Width
    [genresSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                                         attribute:NSLayoutAttributeWidth
                                                                         relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                            toItem:nil
                                                                         attribute:NSLayoutAttributeWidth
                                                                        multiplier:20.0
                                                                          constant:60.0]];
    
    //Header Left
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresHeader
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeadingMargin
                                                         multiplier:1
                                                           constant:10.0]];
    
    //Header Top
    [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genresHeader
                                                            attribute:NSLayoutAttributeTop
                                                            relatedBy:NSLayoutRelationEqual
                                                               toItem:_scrollView
                                                            attribute:NSLayoutAttributeTop
                                                           multiplier:1
                                                             constant:412]];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    _recommendedStations.hidden = NO;
    _recommendedGenres.hidden = NO;
    [self.scrollView setUserInteractionEnabled:YES];
    [self.scrollView setHidden:NO];
    [self reloadView];
    _recommendedStations.backgroundColor = [UIColor clearColor];
    _recommendedStations.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _recommendedGenres.backgroundColor = [UIColor clearColor];
    _recommendedGenres.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

//    [self setNeedsStatusBarAppearanceUpdate];
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
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

#pragma mark - Custom Segmented Control
    
    HMSegmentedControl *segmentedControl = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"FOR YOU", @"GENRES", @"MOODS", @"STATIONS"]];
    //First value: Left padding Second value: Top padding Third Value: Width Fourth Value: Height
    segmentedControl.segmentWidthStyle = HMSegmentedControlSegmentWidthStyleFixed;
    segmentedControl.frame = CGRectMake(7, 0, viewWidth *0.94, 40);
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
    }else if (isSection == 1){
        return 40;
    }else{
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isSection == 0) {
        if ([collectionView isEqual:_recommendedStations]) {
            CollectionViewCell *recommendedStations = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedStations" forIndexPath:indexPath];
            recommendedStations.big = NO;
            return recommendedStations;
        }else if ([collectionView isEqual:_recommendedGenres]){
            CollectionViewCell *recommendedGenres = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedGenres" forIndexPath:indexPath];
            recommendedGenres.big = NO;
            return recommendedGenres;
        }
    }else if (isSection == 1) {
        CollectionViewCell *genresCell = [genresCollectionView dequeueReusableCellWithReuseIdentifier:@"genresCollection" forIndexPath:indexPath];
        genresCell.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        genresCell.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample5"]];
        genresCell.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        genresCell.title = [[UILabel alloc]init];
        genresCell.artist = [[UILabel alloc]init];
        genresCell.detailText = [[UILabel alloc]init];
        genresCell.title.text = @"Cock";
        genresCell.artist.text = @"Nigger";
        genresCell.detailText.text = @"1234";
        genresCell.big = YES;
        return genresCell;
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
        _recommendedStations.hidden = NO;
        _recommendedGenres.hidden = NO;
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UICollectionView class]]) {
                [subview removeFromSuperview];
            }
        }
        [self.scrollView setUserInteractionEnabled:YES];
        [self.scrollView setHidden:NO];
    }else if (segmentedControl.selectedSegmentIndex == 1){
        isSection = 1;
        _recommendedStations.hidden = YES;
        _recommendedGenres.hidden = YES;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
        [self.scrollView setUserInteractionEnabled:NO];
        [self.scrollView setHidden:YES];
        
    }else if (segmentedControl.selectedSegmentIndex == 2){
        isSection = 2;
        _recommendedStations.hidden = YES;
        _recommendedGenres.hidden = YES;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UICollectionView class]]) {
                [subview removeFromSuperview];
            }
        }
    }else if (segmentedControl.selectedSegmentIndex == 3){
        isSection = 3;
        _recommendedStations.hidden = YES;
        _recommendedGenres.hidden = YES;
        for (UIView *subview in _scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]]) {
                [subview removeFromSuperview];
            }
        }
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UICollectionView class]]) {
                [subview removeFromSuperview];
            }
        }
    }
//    [_recommendedStations reloadData];
//    [_recommendedGenres reloadData];
//    [genresCollectionView reloadData];
    [self reloadView];
}


- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
}

@end
