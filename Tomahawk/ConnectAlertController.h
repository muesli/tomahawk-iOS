//
//  ConnectAlertController.h
//  Tomahawk
//
//  Created by Mark Bourke on 19/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdditions.h"
#import "TEngine.h"

@interface ConnectAlertController : UIAlertController <UITextFieldDelegate>

@property (strong, nonatomic) UITextField *passwordField;
@property (strong, nonatomic) UITextField *usernameField;
@property (weak, nonatomic) UIColor *color;
@property (strong, nonatomic) UIImage *resolverImage;
@property (strong, nonatomic) NSString *resolverTitle;

@end
