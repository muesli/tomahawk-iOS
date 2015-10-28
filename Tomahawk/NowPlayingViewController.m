//
//  NowPlayingViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 26/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NowPlayingViewController.h"

@interface NowPlayingViewController ()

@end

@implementation NowPlayingViewController

-(IBAction)buttonTouched:(id)sender{
    NSLog(@"Cock.jpg");
}


- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray *buttons = [NSArray arrayWithObjects:_expandArrow, _googleCast, _lyrics, _like, _queue, _share, _playPause, _next, _previous, _repeat, _shuffle, nil];
    
    for (UIButton *myButton in buttons) {
        myButton.imageView.image = [myButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [myButton setImage:myButton.imageView.image forState:UIControlStateNormal];
        myButton.tintColor = [UIColor redColor];
        [myButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
    }

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
