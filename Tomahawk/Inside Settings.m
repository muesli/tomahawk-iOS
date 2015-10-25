//
//  Inside Settings.m
//  Tomahawk
//
//  Created by Mark Bourke on 09/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "Inside Settings.h"

@interface Inside_Settings ()

@end

@implementation Inside_Settings

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _currentSetting.name;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
