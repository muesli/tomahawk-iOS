//
//  CustomTableViewCell.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

IB_DESIGNABLE
@interface CustomTableViewCell : UITableViewCell

@property (nonatomic) IBInspectable UIColor *imageColor;
@property (nonatomic) IBInspectable BOOL customAccessoryView;

@end
