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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
