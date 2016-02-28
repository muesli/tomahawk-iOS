//
//  ConnectCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ConnectCollectionViewController.h"
#import "ConnectCollectionViewCell.h"
#import "ResolverDetailController.h"

@interface ConnectCollectionViewController (){
    NSArray *names, *colors;
    UILabel *label;
}

@end

@implementation ConnectCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[ConnectCollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    names = @[@"Last.fm", @"Spotify", @"Google Play Music", @"Apple Music", @"SoundCloud", @"Official.fm", @"Deezer", @"Tidal", @"YouTube", @"Amazon Prime Music", @"Rhapsody"];
    
    colors = @[[UIColor colorWithRed:204.0/255.0 green:61.0/255.0 blue:67.0/255.0 alpha:1],
                        [UIColor colorWithRed:30.0/255.0 green:215.0/255.0 blue:96.0/255.0 alpha:1],
                        [UIColor colorWithRed:236.0/255.0 green:138.0/255.0 blue:61.0/255.0 alpha:1],
                        [UIColor colorWithRed:108.0/255.0 green:97.0/255.0 blue:299.0/255.0 alpha:1],
                        [UIColor colorWithRed:236.0/255.0 green:100.0/255.0 blue:51.0/255.0 alpha:1],
                        [UIColor colorWithRed:209.0/255.0 green:55.0/255.0 blue:36.0/255.0 alpha:1],
                        [UIColor colorWithRed:177.0/255.0 green:209.0/255.0 blue:36.0/255.0 alpha:1],
                        [UIColor colorWithRed:95.0/255.0 green:248.0/255.0 blue:251.0/255.0 alpha:1],
                        [UIColor colorWithRed:192.0/255.0 green:50.0/255.0 blue:42.0/255.0 alpha:1],
                        [UIColor colorWithRed:234.0/255.0 green:98.0/255.0 blue:37.0/255.0 alpha:1],
                        [UIColor colorWithRed:9.0/255.0 green:130.0/255.0 blue:169.0/255.0 alpha:1]];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return names.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConnectCollectionViewCell *connectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    connectCell.title = names[indexPath.row];
    connectCell.color = colors[indexPath.row];
    connectCell.backgroundColor = [UIColor clearColor];
    return connectCell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ResolverDetailController *connect = [[ResolverDetailController alloc]initWithNibName:@"ResolverDetailController" bundle:nil];
    connect.color = colors[indexPath.row];
    connect.resolverTitle = [names objectAtIndex:indexPath.row];
    connect.tag = indexPath.row;
    connect.resolverImage = [UIImage imageNamed:names[indexPath.row]];
    UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:connect];
    connect.preferredContentSize = CGSizeMake(self.view.frame.size.width * 0.8,self.view.frame.size.width * 0.6);
    destNav.modalPresentationStyle = UIModalPresentationPopover;
    self.resolver = destNav.popoverPresentationController;
    self.resolver.delegate = self;
    self.resolver.sourceView = self.view;
    CGRect rect = self.view.frame;
    rect.origin.y = 10;
    self.resolver.sourceRect = rect;
    [self.resolver setPermittedArrowDirections:0];
    [self presentViewController:destNav animated:YES completion:nil];
}

-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(self.view.frame.size.width *0.35, self.view.frame.size.width *0.35);
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}
@end
