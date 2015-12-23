//
//  ConnectAlertController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ConnectAlertController.h"

@implementation ConnectAlertController{
    NSArray *myArray;
    UIButton *signIn;
    UIButton *cancel;
}

- (IBAction)buttonPress:(UIButton *)sender {
    if (sender == cancel) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [cancel.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }else if (sender == signIn){
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [signIn.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }
}
- (IBAction)buttonRelease:(UIButton *)sender {
    if (sender == cancel) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [cancel.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }else if (sender == signIn){
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [signIn.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }
}
- (IBAction)buttonSelected:(UIButton *)sender {
    if (sender == cancel) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        //Sign In
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

-(void)viewDidLoad{
    
    NSLayoutConstraint *height = [NSLayoutConstraint constraintWithItem:self.view
                                                              attribute:NSLayoutAttributeHeight
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:nil
                                                              attribute:NSLayoutAttributeNotAnAttribute
                                                             multiplier:1
                                                               constant:240];
    
    [self.view addConstraint:height];
    
    self.usernameField = [[UITextField alloc]initWithFrame:CGRectMake(17, 72, 200, 30)];
    self.passwordField = [[UITextField alloc]initWithFrame:CGRectMake(17, 130, 200, 30)];
    self.usernameField.placeholder = @"Username";
    self.passwordField.placeholder = @"Password";
    self.passwordField.secureTextEntry = YES;
    
    [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(17, 102) toPointB:CGPointMake(250, 102) withColor:[UIColor whiteColor]];
    [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(17, 160) toPointB:CGPointMake(250, 160)withColor:[UIColor whiteColor]];
    
    myArray = @[self.usernameField, self.passwordField];
    for (UITextField *textField in myArray) {
        textField.textColor = [UIColor whiteColor];
        textField.delegate = self;
        textField.backgroundColor = [UIColor clearColor];
        textField.borderStyle = UITextBorderStyleNone;
        textField.keyboardAppearance = UIKeyboardAppearanceDark;
        textField.tintColor = self.color;
        [textField setValue:[UIColor colorWithRed:1 green:1 blue:1 alpha:0.3]
                          forKeyPath:@"_placeholderLabel.textColor"];
        [self.view addSubview:textField];

    }
    
    
    UIView * firstView = self.view.subviews.firstObject;
    UIView * nextView = firstView.subviews.firstObject;
    nextView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
    
    UIView *headerView = [UIView new];
    [headerView setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addSubview:headerView];
    
    //Height
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                           attribute:NSLayoutAttributeHeight
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:nil
                                                           attribute:NSLayoutAttributeNotAnAttribute
                                                          multiplier:1
                                                            constant:50]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                           attribute:NSLayoutAttributeTop
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeTop
                                                          multiplier:1
                                                            constant:0]];
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                          attribute:NSLayoutAttributeLeft
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeLeft
                                                         multiplier:1
                                                           constant:0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:headerView
                                                          attribute:NSLayoutAttributeRight
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeRight
                                                         multiplier:1
                                                           constant:0]];
    

    
    headerView.backgroundColor = self.color;
    
    UILabel *title = [UILabel new];
    title.textColor = [UIColor whiteColor];
    title.text = self.resolverTitle;
    [title setFrame:CGRectMake(42, 10, 150, 30)];
    [headerView addSubview:title];
    
    UIImageView *serviceImage = [UIImageView new];
    serviceImage.image = [UIImage image:self.resolverImage withColor:[UIColor whiteColor]];
    [serviceImage setFrame:CGRectMake(235, 7, 25, 35)];
    [serviceImage.layer setMinificationFilter:kCAFilterTrilinear];
    [headerView addSubview:serviceImage];
    
    UIButton *connect = [UIButton buttonWithType:UIButtonTypeCustom];
    [connect setImage:[UIImage image:[UIImage imageNamed:@"Connect Resolvers"] withColor:[UIColor whiteColor]] forState:UIControlStateNormal];
    [connect.imageView.layer setMinificationFilter:kCAFilterTrilinear]; //Anti-Aliasing 
    connect.frame = CGRectMake(10, 10, 20, 28); //In ratio 5:7
    [headerView addSubview:connect];
    
    signIn = [[UIButton alloc]initWithFrame:CGRectMake(170, 190, 100, 28)];
    [signIn setTitle:@"Sign In" forState:UIControlStateNormal];
    cancel = [[UIButton alloc]initWithFrame:CGRectMake(0, 190, 100, 28)];
    [cancel setTitle:@"Cancel" forState:UIControlStateNormal];
    
    myArray = @[signIn, cancel];
    for (UIButton *buttons in myArray) {
        [buttons.titleLabel setFont:[UIFont systemFontOfSize:17 weight:0.2]];
        [buttons setTitleColor:self.color forState:UIControlStateNormal];
        [buttons addTarget:self action:@selector(buttonPress:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragEnter];
        [buttons addTarget:self action:@selector(buttonRelease:) forControlEvents:UIControlEventTouchDragExit | UIControlEventTouchUpOutside];
        [buttons addTarget:self action:@selector(buttonSelected:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:buttons];

    }
}

-(void)makeLineLayer:(CALayer *)layer lineFromPointA:(CGPoint)pointA toPointB:(CGPoint)pointB withColor:(UIColor *)color{
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
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(10, 102) toPointB:CGPointMake(250, 102) withColor:self.color];
    }else{
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(10, 160) toPointB:CGPointMake(250, 160)withColor:self.color];
    }
}
-(void)textFieldDidEndEditing:(UITextField *)textField{
    for (CALayer *layer in [self.view.layer.sublayers copy]) {
        if ([layer isKindOfClass:[CAShapeLayer class]]) {
            [layer removeFromSuperlayer];
        }
    }
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(10, 102) toPointB:CGPointMake(250, 102) withColor:[UIColor whiteColor]];
        [self makeLineLayer:self.view.layer lineFromPointA:CGPointMake(10, 160) toPointB:CGPointMake(250, 160)withColor:[UIColor whiteColor]];
}



@end
