//
//  GenresCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "GenresCollectionViewController.h"
#import "CollectionViewCell.h"
#import "TEngine.h"
#import "UIKit+Tomahawk.h"
#import "UIImageView+AFNetworking.h"

@implementation GenresCollectionViewController {
    NSArray *titles, *tracklists, *images, *genreID;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [TEngine getRadioGenresWithCompletionBlock:^(id response) {
        if ([response isKindOfClass:[NSError class]]) {
            UIAlertController *error = [response createAlertFromError];
            [self presentViewController:error animated:YES completion:nil];
        }else {
            titles = [response objectForKey:@"genreTitle"];
            genreID = [response objectForKey:@"genreID"];
            images = [response objectForKey:@"genreImage"];
            [self.collectionView reloadData];
        }
    }];

}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titles.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *genres = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    genres.title.text =  [titles objectAtIndex:indexPath.row];
    genres.artist.hidden = YES;
    [genres.image setImageWithURL:[NSURL URLWithString:[images objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderGenres"]];
    return genres;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width *0.43, self.view.frame.size.width *0.55);
}

@end
