//
//  MyMusicViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "MyMusicViewController.h"

@interface MyMusicViewController ()

@end
@implementation MyMusicViewController{
    NSString *myCellText;
    int shouldShowDetails;
}
- (IBAction)inboxButton:(id *)sender {
    //Insert Code Here
}

-(void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = false;
    NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:currentCell animated:YES];
}


- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    //self.tableView.delaysContentTouches = NO;   //Removes stupid delay when button selecting
    UISwipeGestureRecognizer *leftSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    leftSwipe.direction = UISwipeGestureRecognizerDirectionLeft;
    [self.view addGestureRecognizer:leftSwipe];
    
    UISwipeGestureRecognizer *rightSwipe = [[UISwipeGestureRecognizer alloc]initWithTarget:self action:@selector(didSwipe:)];
    rightSwipe.direction = UISwipeGestureRecognizerDirectionRight;
    [self.view addGestureRecognizer:rightSwipe];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    CGFloat viewWidth = CGRectGetWidth(self.view.frame);
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.tableView.contentInset = UIEdgeInsetsMake(40.0f, 0.0f, 0.0f, 0.0f);
    self.tableView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1.0];
    myCellText = @"Placeholder";
    
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
    searchController.searchBar.frame = CGRectMake(0, 0, 10,CGRectGetHeight(searchController.searchBar.frame));
    self.navigationItem.titleView = searchController.searchBar;
//    [inboxButton setImage:[UIImage imageNamed:@"Inbox"] forState:UIControlStateNormal];
//    [inboxButton setImage:[UIImage imageNamed:@"Inbox Selected"] forState:UIControlStateHighlighted];
//    inboxButton.frame = CGRectMake(CGRectGetWidth(self.view.frame) * 0.89, 28, 20, 20);

    [self segmentedControl];
#pragma mark - Now Playing Bar
    
    UIVisualEffect *blurEffect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight];
    UIVisualEffectView *visualEffectView = [[UIVisualEffectView alloc] initWithEffect:blurEffect];
     visualEffectView.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:61.0f/255.0f alpha:0.6f];
    visualEffectView.alpha = 1;
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    visualEffectView.frame = CGRectMake(0, CGRectGetMinY(self.tabBarController.tabBar.frame) - tabBarHeight*2.3 , viewWidth, CGRectGetHeight(self.tabBarController.tabBar.frame));
    
    [self.view addSubview:visualEffectView];

}

#pragma mark - Custom Segmented Control
    
-(void)segmentedControl{
    
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"PLAYLISTS", @"SONGS"]];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(7, 0, CGRectGetWidth(self.view.frame)*0.95, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.verticalDividerEnabled = NO;
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:12.0f weight:0.3f]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    UIView *barbackground = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(segmentedControl1.frame),  CGRectGetWidth(self.view.frame), CGRectGetHeight(segmentedControl1.frame))];
    barbackground.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    [self.view addSubview:barbackground];

    //Adding the Segmented Control to the View
    [self.view addSubview:segmentedControl1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    UIButton *more=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"More"];
    [more setImage:image forState:UIControlStateNormal];
    more.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    more.tag = indexPath.row;
    [more addTarget:self action:@selector(moreButtonTouched:forEvent:)forControlEvents:UIControlEventTouchUpInside];
    [more setContentMode:UIViewContentModeScaleToFill];
    cell.accessoryView = more;
    [[cell textLabel] setTextColor:([UIColor whiteColor])];
    cell.textLabel.text = myCellText;
    cell.detailTextLabel.text = @"Placeholder";
    cell.accessoryType = UITableViewCellAccessoryDetailDisclosureButton;
    cell.backgroundColor = [UIColor colorWithRed:(29.0/255.0) green:(30.0/255.0) blue:(35.0/255.0) alpha:(1.0)];
    //Create Buttons

    
    if (shouldShowDetails == 1){
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
        headerView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0];
        UILabel *textLabel = [[UILabel alloc]init];
        [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        textLabel.text = @"64 Songs Saved";
        textLabel.textColor = [UIColor whiteColor];
        [headerView addSubview:textLabel];
        
        UIButton *download = [UIButton buttonWithType:UIButtonTypeCustom];
        [download setImage:[UIImage imageNamed:@"Cloud"] forState:UIControlStateNormal];
        [download setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:download];
        
        UIButton *shuffle = [UIButton buttonWithType:UIButtonTypeCustom];
        [shuffle setImage:[UIImage imageNamed:@"Shuffle"] forState:UIControlStateNormal];
        [shuffle setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:shuffle];
        
        //Download Button Right
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:download
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:0.95
                                                                constant:0.0]];
        //Download Button Top
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:download
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
        //Shuffle Button Right
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:shuffle
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:0.82
                                                                constant:0.0]];
        //Shuffle Button Top
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:shuffle
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
        
        //Label Left
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                              multiplier:3.3
                                                                constant:0.0]];
        //Label Top
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
        
        tableView.tableHeaderView = headerView;

    }else if (shouldShowDetails == 0){
        //Remove Buttons and allow to be selected
        tableView.tableHeaderView = nil;
        [self.tableView.tableHeaderView removeFromSuperview];
    }
    //Turns off retarded stuff
    [[self tableView]setAlwaysBounceVertical:NO];
    [[self tableView]setBounces:NO];
    [[self tableView]setDelaysContentTouches:NO];
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        return nil;
    }
    return indexPath;
}

-(IBAction)moreButtonTouched:(id)sender forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    // Lookup the index path of the cell whose checkbox was modified.
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"Cock.jpg");
}


#pragma mark - Segmented Control changes

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == 1){
        myCellText = @"PLACEHOLDER";
        //Reset Scroll Position when change Segment
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        shouldShowDetails = 1;
        [self.tableView reloadData];
        
    }else{
        shouldShowDetails = 0;
        myCellText = @"Placeholder";
        //Reset Scroll Position when change Segment
        [self.tableView scrollRectToVisible:CGRectMake(0, 0, 1, 1) animated:NO];
        [self.tableView reloadData];
    }

}


#pragma mark - Gesture recogniser

-(void)didSwipe:(UISwipeGestureRecognizer *)sender{
    UISwipeGestureRecognizerDirection direction = sender.direction;
    HMSegmentedControl *selectedSegment = [[HMSegmentedControl alloc]init];
    switch (direction) {
        case UISwipeGestureRecognizerDirectionLeft:
            selectedSegment.selectedSegmentIndex = 1;
            [selectedSegment setSelectedSegmentIndex:0 animated:YES];
            break;
        case UISwipeGestureRecognizerDirectionRight:
            selectedSegment.selectedSegmentIndex = 0;
            [selectedSegment setSelectedSegmentIndex:1 animated:YES];
        default:
            break;
    }
}


#pragma Preparing for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    InsidePlaylistsViewController *svc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
     NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
    
}

@end