//
//  ConnectAlertController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ResolverDetailController.h"

#warning setting Destructive state not fully working

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

-(void)redirectURIWithURL:(NSURL *)url {
    NSString *urlHost = [url host];
    if ([urlHost isEqualToString:@"Spotify"]) {
        NSDictionary *query = [[url query] URLStringValues];
        NSString *response;
        @try {
            response = [query valueForKey:@"code"];
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
            response = [query valueForKey:@"error"];
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
            response = [query valueForKey:@"code"];
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
            response = [query valueForKey:@"error"];
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
            response = [query valueForKey:@"code"];
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
            response = [query valueForKey:@"error"];
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
    [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(self.usernameField.frame.origin.x, 100) toPointB:CGPointMake(260, 100) withColor:[UIColor whiteColor]];
    [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(self.passwordField.frame.origin.x, 150) toPointB:CGPointMake(260,150) withColor:[UIColor whiteColor]];
    
    myArray = @[self.usernameField, self.passwordField];
    for (UITextField *textField in myArray) {
        textField.tintColor = self.color;
        [textField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]
                          forKeyPath:@"_placeholderLabel.textColor"];
    }
}

- (void)makeLineLayer:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB withColor:(UIColor *)color {
    CAShapeLayer *line = [CAShapeLayer layer];
    UIBezierPath *linePath=[UIBezierPath bezierPath];
    [linePath moveToPoint: pointA];
    [linePath addLineToPoint:pointB];
    line.path=linePath.CGPath;
    line.fillColor = nil;
    if (color == [UIColor whiteColor]) {
        line.opacity = 0.3;
    }else{
        line.opacity = 1;
    }
    line.strokeColor = color.CGColor;
    [layer addSublayer:line];
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    if (textField == self.usernameField) {
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(self.usernameField.frame.origin.x, 100) toPointB:CGPointMake(260, 100) withColor:self.color];
    }else{
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(self.passwordField.frame.origin.x, 150) toPointB:CGPointMake(260, 150) withColor:self.color];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    for (CALayer *layer in [self.view.layer.sublayers copy]) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(self.usernameField.frame.origin.x, 100) toPointB:CGPointMake(260, 100) withColor:[UIColor whiteColor]];
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(self.passwordField.frame.origin.x, 150) toPointB:CGPointMake(260, 150) withColor:[UIColor whiteColor]];
}



@end
