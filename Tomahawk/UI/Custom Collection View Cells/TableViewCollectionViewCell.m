//
//  TableViewCollectionViewCell.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "TableViewCollectionViewCell.h"

@implementation TableViewCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithRed:200.0/255.0 green:199.0/255.0 blue:204.0/255.0 alpha:1];
    }
    
    return self;
}

- (void)applyLayoutAttributes:(UICollectionViewLayoutAttributes *)layoutAttributes {
    self.frame = layoutAttributes.frame;
}




@end
