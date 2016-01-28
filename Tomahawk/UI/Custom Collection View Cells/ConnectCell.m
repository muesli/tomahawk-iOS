//
//  ConnectCell.m
//  Tomahawk
//
//  Created by Mark Bourke on 23/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//


#import "ConnectCell.h"

@implementation ConnectCell {
    UIImageView *imageView;
    UILabel *resolver;
}


-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    UIImage *image = [UIImage imageNamed:self.title];
    imageView = imageView ?: ({
       UIImageView *myView = [[UIImageView alloc]initWithImage:image];
        [self addSubview:myView];
        [myView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:myView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:myView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
        myView;
    });
    resolver = resolver ?: ({
        UILabel *mylabel = [UILabel new];
        [mylabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addSubview:mylabel];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:mylabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [self addConstraint:[NSLayoutConstraint constraintWithItem:mylabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:self attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
        mylabel.textColor = [UIColor whiteColor];
        mylabel.font = [UIFont systemFontOfSize:12];
        mylabel;
    });
    resolver.text = self.title;
    imageView.image = [UIImage image:image withColor:self.color];
    if (self.highlighted) {
        imageView.image = [UIImage image:image withColor:[UIColor whiteColor]];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, [[_color valueForKey:@"redComponent"] floatValue], [[_color valueForKey:@"greenComponent"] floatValue], [[_color valueForKey:@"blueComponent"] floatValue], 1);
        CGContextFillEllipseInRect(context, self.bounds);
    }
    self.layer.borderColor = self.color.CGColor;
    self.layer.borderWidth = 2;
    self.layer.cornerRadius = self.frame.size.width/2;
}

-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

@end
