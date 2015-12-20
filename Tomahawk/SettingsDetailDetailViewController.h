//
//  SettingsDetailViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 23/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "ConnectCell.h"
#import <SafariServices/SafariServices.h>
#import "ConnectAlertController.h"


@interface SettingsDetailDetailViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, SFSafariViewControllerDelegate>

@property (nonatomic) Settings *currentSetting;

@end
