//
//  PlaylistsDetailViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 28/02/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlaylistDetailHeader.h"

@interface PlaylistsDetailViewController : UICollectionViewController <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (strong, nonatomic, setter=response:) id response;

@end
