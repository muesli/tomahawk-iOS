//
//  ChartsViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionViewCell.h"
#import "CustomTableViewCell.h"
#import "TEngine.h"
#import "UIImageView+AFNetworking.h"

@interface ChartsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate, UICollectionViewDataSource, UICollectionViewDelegate>

@property(nonatomic, strong) IBOutlet UICollectionView *chartsByCountry;
@property(nonatomic, strong) IBOutlet UITableView *top;
@property(weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIView *contentView;

@end
