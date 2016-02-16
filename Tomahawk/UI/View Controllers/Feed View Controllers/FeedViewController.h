//
//  FeedViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Tomahawk-Swift.h"
#import "CAPSPageMenu.h"
#import <WebKit/WebKit.h>

@interface FeedViewController : UIViewController <CAPSPageMenuDelegate, WKScriptMessageHandler, WKNavigationDelegate>

@property (strong, nonatomic) ADVSegmentedControl *segmentedControl;
@property (nonatomic) CAPSPageMenu *pageMenu;

@end

