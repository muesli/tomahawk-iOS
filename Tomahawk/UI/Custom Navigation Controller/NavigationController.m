//
//  NowPlayingBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NavigationController.h"


@interface NavigationController ()

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
    self.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    [self.searchBar sizeToFit];
    self.searchBar.tintColor = self.view.window.tintColor;
    [self.searchBar setTintColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)]];
    self.searchBar.delegate = self;
    self.viewControllers[0].navigationItem.titleView = self.searchBar;
}


-(BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    SearchTableViewController *tablview = [[SearchTableViewController alloc]initWithNibName:@"SearchTableViewController" bundle:nil];
    [self pushViewController:tablview animated:YES];
    return NO;
}

@end
