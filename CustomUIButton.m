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

- (void)setEmphasized:(BOOL)emphasized {
    _emphasized = emphasized;
    [self updateDisplayWithTint:NO];
}

- (void)updateDisplayWithTint:(BOOL)isTint {
    UIColor *textColor = [self titleColorForState:self.state];
    if (self.isEmphasized) {
        self.titleLabel.textColor = [UIColor whiteColor];
        self.backgroundColor = textColor;
        return;
    }
    self.titleLabel.textColor = (isTint ? [UIColor whiteColor] : textColor);
    self.backgroundColor = (isTint ? textColor : [UIColor clearColor]);
}

@end
