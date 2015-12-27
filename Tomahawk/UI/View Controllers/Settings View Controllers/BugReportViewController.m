//
//  BugReportViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "BugReportViewController.h"

@implementation BugReportViewController

-(IBAction)sendReport:(UIBarButtonItem *)report{
}

-(void)viewDidLoad{
    [super viewDidLoad];
    [self setTitle:@"Report a Bug"];
    UIBarButtonItem *sendReport = [[UIBarButtonItem alloc]initWithTitle:@"Send" style:UIBarButtonItemStyleDone target:self action:@selector(sendReport:)];
    sendReport.tintColor = [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)];
    self.navigationItem.rightBarButtonItem = sendReport;
    //Change placeholder color
    NSArray *myArray = @[self.titleField, self.usernameField, self.passwordField];
    for (UITextField *fields in myArray) {
        [fields setValue:[UIColor darkGrayColor]forKeyPath:@"_placeholderLabel.textColor"];
    }
    
}

@end
