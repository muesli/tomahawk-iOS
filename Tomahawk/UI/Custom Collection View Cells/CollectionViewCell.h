//
//  CollectionViewCell.h
//  Tomahawk
//
//  Created by Mark Bourke on 02/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionViewCell : UICollectionViewCell <UICollectionViewDelegateFlowLayout>

@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UILabel *artist;

@end
