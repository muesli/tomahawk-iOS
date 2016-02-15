//
//  NowPlayingBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NavigationController.h"
#import "SearchTableViewController.h"
#import "RKNotificationHub.h"
#import "InboxTableViewController.h"
#import "NowPlayingViewController.h"


@interface NavigationController (){
    RKNotificationHub *barHub;
}

@end

@implementation NavigationController

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect targetRect = self.toolbar.frame;
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(targetRect, touchLocation)) {
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        NowPlayingViewController *nowPlaying = (NowPlayingViewController *) [storyboard instantiateViewControllerWithIdentifier:@"NowPlayingViewController"];
        
        [self presentViewController:nowPlaying animated:YES completion:nil];
//        UIWebView *cock = [cock stringb ];
        WKWebView *cock = [WKWebView new];
        [cock evaluateJavaScript:@"cock" completionHandler:^(id response, NSError *error) {
            
        }];
    }
}


-(void)viewDidLoad {
    [super viewDidLoad];
    for(UITabBarItem * tabBarItem in self.tabBarController.tabBar.items){
        tabBarItem.title = @"";
        tabBarItem.imageInsets = UIEdgeInsetsMake(6, 0, -6, 0);
    }
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.barTintColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1.0];
    self.searchBar.placeholder = @"Search for Songs, Albums and Playlists";
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    self.viewControllers[0].navigationItem.titleView = self.searchBar;
//    barHub = [[RKNotificationHub alloc] initWithBarButtonItem: self.viewControllers[0].navigationItem.rightBarButtonItem];
//    [barHub bump];
//    [barHub setCircleAtFrame:CGRectMake(25, 0, 15, 15)];
//    [barHub setCircleColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] labelColor:[UIColor whiteColor]];
//    InboxTableViewController *messages = [InboxTableViewController new];
//    [messages getMessages:^(NSUInteger messageCount) {
//        dispatch_sync(dispatch_get_main_queue(), ^{
//            [barHub incrementBy:messageCount];
//        });
//    }];
}



-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchTableViewController *searchView = [[SearchTableViewController alloc]initWithNibName:@"SearchTableViewController" bundle:nil];
    [self pushViewController:searchView animated:YES];
    return NO;
}

@end
