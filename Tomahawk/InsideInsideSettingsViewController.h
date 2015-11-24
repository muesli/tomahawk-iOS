//
//  InsideInsideSettingsViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 23/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Settings.h"
#import "ConnectCell.h"

@interface InsideInsideSettingsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic) Settings *currentSetting;

@end
