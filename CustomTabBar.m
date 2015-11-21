//
//  CustomTabBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "CustomTabBar.h"

@interface CustomTabBar ()

@end

@implementation CustomTabBar

- (void)viewDidLoad {
    [super viewDidLoad];
    UIView *BG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    BG.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:0.7];
    [self.tabBar addSubview:BG];
    FXBlurView *nowPlayingBarBG = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, self.tabBar.frame.size.width, self.tabBar.frame.size.height)];
    nowPlayingBarBG.blurEnabled = TRUE;
    nowPlayingBarBG.dynamic = TRUE;
    nowPlayingBarBG.blurRadius = 40;
    nowPlayingBarBG.tintColor = [UIColor clearColor];
    nowPlayingBarBG.underlyingView = self.view;
    [self.tabBar addSubview: nowPlayingBarBG];
    [self.tabBar sendSubviewToBack:BG];
    [self.tabBar sendSubviewToBack:nowPlayingBarBG];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
