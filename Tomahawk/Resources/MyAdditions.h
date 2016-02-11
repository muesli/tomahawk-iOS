//
//  MyAdditions.h
//  Tomahawk
//
//  Created by Mark Bourke on 20/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (MyAdditions)
+(UIImage *)image:(UIImage *)image withColor:(UIColor *)color;

- (UIImage *)crop:(CGRect)rect;

@end

@interface NSString (MyAdditions)

- (NSString *)md5;
- (NSDictionary *) URLStringValues;

@end

@interface NSData (MyAdditions)

- (NSString*)md5;
- (id)serialize;

@end

@interface NSDictionary (MyAdditions)

- (NSString *)stringify;

@end

@interface NSError (MyAdditions)

- (UIAlertController *)createAlertFromError;

@end


