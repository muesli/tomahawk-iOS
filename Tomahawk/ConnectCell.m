//
//  ConnectCell.m
//  Tomahawk
//
//  Created by Mark Bourke on 23/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//


#import "ConnectCell.h"

@implementation ConnectCell


-(void)drawRect:(CGRect)rect{
    NSNumber *redComponent = [_color valueForKey:@"redComponent"];
    NSNumber *greenComponent = [_color valueForKey:@"greenComponent"];
    NSNumber *blueComponent = [_color valueForKey:@"blueComponent"];
    self.image.image = [UIImage image:self.image.image withColor:self.color];
    if (self.highlighted) {
        self.image.image = [UIImage image:self.image.image withColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, [redComponent floatValue], [greenComponent floatValue], [blueComponent floatValue], 1);
        CGContextFillEllipseInRect(context, self.bounds);
    }
    [super drawRect:rect];
    self.layer.borderColor = _color.CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 60;
    _image.frame = CGRectMake(CGRectGetMidX(self.bounds)-(38/2), CGRectGetMidY(self.bounds)-(53/2), 40, 55);
    [self.image.layer setMinificationFilter:kCAFilterTrilinear];
    [self addSubview:_image];
}


-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
