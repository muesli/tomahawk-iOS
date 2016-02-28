//
//  LibraryHeader.h
//  Tomahawk
//
//  Created by Mark Bourke on 17/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChartsHeaderDelegate;

@interface ChartsHeader : UICollectionReusableView <UICollectionViewDataSource, UICollectionViewDelegate>

@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) id <ChartsHeaderDelegate> delegate;


@end

@protocol ChartsHeaderDelegate <NSObject>

@optional

- (void)headerDidScrollWithProgress:(CGFloat)progressiveness;

@end
