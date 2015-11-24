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
    if (self.highlighted) {
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, [redComponent floatValue], [greenComponent floatValue], [blueComponent floatValue], 1);
        CGContextFillEllipseInRect(context, self.bounds);
    }
    [super drawRect:rect];
    self.layer.borderColor = _color.CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 60;
    _image.frame = CGRectMake(CGRectGetMidX(self.bounds)-(35/2), CGRectGetMidY(self.bounds)-(35/2), 35, 35);
    [self addSubview:_image];
}


-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
