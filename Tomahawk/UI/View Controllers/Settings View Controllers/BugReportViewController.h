//
//  BugReportViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MBProgressHUD.h"
#import <SafariServices/SafariServices.h>

@interface BugReportViewController : UITableViewController <MBProgressHUDDelegate, SFSafariViewControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *usernameField;
@property (nonatomic, strong) IBOutlet UITextField *passwordField;
@property (nonatomic, strong) IBOutlet UITextField *titleField;
@property (nonatomic, strong) IBOutlet UITextView *descriptionField;
@property (strong, nonatomic) NSString *authCode;

-(void)reportBugWithCode:(NSString *)code;


@end
