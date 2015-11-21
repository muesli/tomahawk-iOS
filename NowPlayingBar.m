//
//  NowPlayingBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NowPlayingBar.h"

@interface NowPlayingBar ()

@end

@implementation NowPlayingBar

- (void)viewDidLoad {
    [super viewDidLoad];
        UIView *BG = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
        BG.backgroundColor = [UIColor colorWithRed:49.0/255.0 green:49.0/255.0 blue:61.0/255.0 alpha:0.7];
        [self.toolbar addSubview:BG];
        FXBlurView *nowPlayingBarBG = [[FXBlurView alloc]initWithFrame:CGRectMake(0, 0, self.toolbar.frame.size.width, self.toolbar.frame.size.height)];
        nowPlayingBarBG.blurEnabled = TRUE;
        nowPlayingBarBG.dynamic = TRUE;
        nowPlayingBarBG.blurRadius = 40;
        nowPlayingBarBG.tintColor = [UIColor clearColor];
        nowPlayingBarBG.underlyingView = self.view;
        [self.toolbar addSubview: nowPlayingBarBG];
        [self.toolbar bringSubviewToFront:BG];
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
