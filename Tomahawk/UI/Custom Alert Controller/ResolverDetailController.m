//
//  ConnectAlertController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ResolverDetailController.h"

@implementation ResolverDetailController {
    NSArray *myArray;
}

- (IBAction)buttonSelected:(UIButton *)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.view];
    [self.view addSubview:HUD];
    HUD.mode = MBProgressHUDModeIndeterminate;
    HUD.delegate = self;
    [HUD show:YES];
    [TEngine signIn:self.usernameField.text password:self.passwordField.text completion:^(id response){
        if ([response isKindOfClass:[NSString class]]) {
            [HUD hide:YES];
            //DO stuff with session key
            [self dismissViewControllerAnimated:YES completion:nil];
        }else if ([response isKindOfClass:[NSError class]]){
            UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[response userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
            [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
            [self presentViewController:error animated:YES completion:nil];
            [HUD hide:YES];
            error.view.tintColor = self.color;
        }
    }];
}

-(void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.barTintColor = self.color;
    self.navigationItem.title = self.resolverTitle;
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}];
    self.signIn.tintColor = self.color;
    
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
