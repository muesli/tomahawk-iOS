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
    self.image.image = [self image:self.image.image withColor:self.color];
    if (self.highlighted) {
        self.image.image = [self image:self.image.image withColor:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.6]];
        CGContextRef context = UIGraphicsGetCurrentContext();
        CGContextSetRGBFillColor(context, [redComponent floatValue], [greenComponent floatValue], [blueComponent floatValue], 1);
        CGContextFillEllipseInRect(context, self.bounds);
    }
    [super drawRect:rect];
    self.layer.borderColor = _color.CGColor;
    self.layer.borderWidth = 2.0f;
    self.layer.cornerRadius = 60;
    _image.frame = CGRectMake(CGRectGetMidX(self.bounds)-(38/2), CGRectGetMidY(self.bounds)-(53/2), 40, 55);
    [self addSubview:_image];
}


-(void)setHighlighted:(BOOL)highlighted{
    [super setHighlighted:highlighted];
    [self setNeedsDisplay];
}

-(UIImage *)image:(UIImage *)image withColor:(UIColor *)color{
    
    UIImage *img = image;

    // begin a new image context, to draw our colored image onto
    UIGraphicsBeginImageContext(img.size);

    // get a reference to that context we created
    CGContextRef context = UIGraphicsGetCurrentContext();

    // set the fill color
    [color setFill];
    
    // translate/flip the graphics context (for transforming from CG* coords to UI* coords
    CGContextTranslateCTM(context, 0, img.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);

    // set the blend mode to color burn, and the original image
    CGContextSetBlendMode(context, kCGBlendModeNormal);
    CGRect rect = CGRectMake(0, 0, img.size.width, img.size.height);
    CGContextDrawImage(context, rect, img.CGImage);

    // set a mask that matches the shape of the image, then draw (color burn) a colored rectangle
    CGContextClipToMask(context, rect, img.CGImage);
    CGContextAddRect(context, rect);
    CGContextDrawPath(context,kCGPathFill);

    // generate a new UIImage from the graphics context we drew onto
    UIImage *coloredImg = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();

    //return the color-burned image
    return coloredImg;
}

@end
