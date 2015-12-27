//
//  DiscoverViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "DiscoverViewController.h"


@interface DiscoverViewController ()

@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation DiscoverViewController

- (IBAction)internetRadioButton:(id)sender {
    //Insert Code
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    ForYouDiscoverViewController *forYouController = [[ForYouDiscoverViewController alloc]initWithNibName:@"ForYouDiscoverViewController" bundle:nil];
    forYouController.title = @"FOR YOU";
    ChartsViewController *chartsController = [[ChartsViewController alloc]initWithNibName:@"ChartsViewController" bundle:nil];
    chartsController.title = @"CHARTS";
    LikesViewController *likesController = [[LikesViewController alloc]initWithNibName:@"LikesViewController" bundle:nil];
    likesController.title = @"LIKES";
    NewTracksViewController *newTracksController = [[NewTracksViewController alloc]initWithNibName:@"NewTracksViewController" bundle:nil];
    newTracksController.title = @"NEW SONGS";
    
    NSArray *controllerArray = @[forYouController, chartsController, likesController, newTracksController];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont systemFontOfSize:12 weight:0.3],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(75.0),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor whiteColor]
                                 };
    _pageMenu.delegate = self;
    _pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 0.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end