//
//  PlaylistDetailHeader.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "PlaylistDetailHeader.h"
#import "UIImageView+AFNetworking.h"

@implementation PlaylistDetailHeader

- (void)awakeFromNib {
    // Initialization code
}

- (void)response:(id)response {
    if (![response isKindOfClass:[NSError class]]) {
        [self.imageOne setImageWithURL:[NSURL URLWithString:[[response objectForKey:@"songImages"]objectAtIndex:0]]];
        [self.imageTwo setImageWithURL:[NSURL URLWithString:[[response objectForKey:@"songImages"]objectAtIndex:1]]];
        [self.imageThree setImageWithURL:[NSURL URLWithString:[[response objectForKey:@"songImages"]objectAtIndex:2]]];
        [self.imageFour setImageWithURL: [NSURL URLWithString:[[response objectForKey:@"songImages"]objectAtIndex:3]]];
        [self.backgroundImage setImageWithURL:[NSURL URLWithString:[[response objectForKey:@"songImages"]objectAtIndex:0]]];
        
    }
}

@end
