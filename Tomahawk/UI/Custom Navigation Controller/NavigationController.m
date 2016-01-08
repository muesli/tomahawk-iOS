//
//  NowPlayingBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NavigationController.h"


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
        [self performSegueWithIdentifier:@"showNowPlaying" sender:self];
    }
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.searchBar = [[UISearchBar alloc] init];
    self.searchBar.barStyle = UIBarStyleBlack;
    self.searchBar.barTintColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:1.0];
    self.searchBar.placeholder = @"Search for Songs, Albums and Playlists";
    [self.searchBar sizeToFit];
    self.searchBar.delegate = self;
    self.viewControllers[0].navigationItem.titleView = self.searchBar;
    UIBarButtonItem *inboxButton = [[UIBarButtonItem alloc]initWithImage:[UIImage imageNamed:@"Inbox"] style:UIBarButtonItemStylePlain target:self action:@selector(inboxButtonTouched:)];
    self.navigationItem.rightBarButtonItem = inboxButton;
    barHub = [[RKNotificationHub alloc] initWithBarButtonItem: inboxButton];
    [barHub pop];
    [barHub setCircleColor:self.view.window.tintColor labelColor:[UIColor whiteColor]];
    [barHub increment];
}



-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchTableViewController *searchView = [[SearchTableViewController alloc]initWithNibName:@"SearchTableViewController" bundle:nil];
    [self pushViewController:searchView animated:YES];
    return NO;
}

@end
