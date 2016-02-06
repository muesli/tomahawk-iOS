//
//  ArtistsHeader.m
//  Tomahawk
//
//  Created by Mark Bourke on 05/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "ArtistsHeader.h"
#import "StickyHeaderFlowLayoutAttributes.h"

@implementation ArtistsHeader

- (void)applyLayoutAttributes:(StickyHeaderFlowLayoutAttributes *)layoutAttributes {
    
    [UIView beginAnimations:@"" context:nil];
    
    self.titleLabel.alpha = layoutAttributes.progressiveness <= 0.58 ?  1 : 0;
    
    [UIView commitAnimations];
}

@end
