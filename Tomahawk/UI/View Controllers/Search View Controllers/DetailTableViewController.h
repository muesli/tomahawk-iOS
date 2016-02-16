//
//  DetailTableViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSString *query;


@end
