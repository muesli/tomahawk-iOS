//
//  InfoTableViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SafariServices/SafariServices.h>

@interface InfoTableViewController : UITableViewController <SFSafariViewControllerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *version;

@end
