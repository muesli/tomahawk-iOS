//
//  CustomTabBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 15/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "CustomTabBar.h"

@implementation CustomTabBar

-(void)awakeFromNib{
    [super awakeFromNib];
    self.backgroundColor = [UIColor clearColor];
    [self setBackgroundImage:[UIImage new]];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:self.bounds];
    [self addSubview:imageView];
}

@end
