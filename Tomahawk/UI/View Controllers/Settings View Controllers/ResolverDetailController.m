//
//  ConnectAlertController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ResolverDetailController.h"
#import "TEngine.h"

@implementation ResolverDetailController {
    NSArray *myArray;
}
- (IBAction)buttonSelected:(CustomUIButton *)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    [HUD show:YES];
    if (sender.tag == RSpotify) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://accounts.spotify.com/authorize/?client_id=986b50983f474593a93132fa57837db7&response_type=code&redirect_uri=Tomahawk%3A%2F%2FSpotify&scope=user-library-read"]];
        [HUD hide:YES];
    }else if (sender.tag == RDeezer) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://connect.deezer.com/oauth/auth.php?app_id=170391&redirect_uri=Tomahawk://Deezer&perms=listening_history,manage_community,basic_acess,email"]];
        [HUD hide:YES];
    }else if (sender.tag == RSoundcloud) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"https://soundcloud.com/connect?client_id=3e69fb6130301f668be328e2f8fad38b&redirect_uri=Tomahawk://Soundcloud&response_type=code"]];
        [HUD hide:YES];
    }else if (sender.tag == RLastFM){
    [TEngine authorizeLastFMWithUsername:self.usernameField.text password:self.passwordField.text completion:^(id response){
        if ([response isKindOfClass:[NSString class]]) {
            [HUD hide:YES];
        }else if ([response isKindOfClass:[NSError class]]){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[response userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:error animated:YES completion:nil];
            [HUD hide:YES];
            error.view.tintColor = self.color;
        }
    }];
    }
}

- (void)redirectURIWithURL:(NSURL *)url {
    NSString *urlHost = [url host];
    if ([urlHost isEqualToString:@"Spotify"]) {
        NSDictionary *query = [[url query] URLStringValues];
        NSString *response;
        @try {
            response = [query objectForKey:@"code"];
            [TEngine authorizeSpotifyWithCode:response completion:^(id response) {
                if ([response isKindOfClass:[NSError class]]) {
                    UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[response userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:error animated:YES completion:nil];
                    error.view.tintColor = self.color;
                }
            }];
        }
        @catch (NSException *exception) {
            //Error
            response = [query objectForKey:@"error"];
            NSLog(@"Request error:%@",response);
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"User Cancelled Request" preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:error animated:YES completion:nil];
            
        }
        @finally {
            //Send Response Back
        }
    }else if ([urlHost isEqualToString:@"Deezer"]) {
        NSDictionary *query = [[url query] URLStringValues];
        NSString *response;
        @try {
            response = [query objectForKey:@"code"];
            [TEngine authorizeDeezerWithCode:response completion:^(id response) {
                if ([response isKindOfClass:[NSError class]]) {
                    UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[response userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:error animated:YES completion:nil];
                    error.view.tintColor = self.color;
                }
            }];
        }
        @catch (NSException *exception) {
            //Error
            response = [query objectForKey:@"error"];
            NSLog(@"Request error:%@",response);
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"User Cancelled Request" preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self.navigationController presentViewController:error animated:YES completion:nil];
            
        }
        @finally {
            //Send Response Back
        }
 
    }else if ([urlHost isEqualToString:@"Soundcloud"]) {
        NSDictionary *query = [[url query] URLStringValues];
        NSString *response;
        @try {
            response = [query objectForKey:@"code"];
            [TEngine authorizeSoundcloudWithCode:response completion:^(id response) {
                if ([response isKindOfClass:[NSError class]]) {
                    UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[response userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self.view.window.rootViewController presentViewController:error animated:YES completion:nil];
                    error.view.tintColor = self.color;
                }
            }];
        }
        @catch (NSException *exception) {
            //Error
            response = [query objectForKey:@"error"];
            NSLog(@"Request error:%@",response);
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"User Cancelled Request" preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self.navigationController presentViewController:error animated:YES completion:nil];
            
        }
        @finally {
            //Send Response Back
        }
        
    }

    
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = self.color;
    self.navigationItem.title = self.resolverTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.signIn.tintColor = self.color;
    if ([self.resolverTitle isEqualToString:@"Spotify"]||[self.resolverTitle isEqualToString:@"Google Play Music"]) {
        self.premium.hidden = NO;
    }else {
        self.premium.hidden = YES;
    }
    self.signIn.tag = self.tag;
    [self makeBorderWithTextField:self.usernameField color:[UIColor darkGrayColor]];
    [self makeBorderWithTextField:self.passwordField color:[UIColor darkGrayColor]];
    
    myArray = @[self.usernameField, self.passwordField];
    for (UITextField *textField in myArray) {
        textField.tintColor = self.color;
    }
    self.signIn.cornerRadius = self.signIn.frame.size.height * 0.3;
}

- (void)makeBorderWithTextField:(UITextField *)textField color:(UIColor *)color {
    CALayer *bottomBorder = [CALayer layer];
    bottomBorder.name = @"Bottom Border";
    bottomBorder.frame = CGRectMake(0.0f, textField.frame.size.height - 1, textField.frame.size.width, 2.0f);
    bottomBorder.backgroundColor = color.CGColor;
    bottomBorder.opacity = color == [UIColor darkGrayColor] ? 0.3: 1.0;
    [textField.layer addSublayer:bottomBorder];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    for (CALayer *layer in [textField.layer.sublayers copy]) {
        if ([layer.name isEqualToString:@"Bottom Border"]) {
            [layer removeFromSuperlayer];
        }
    }
    [self makeBorderWithTextField:textField color:self.color];
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    for (CALayer *layer in [textField.layer.sublayers copy]) {
        if ([layer.name isEqualToString:@"Bottom Border"]) {
            [layer removeFromSuperlayer];
        }
    }
   [self makeBorderWithTextField:textField color:[UIColor darkGrayColor]];
}



@end
