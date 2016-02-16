//
//  ArtistDetailCollectionViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 05/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ArtistDetailCollectionViewController : UICollectionViewController

-(IBAction)back:(UIButton *)sender;
@property (weak, nonatomic) NSString *artistName;
@property (weak, nonatomic) UIImage *artistImage;

@end
