//
//  ArtistsHeader.m
//  Tomahawk
//
//  Created by Mark Bourke on 05/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "ArtistsHeader.h"
#import <QuartzCore/QuartzCore.h>
#import "StickyHeaderFlowLayoutAttributes.h"
#import "SLColorArt.h"

@implementation ArtistsHeader

- (void)applyLayoutAttributes:(StickyHeaderFlowLayoutAttributes *)layoutAttributes {
    [UIView beginAnimations:@"" context:nil];
//    self.titleLabel.alpha = layoutAttributes.progressiveness <= 0.1 ?  1 : 0;
    self.navigationBarArtistImage.alpha = layoutAttributes.progressiveness <= 0.1 ?  1 : 0;
    [UIView commitAnimations];
}


- (void)drawRect:(CGRect)rect {
    [super drawRect:rect];
    self.artistImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.artistImage.layer.borderWidth = 2;
    self.artistImage.layer.cornerRadius = 65;
    self.artistImage.clipsToBounds = YES;
    self.navigationBarArtistImage.layer.borderColor = [UIColor whiteColor].CGColor;
    self.navigationBarArtistImage.layer.borderWidth = 1;
    self.navigationBarArtistImage.layer.cornerRadius = 15;
    self.navigationBarArtistImage.clipsToBounds = YES;
    SLColorArt *colorArt = [[SLColorArt alloc]initWithImage:self.backgroundImageView.image];
    self.radio.backgroundColor = colorArt.backgroundColor;
    self.radio.tintColor = colorArt.primaryColor;
    self.radio.layer.cornerRadius = 13;
}

@end
