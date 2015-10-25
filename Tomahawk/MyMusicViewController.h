//
//  MyMusicViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HMSegmentedControl.h"
#import "InsidePlaylistsViewController.h"

@class InsidePlaylistsViewController;

@interface MyMusicViewController : UIViewController <UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;

@end
