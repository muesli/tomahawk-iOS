//
//  InboxTableViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 08/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"
#import "MyAdditions.h"

@interface InboxTableViewController : UITableViewController <SWTableViewCellDelegate>

- (void)getMessages:(void (^)(NSUInteger))completion;

@end
