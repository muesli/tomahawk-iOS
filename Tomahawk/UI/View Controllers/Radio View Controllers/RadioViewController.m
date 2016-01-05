//
//  RadioViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 11/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "RadioViewController.h"


@interface RadioViewController ()

@property (nonatomic) CAPSPageMenu *pageMenu;

@end

@implementation RadioViewController

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
    ForYouViewController *forYouController = [[ForYouViewController alloc]initWithNibName:@"ForYouViewController" bundle:nil];
    forYouController.title = @"FOR YOU";
    GenresCollectionViewController *genresController = [[GenresCollectionViewController alloc]initWithNibName:@"GenresCollectionViewController" bundle:nil];
    genresController.title = @"GENRES";
    MoodsCollectionViewController *moodsController = [[MoodsCollectionViewController alloc]initWithNibName:@"MoodsCollectionViewController" bundle:nil];
    moodsController.title = @"MOODS";
    StationsViewController *stationsController = [[StationsViewController alloc]initWithNibName:@"StationsViewController" bundle:nil];
    stationsController.title = @"STATIONS";
    
    NSArray *controllerArray = @[forYouController, genresController, moodsController, stationsController];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont systemFontOfSize:12 weight:0.3],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(70.0),
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