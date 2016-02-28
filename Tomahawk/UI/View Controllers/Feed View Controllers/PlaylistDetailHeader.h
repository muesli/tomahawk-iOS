//
//  PlaylistDetailHeader.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PlaylistDetailHeader : UICollectionReusableView

@property (strong, nonatomic, setter=response:) id response;

@property (weak, nonatomic) IBOutlet UIImageView *imageOne;
@property (weak, nonatomic) IBOutlet UIImageView *imageTwo;
@property (weak, nonatomic) IBOutlet UIImageView *imageThree;
@property (weak, nonatomic) IBOutlet UIImageView *imageFour;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImage;

@end
