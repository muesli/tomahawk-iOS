//
//  CollectionViewCell.m
//  Tomahawk
//
//  Created by Mark Bourke on 02/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "CollectionViewCell.h"

@implementation CollectionViewCell


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    [self addSubview:self.image];
    [self addSubview:self.detailText];
    [self addSubview:self.detailImage];
    [self addSubview:self.artist];
    [self addSubview:self.title];
    self.title.textColor = [UIColor whiteColor];
    if (self.isBig == TRUE) {
        self.image.frame = CGRectMake(0, 0, 160, 160);
        self.title.frame = CGRectMake(13, 156, 50, 40);
        self.title.font = [UIFont systemFontOfSize:14];
        self.artist.frame = CGRectMake(13, 175, 50, 40);
        self.artist.font = [UIFont systemFontOfSize:12];
        self.artist.alpha = 0.5;
        self.artist.textColor = [UIColor whiteColor];
        self.detailText.frame = CGRectMake(120, 175, 50, 40);
        self.detailText.font = [UIFont systemFontOfSize:12];
        self.detailText.alpha = 0.5;
        self.detailText.textColor = [UIColor whiteColor];
        self.detailImage.frame = CGRectMake(105, 190, 11, 9);
    }else{
        self.image.frame = CGRectMake(0, 0, 140, 140);
        self.title.frame = CGRectMake(8, 146, 50, 20);
        self.artist.frame = CGRectMake(8, 167, 50, 20);
        self.artist.font = [UIFont systemFontOfSize:11];
        self.artist.alpha = 0.5;
        self.artist.textColor = [UIColor whiteColor];
        self.title.font = [UIFont systemFontOfSize:12];
        self.detailText.frame = CGRectMake(109, 158, 50, 40);
        self.detailText.font = [UIFont systemFontOfSize:9];
        self.detailText.alpha = 0.5;
        self.detailText.textColor = [UIColor whiteColor];
        self.detailImage.frame = CGRectMake(95, 173, 11, 9);

    }

}

@end
