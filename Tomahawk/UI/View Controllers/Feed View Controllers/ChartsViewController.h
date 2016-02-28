//
//  ChartsViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChartsHeader.h"

@interface ChartsViewController : UICollectionViewController <UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, ChartsHeaderDelegate, UIPopoverPresentationControllerDelegate, UITableViewDelegate>

@property(nonatomic,retain) UIPopoverPresentationController *resolver;

@end
