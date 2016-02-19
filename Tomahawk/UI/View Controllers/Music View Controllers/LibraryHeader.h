//
//  LibraryHeader.h
//  Tomahawk
//
//  Created by Mark Bourke on 17/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LibraryHeader : UICollectionReusableView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;

@end
