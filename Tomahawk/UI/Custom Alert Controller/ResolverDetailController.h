//
//  ResolverDetailController.h
//  Tomahawk
//
//  Created by Mark Bourke on 19/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MyAdditions.h"
#import "TEngine.h"
#import "MBProgressHUD.h"

@interface ResolverDetailController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate>

@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) UIColor *color;
@property (weak, nonatomic) UIImage *resolverImage;
@property (weak, nonatomic) NSString *resolverTitle;
@property (weak, nonatomic) IBOutlet UIButton *signIn;

@end
