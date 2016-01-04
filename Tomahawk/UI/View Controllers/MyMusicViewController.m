//
//  MyMusicViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "MyMusicViewController.h"

@interface MyMusicViewController ()

@property (nonatomic) CAPSPageMenu *pageMenu;

@end


@implementation MyMusicViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                                                 forBarPosition:UIBarPositionAny
                                                     barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1];
    self.navigationController.navigationBar.titleTextAttributes = @{NSForegroundColorAttributeName: [UIColor orangeColor]};
    PlaylistsTableViewController *playlistsController = [[PlaylistsTableViewController alloc]initWithNibName:@"PlaylistsTableViewController" bundle:nil];
    playlistsController.title = @"PLAYLISTS";
    SongsTableViewController *songsController = [[SongsTableViewController alloc]initWithNibName:@"SongsTableViewController" bundle:nil];
    songsController.title = @"SONGS";
    
    NSArray *controllerArray = @[playlistsController, songsController];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)],
                                 CAPSPageMenuOptionBottomMenuHairlineColor: [UIColor clearColor],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont systemFontOfSize:12 weight:0.3],
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @((self.view.frame.size.width/2)-30),
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