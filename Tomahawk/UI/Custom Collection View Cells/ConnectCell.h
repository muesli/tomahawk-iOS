//
//  ConnectCell.h
//  Tomahawk
//
//  Created by Mark Bourke on 23/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "MyAdditions.h"

@interface ConnectCell : UICollectionViewCell


@property (strong, nonatomic) UIImage *image;
@property (weak, nonatomic) UIColor *color;
@property (weak, nonatomic) NSString *title;



@end
