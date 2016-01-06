//
//  CustomTableViewCell.m
//  Tomahawk
//
//  Created by Mark Bourke on 06/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

- (void)awakeFromNib {
    [self.myImageView.layer setMinificationFilter:kCAFilterTrilinear];
}


@end
