//
//  ArtistsHeader.h
//  Tomahawk
//
//  Created by Mark Bourke on 05/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface ArtistsHeader : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artistImage;

@end
