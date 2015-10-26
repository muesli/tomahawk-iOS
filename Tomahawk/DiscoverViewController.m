//
//  DiscoverViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "DiscoverViewController.h"

@interface DiscoverViewController ()

@end

@implementation DiscoverViewController
- (IBAction)inboxButton:(id)sender {
    //Insert Code
}


- (void)viewDidLoad {
    [super viewDidLoad];
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
    
#pragma mark - Now Playing Bar
    CGFloat tabBarHeight = CGRectGetHeight(self.tabBarController.tabBar.frame);
    UITabBar *nowPlayingBar = [[UITabBar alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(self.tabBarController.tabBar.frame) - tabBarHeight*2.3 , viewWidth, CGRectGetHeight(self.tabBarController.tabBar.frame))];
    nowPlayingBar.barTintColor = [UIColor colorWithRed:37.0f/255.0f green:37.0f/255.0f blue:46.0f/255.0f alpha:1.0f];
    nowPlayingBar.translucent = YES;
    nowPlayingBar.barStyle = UIBarStyleBlack;
    [self.view addSubview:nowPlayingBar];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    NSLog(@"Selected index %ld (via UIControlEventValueChanged)", segmentedControl.selectedSegmentIndex);
}

//- (UIStatusBarStyle)preferredStatusBarStyle
//{
//    return UIStatusBarStyleLightContent;
//}

@end