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
#import "CustomUIButton.h"

enum resolvers {
    RLastFM = 0,
    RSpotify = 1,
    RGPlayMusic = 2,
    RRdio = 3,
    RSoundcloud = 4
};
@interface ResolverDetailController : UIViewController <UITextFieldDelegate, MBProgressHUDDelegate>

@property (nonatomic) NSInteger tag;
@property (strong, nonatomic) IBOutlet UITextField *passwordField;
@property (strong, nonatomic) IBOutlet UITextField *usernameField;
@property (weak, nonatomic) UIColor *color;
@property (weak, nonatomic) UIImage *resolverImage;
@property (weak, nonatomic) NSString *resolverTitle;
@property (strong, nonatomic) IBOutlet CustomUIButton *signIn;
@property (weak, nonatomic) IBOutlet UILabel *premium;

-(void)redirectURIWithURL:(NSURL *)url;

@end
