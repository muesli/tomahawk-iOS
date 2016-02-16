//
//  BugReportViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "BugReportViewController.h"
#import "TEngine.h"

@implementation BugReportViewController

-(IBAction)sendReport:(UIBarButtonItem *)report{
    if ([self.titleField.text isEqualToString:@""]) {
        UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:@"Bug Report must have a title" preferredStyle:UIAlertControllerStyleAlert];
        [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:error animated:YES completion:nil];
    }else{
        MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
        [self.view addSubview:HUD];
        HUD.mode = MBProgressHUDModeIndeterminate;
        HUD.delegate = self;
        [HUD show:YES];
        [TEngine reportBugWithTitle:self.titleField.text description:self.descriptionField.text username:self.usernameField.text password:self.passwordField.text completion:^(id response) {
            dispatch_sync(dispatch_get_main_queue(), ^{
                [HUD hide:YES];
                if ([response isKindOfClass:[NSError class]]){
                    UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[response userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
                    [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
                    [self presentViewController:error animated:YES completion:nil];
                }else{
                    NSLog(@"Sucess");
                    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
                    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
                    [self.view addSubview:HUD];
                    HUD.mode = MBProgressHUDModeCustomView;
                    HUD.labelText = @"Success!";
                    [HUD show:YES];
                    [HUD hide:YES afterDelay:1];
                    NSArray *array = @[self.usernameField, self.passwordField, self.descriptionField, self.titleField];
                    for (UITextField *string in array) {
                        string.text = @"";
                    }
                }
            });
            
        }];
    }
    
}

-(void)reportBugWithCode:(NSString *)code {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    [HUD show:YES];
}


-(void)viewDidLoad{
    [super viewDidLoad];
    
}

@end
