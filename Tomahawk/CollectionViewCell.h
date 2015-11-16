//
//  CollectionViewCell.h
//  Tomahawk
//
//  Created by Mark Bourke on 02/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) UIImageView *image;
@property (strong, nonatomic) UILabel *title;
@property (strong, nonatomic) UILabel *artist;
@property (strong, nonatomic) UIImageView *detailImage;
@property (strong, nonatomic) UILabel *detailText;
@property (assign, nonatomic, getter=isBig) BOOL big;

@end
