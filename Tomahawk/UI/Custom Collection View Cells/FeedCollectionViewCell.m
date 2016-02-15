//
//  FeedCollectionViewCell.m
//  Tomahawk
//
//  Created by Mark Bourke on 13/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "FeedCollectionViewCell.h"

@implementation FeedCollectionViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void) drawRect:(CGRect)rect {
    self.personAvatar.layer.cornerRadius = 71;
    self.personAvatar.clipsToBounds = YES;
}

@end
