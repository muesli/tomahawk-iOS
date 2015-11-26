//
//  SettingsDetailViewController
//  Tomahawk
//
//  Created by Mark Bourke on 09/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "SettingsDetailDetailViewController.h"

@interface SettingsDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic) Settings *currentSetting;
@property (strong, nonatomic) IBOutlet UITableView *tableView;

@end