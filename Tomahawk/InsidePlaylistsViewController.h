//
//  InsidePlaylistsViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 17/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreMedia/CMTime.h>

static BOOL isButtonSelected;

@interface InsidePlaylistsViewController : UIViewController <UITableViewDataSource>

@property(nonatomic, strong) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;

@end
