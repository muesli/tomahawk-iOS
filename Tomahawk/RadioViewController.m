//
//  RadioViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 11/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "RadioViewController.h"


@interface RadioViewController (){
    UIButton *stationsSeeAllButton, *stationsSeeAllInvisible, *genresSeeAllButton, *genresSeeAllInvisible, *artistSeeAllButton, *artistSeeAllInvisible, *internetRadioSeeAllButton, *internetRadioSeeAllInvisible;
    UILabel *stationsHeader, *genresHeader, *artistHeader, *internetRadioHeader;
    UIImageView *imageView;
    int isSection;
    UICollectionView *genresCollectionView, *artistCollectionView, *internetRadioCollectionView;
    NSArray *myArray;
    UIBarButtonItem *barButton;
}

@end

@implementation RadioViewController

- (IBAction)inboxButton:(id)sender {
    //Insert Code
}
- (IBAction)internetRadioButton:(id)sender {
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
- (IBAction)simulateButtonPress2:(UIButton *)sender {
    [artistSeeAllButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonRelease2:(UIButton *)sender {
    [artistSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonPress3:(UIButton *)sender {
    [internetRadioSeeAllButton setTitleColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.5] forState:UIControlStateNormal];
}
- (IBAction)simulateButtonRelease3:(UIButton *)sender {
    [internetRadioSeeAllButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

-(void)reloadView{
    [_scrollView setContentSize:CGSizeMake(self.view.frame.size.width,1000)];  //Set Size of Scroll View
    // Check Segmented Control Section
    if (isSection == 0) {
        stationsHeader = [[UILabel alloc]init];
        genresHeader = [[UILabel alloc]init];
        myArray = [NSArray arrayWithObjects:stationsHeader, genresHeader, nil];
        for (UILabel *labels in myArray) {
            labels.font = [UIFont systemFontOfSize:12 weight:0.2];
            labels.alpha = 0.5;
            labels.textColor = [UIColor whiteColor];
            [labels setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_scrollView addSubview:labels];
        }
        //Set Header Text
        stationsHeader.text = @"RECOMMENDED STATIONS";
        genresHeader.text = @"RECOMMENDED GENRES";
        
        
        //Invisible Buttons to Act as Pressers
        stationsSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        genresSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        
        //Turn Off Auto Layout to Add Custom Constraints
        [stationsSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [genresSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [_scrollView addSubview:stationsSeeAllInvisible];
        [_scrollView addSubview:genresSeeAllInvisible];
        
        [stationsSeeAllInvisible addTarget:self action:@selector(simulateButtonPress:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [stationsSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
    
        [genresSeeAllInvisible addTarget:self action:@selector(simulateButtonPress1:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [genresSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease1:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        
        //Create Header Buttons
        stationsSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        genresSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        myArray = [NSArray arrayWithObjects:stationsSeeAllButton, genresSeeAllButton, nil];
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
        
        //Create Image View
        imageView = [[UIImageView alloc]initWithFrame:CGRectMake(4, 0, CGRectGetWidth(self.view.frame), 140.0)];
        [imageView setImage:[UIImage imageNamed:@"13.png"]];
        [self.scrollView addSubview:imageView];
        
        [self autoLayoutConstraints]; //Create Custom Layout Constraints
        
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
    }else if(isSection == 3){
        //Create Flow Layout
        UICollectionViewFlowLayout* flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(140, 190);
        [flowLayout setSectionInset:UIEdgeInsetsMake(10, 10, 10, 10)];
        [flowLayout setMinimumInteritemSpacing:10];
        [flowLayout setMinimumLineSpacing:10];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        
        if (!artistCollectionView) {
            artistCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
            [self.scrollView addSubview:artistCollectionView];
        }if (!internetRadioCollectionView) {
            internetRadioCollectionView = [[UICollectionView alloc]initWithFrame:self.view.frame collectionViewLayout:flowLayout];
            [self.scrollView addSubview:internetRadioCollectionView];
        }
        
        myArray = [NSArray arrayWithObjects:artistCollectionView, internetRadioCollectionView, nil];
        for (UICollectionView *collectionViews in myArray) {
            collectionViews.backgroundColor = [UIColor clearColor];
            collectionViews.delegate = self;
            collectionViews.dataSource = self;
            collectionViews.bounces = FALSE;
            collectionViews.showsHorizontalScrollIndicator = FALSE;
        }
        [artistCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"artistCollectionView"];
        artistCollectionView.frame = CGRectMake(15, 8, self.view.frame.size.width - 15, 273);
        [internetRadioCollectionView registerClass:[CollectionViewCell class] forCellWithReuseIdentifier:@"internetRadioCollectionView"];
        internetRadioCollectionView.frame = CGRectMake(15, 252, self.view.frame.size.width - 15, 273);
        
        artistHeader = [[UILabel alloc]init];
        internetRadioHeader = [[UILabel alloc]init];
        
        myArray = [[NSArray alloc]initWithObjects:artistHeader, internetRadioHeader, nil];
        for (UILabel *labels in myArray) {
            labels.font = [UIFont systemFontOfSize:12 weight:0.2];
            labels.alpha = 0.5;
            labels.textColor = [UIColor whiteColor];
            [labels setTranslatesAutoresizingMaskIntoConstraints:NO];
            [_scrollView addSubview:labels];

        }

        artistHeader.text = @"FOLLOWED ARTISTS";
        internetRadioHeader.text = @"INTERNET RADIO";
        
        //Create Header Buttons
        artistSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        internetRadioSeeAllButton = [UIButton buttonWithType:UIButtonTypeCustom];
        
        myArray = [[NSArray alloc]initWithObjects:artistSeeAllButton, internetRadioSeeAllButton, nil];
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
        //Create Invisible Header Buttons to Act as A Presser
        artistSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        [artistSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:artistSeeAllInvisible];
        [artistSeeAllInvisible addTarget:self action:@selector(simulateButtonPress2:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [artistSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease2:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        internetRadioSeeAllInvisible = [UIButton buttonWithType:UIButtonTypeCustom];
        [internetRadioSeeAllInvisible setTranslatesAutoresizingMaskIntoConstraints:NO];
        [_scrollView addSubview:internetRadioSeeAllInvisible];
        [internetRadioSeeAllInvisible addTarget:self action:@selector(simulateButtonPress3:)forControlEvents:UIControlEventTouchDragInside | UIControlEventTouchDown];
        [internetRadioSeeAllInvisible addTarget:self action:@selector(simulateButtonRelease3:)forControlEvents:UIControlEventTouchDragOutside | UIControlEventTouchUpInside | UIControlEventTouchUpOutside];
        
        [self autoLayoutConstraints];
        

    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self reloadView];
    barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
    self.navigationItem.rightBarButtonItem = barButton;
    _recommendedStations.backgroundColor = [UIColor clearColor];
    _recommendedStations.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
    _recommendedGenres.backgroundColor = [UIColor clearColor];
    _recommendedGenres.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];

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
    }else if (isSection == 3){
        return 12;
    }else{
        return 0;
    }
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (isSection == 0) {
        if ([collectionView isEqual:_recommendedStations]) {
            CollectionViewCell *recommendedStations = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedStations" forIndexPath:indexPath];
            recommendedStations.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
            recommendedStations.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample5"]];
            recommendedStations.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
            recommendedStations.title = [[UILabel alloc]init];
            recommendedStations.artist = [[UILabel alloc]init];
            recommendedStations.detailText = [[UILabel alloc]init];
            recommendedStations.title.text = @"Label";
            recommendedStations.artist.text = @"Label";
            recommendedStations.detailText.text = @"1234";
            recommendedStations.big = NO;
            return recommendedStations;
        }else if ([collectionView isEqual:_recommendedGenres]){
            CollectionViewCell *recommendedGenres = [collectionView dequeueReusableCellWithReuseIdentifier:@"recommendedGenres" forIndexPath:indexPath];
            recommendedGenres.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
            if (indexPath.row == 1) {
                recommendedGenres.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample3"]];
            }else if (indexPath.row == 2){
                recommendedGenres.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample2"]];
            }else{
                recommendedGenres.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample6"]];
            }
            recommendedGenres.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
            recommendedGenres.title = [[UILabel alloc]init];
            recommendedGenres.artist = [[UILabel alloc]init];
            recommendedGenres.detailText = [[UILabel alloc]init];
            recommendedGenres.title.text = @"Label";
            recommendedGenres.artist.text = @"Label";
            recommendedGenres.detailText.text = @"1234";
            recommendedGenres.big = NO;
            return recommendedGenres;
        }
    }else if (isSection == 1) {
        CollectionViewCell *genres = [genresCollectionView dequeueReusableCellWithReuseIdentifier:@"genresCollection" forIndexPath:indexPath];
        genres.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
        genres.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample5"]];
        genres.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
        genres.title = [[UILabel alloc]init];
        genres.artist = [[UILabel alloc]init];
        genres.detailText = [[UILabel alloc]init];
        genres.title.text = @"Label";
        genres.artist.text = @"Label";
        genres.detailText.text = @"1234";
        genres.big = YES;
        return genres;
    }else if (isSection == 3) {
        if ([collectionView isEqual:artistCollectionView]) {
            CollectionViewCell *artist = [artistCollectionView dequeueReusableCellWithReuseIdentifier:@"artistCollectionView" forIndexPath:indexPath];
            artist.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
            artist.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample1"]];
            artist.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
            artist.title = [[UILabel alloc]init];
            artist.artist = [[UILabel alloc]init];
            artist.detailText = [[UILabel alloc]init];
            artist.title.text = @"Label";
            artist.artist.text = @"Label";
            artist.detailText.text = @"1234";
            artist.big = NO;
            return artist;
        }else if ([collectionView isEqual:internetRadioCollectionView]){
            CollectionViewCell *internetRadio = [internetRadioCollectionView dequeueReusableCellWithReuseIdentifier:@"internetRadioCollectionView" forIndexPath:indexPath];
            internetRadio.backgroundColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.1];
            internetRadio.image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"blurExample2"]];
            internetRadio.detailImage = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"headphone4.png"]];
            internetRadio.title = [[UILabel alloc]init];
            internetRadio.artist = [[UILabel alloc]init];
            internetRadio.detailText = [[UILabel alloc]init];
            internetRadio.title.text = @"Label";
            internetRadio.artist.text = @"Label";
            internetRadio.detailText.text = @"1234";
            internetRadio.big = NO;
            return internetRadio;
        }
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
        barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
        self.navigationItem.rightBarButtonItem = barButton;
        artistCollectionView.hidden = YES;
        internetRadioCollectionView.hidden = YES;
        _recommendedStations.hidden = NO;
        _recommendedGenres.hidden = NO;
        for (UIView *subview in self.view.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UIImageView class]] || [subview isKindOfClass:[UILabel class]] || [subview isKindOfClass:[UICollectionView class]]) {
                [subview removeFromSuperview];
            }
        }
        for (UIView *subview in self.scrollView.subviews) {
            if ([subview isKindOfClass:[UIButton class]] || [subview isKindOfClass:[UILabel class]]){
                [subview removeFromSuperview];
            }
        }
        [self.scrollView setUserInteractionEnabled:YES];
        [self.scrollView setHidden:NO];
    }else if (segmentedControl.selectedSegmentIndex == 1){
        isSection = 1;
        barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
        self.navigationItem.rightBarButtonItem = barButton;
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
        barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButton:)];
        self.navigationItem.rightBarButtonItem = barButton;
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
        [self.scrollView setUserInteractionEnabled:NO];
        [self.scrollView setHidden:YES];
    }else if (segmentedControl.selectedSegmentIndex == 3){
        isSection = 3;
        barButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Microphone Add"] style:UIBarButtonItemStylePlain target:self action:@selector(internetRadioButton:)];
        self.navigationItem.rightBarButtonItem = barButton;
        internetRadioCollectionView.hidden = NO;
        artistCollectionView.hidden = NO;
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
        [self.scrollView setUserInteractionEnabled:YES];
        [self.scrollView setHidden:NO];
    }
    [self reloadView];
}


- (UIStatusBarStyle)preferredStatusBarStyle{
    
    return UIStatusBarStyleLightContent;
}
#pragma mark - Auto Layout Constraints

- (void)autoLayoutConstraints{
    
    if (isSection == 0) {
        
        //Stations Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllButton
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                             multiplier:1
                                                               constant:50.0]];
        
        //Stations Button Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllButton
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:165]];
        
        //Stations Invisible Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:stationsSeeAllButton
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:-49.0]];
        
        //Stations Invisible Button Top Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:stationsSeeAllButton
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        //Stations Invisible Button Height Constraint
        [stationsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                                            attribute:NSLayoutAttributeHeight
                                                                            relatedBy:NSLayoutRelationLessThanOrEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeHeight
                                                                           multiplier:20.0
                                                                             constant:15.0]];
        
        //Stations Invisible Button Width Constraint
        [stationsSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:stationsSeeAllInvisible
                                                                            attribute:NSLayoutAttributeWidth
                                                                            relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                               toItem:nil
                                                                            attribute:NSLayoutAttributeWidth
                                                                           multiplier:20.0
                                                                             constant:60.0]];
        
        //Stations Header Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:stationsHeader
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                             multiplier:1
                                                               constant:10.0]];
        
        //Stations Header Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:stationsHeader
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:165]];
        
        //Genres Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllButton
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                             multiplier:1
                                                               constant:50.0]];
        
        //Genres Button Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllButton
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:412]];
        
        //Genres Invisible Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:genresSeeAllButton
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:-49.0]];
        
        //Genres Invisible Button Top Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:genresSeeAllButton
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        //Genres Invisible Button Height Constraint
        [genresSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeHeight
                                                                         multiplier:20.0
                                                                           constant:15.0]];
        
        //Genres Invisible Button Width Constraint
        [genresSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:genresSeeAllInvisible
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:20.0
                                                                           constant:60.0]];
        
        //Genres Header Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:genresHeader
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                             multiplier:1
                                                               constant:10.0]];
        
        //Genres Header Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:genresHeader
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:412]];
        
    }else if (isSection == 3) {
        //Artist Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:artistSeeAllButton
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                             multiplier:1
                                                               constant:50.0]];
        
        //Artist Button Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:artistSeeAllButton
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:20]];
        
        //Artist Invisible Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:artistSeeAllInvisible
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:artistSeeAllButton
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:-49.0]];
        
        //Artist Invisible Button Top Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:artistSeeAllInvisible
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:artistSeeAllButton
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        //Artist Invisible Button Height Constraint
        [artistSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:artistSeeAllInvisible
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeHeight
                                                                         multiplier:20.0
                                                                           constant:15.0]];
        
        //Artist Invisible Button Width Constraint
        [artistSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:artistSeeAllInvisible
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:20.0
                                                                           constant:60.0]];
        
        //Artist Header Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:artistHeader
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                             multiplier:1
                                                               constant:10.0]];
        
        //Artist Header Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:artistHeader
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:20]];
        
        //Internet Radio Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioSeeAllButton
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                             multiplier:1
                                                               constant:50.0]];
        
        //Internet Radio Button Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioSeeAllButton
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:266]];
        
        //Internet Radio Invisible Button Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioSeeAllInvisible
                                                              attribute:NSLayoutAttributeLeft
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:internetRadioSeeAllButton
                                                              attribute:NSLayoutAttributeLeft
                                                             multiplier:1.0
                                                               constant:-49.0]];
        
        //Internet Radio Invisible Button Top Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioSeeAllInvisible
                                                              attribute:NSLayoutAttributeCenterY
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:internetRadioSeeAllButton
                                                              attribute:NSLayoutAttributeCenterY
                                                             multiplier:1.0
                                                               constant:0.0]];
        
        //Internet Radio Invisible Button Height Constraint
        [internetRadioSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioSeeAllInvisible
                                                                          attribute:NSLayoutAttributeHeight
                                                                          relatedBy:NSLayoutRelationLessThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeHeight
                                                                         multiplier:20.0
                                                                           constant:15.0]];
        
        //Internet Radio Invisible Button Width Constraint
        [internetRadioSeeAllInvisible addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioSeeAllInvisible
                                                                          attribute:NSLayoutAttributeWidth
                                                                          relatedBy:NSLayoutRelationGreaterThanOrEqual
                                                                             toItem:nil
                                                                          attribute:NSLayoutAttributeWidth
                                                                         multiplier:20.0
                                                                           constant:60.0]];
        
        //Internet Radio Header Right Constraint
        [self.view addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioHeader
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:self.view
                                                              attribute:NSLayoutAttributeLeadingMargin
                                                             multiplier:1
                                                               constant:10.0]];
        
        //Internet Radio Header Top Constraint
        [_scrollView addConstraint:[NSLayoutConstraint constraintWithItem:internetRadioHeader
                                                                attribute:NSLayoutAttributeTop
                                                                relatedBy:NSLayoutRelationEqual
                                                                   toItem:_scrollView
                                                                attribute:NSLayoutAttributeTop
                                                               multiplier:1
                                                                 constant:266]];
    }
}


@end
