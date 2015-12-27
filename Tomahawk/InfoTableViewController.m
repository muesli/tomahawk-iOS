//
//  InfoTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "InfoTableViewController.h"

@interface InfoTableViewController ()

@end

@implementation InfoTableViewController


- (IBAction)twitter:(UIButton *)button {
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/tomahawk"]];
}

- (IBAction)website:(UIButton *)button {
    SFSafariViewController *svc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://tomahawk-player.org"]];
    svc.view.tintColor = self.view.window.tintColor;
    [self presentViewController:svc animated:YES completion:nil];
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
@end
