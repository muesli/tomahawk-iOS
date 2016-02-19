//
//  UIKit+Tomahawk.h
//  Tomahawk
//
//  Created by Mark Bourke on 20/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (Tomahawk)
+ (UIImage *)image:(UIImage *)image withColor:(UIColor *)color;

- (UIImage *)crop:(CGRect)rect;

@end


@interface NSString (Tomahawk)

- (NSString *)md5;
- (NSDictionary *) URLStringValues;

@end

@interface NSData (Tomahawk)

- (NSString*)md5;
- (id)serialize;

@end

@interface NSDictionary (Tomahawk)

- (NSString *)stringify;

@end

@interface NSError (Tomahawk)

- (UIAlertController *)createAlertFromError;

@end

@interface NSObject (Tomahawk)

- (void)performBlock:(void (^)())block afterDelay:(NSTimeInterval)delay;

@end


