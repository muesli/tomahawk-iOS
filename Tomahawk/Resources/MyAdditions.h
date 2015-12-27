//
//  UIImage+ImageWithColor.h
//  Tomahawk
//
//  Created by Mark Bourke on 20/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MyAdditions)
+(UIImage *)image:(UIImage *)image withColor:(UIColor *)color;

@end

@interface NSString (MyAdditions)

- (NSString *)md5;

@end

@interface NSData (MyAdditions)

- (NSString*)md5;

@end
