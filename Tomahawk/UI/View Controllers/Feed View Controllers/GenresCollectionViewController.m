//
//  GenresCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 25/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "GenresCollectionViewController.h"
#import "THKCollectionViewCell.h"
#import "TEngine.h"
#import "UIImageView+AFNetworking.h"

@implementation GenresCollectionViewController {
    NSArray *titles, *tracklists, *images, *genreID;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerNib:[UINib nibWithNibName:@"THKCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [TEngine getRadioGenresWithCompletionBlock:^(id response) {
        if ([response isKindOfClass:[NSError class]]) {
            UIAlertController *error = [response createAlertFromError];
            [self.view.window.rootViewController presentViewController:error animated:YES completion:nil];
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
    THKCollectionViewCell *genres = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    genres.textLabel.text =  [titles objectAtIndex:indexPath.row];
    genres.detailTextLabel.hidden = YES;
    [genres.imageView setImageWithURL:[NSURL URLWithString:[images objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderGenres"]];
    return genres;
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width *0.43, self.view.frame.size.width *0.55);
}


@end
