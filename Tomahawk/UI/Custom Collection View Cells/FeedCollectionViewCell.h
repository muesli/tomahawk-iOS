//
//  FeedCollectionViewCell.h
//  Tomahawk
//
//  Created by Mark Bourke on 13/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCollectionViewCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *personAvatar;
@property (weak, nonatomic) IBOutlet UILabel *personName;
@property (weak, nonatomic) IBOutlet UILabel *personCompletedAction;
@property (weak, nonatomic) IBOutlet UILabel *date;
@property (weak, nonatomic) IBOutlet UIImageView *content;
@property (weak, nonatomic) IBOutlet UILabel *contentTitle;
@property (weak, nonatomic) IBOutlet UILabel *contentDetail;

@end
