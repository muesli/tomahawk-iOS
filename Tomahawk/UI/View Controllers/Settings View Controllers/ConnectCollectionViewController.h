//
//  ConnectCollectionViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConnectCell.h"
#import "ResolverDetailController.h"

@interface ConnectCollectionViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UIPopoverPresentationControllerDelegate>

@property(nonatomic,retain) UIPopoverPresentationController *resolver;

@end
