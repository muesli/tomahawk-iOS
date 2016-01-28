//
//  CustomUIButton.m
//  Tomahawk
//
//  Created by Mark Bourke on 09/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "CustomUIButton.h"

@implementation CustomUIButton

- (void)layoutSubviews {
    [super layoutSubviews];
    NSString *titleText = (self.isDestructive ? @"Sign Out" : @"Sign In");
    [self setTitle:titleText forState:UIControlStateNormal];
    self.layer.borderWidth = self.borderWidth;
    self.layer.borderColor = [[self titleColorForState:UIControlStateNormal] CGColor];
    self.layer.cornerRadius = self.cornerRadius;
    [self updateDisplayWithTint:NO];
}

- (void)setHighlighted:(BOOL)highlighted {
    [self updateDisplayWithTint:highlighted];
}

- (void)setSelected:(BOOL)selected {
    [self updateDisplayWithTint:selected];
}

- (void)setEnabled:(BOOL)enabled {
    [super setEnabled:enabled];
    [self updateDisplayWithTint:NO];
}

- (void)updateDisplayWithTint:(BOOL)isTint {
    UIColor *textColor = [self titleColorForState:self.state];
    self.titleLabel.textColor = (isTint ? [UIColor whiteColor] : textColor);
    self.backgroundColor = (isTint ? textColor : [UIColor clearColor]);
    if (self.destructive) {
        [self setTitleColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] forState:UIControlStateNormal];
        self.layer.borderColor = [self titleColorForState:UIControlStateNormal].CGColor;
    }
}

@end
