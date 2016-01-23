//
//  ConnectCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ConnectCollectionViewController.h"

@interface ConnectCollectionViewController (){
    NSArray *names, *colors;
    UILabel *label;
}

@end

@implementation ConnectCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.collectionView registerClass:[ConnectCell class] forCellWithReuseIdentifier:@"cell"];
    names = @[@"Last.fm", @"Spotify", @"Google Play Music", @"Apple Music", @"SoundCloud", @"Tidal", @"Deezer", @"Grooveshark", @"Official.fm"];
    
    colors = @[[UIColor colorWithRed:204.0/255.0 green:61.0/255.0 blue:67.0/255.0 alpha:1],
                        [UIColor colorWithRed:30.0/255.0 green:215.0/255.0 blue:96.0/255.0 alpha:1],
                        [UIColor colorWithRed:236.0/255.0 green:138.0/255.0 blue:61.0/255.0 alpha:1],
                        [UIColor colorWithRed:108.0/255.0 green:97.0/255.0 blue:299.0/255.0 alpha:1],
                        [UIColor colorWithRed:236.0/255.0 green:100.0/255.0 blue:51.0/255.0 alpha:1],
                        [UIColor colorWithRed:95.0/255.0 green:248.0/255.0 blue:251.0/255.0 alpha:1],
                        [UIColor colorWithRed:177.0/255.0 green:209.0/255.0 blue:36.0/255.0 alpha:1],
                        [UIColor colorWithRed:226.0/255.0 green:115.0/255.0 blue:36.0/255.0 alpha:1],
                        [UIColor colorWithRed:209.0/255.0 green:55.0/255.0 blue:36.0/255.0 alpha:1]];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return names.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConnectCell *connectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    connectCell.image = [UIImage imageNamed:names[indexPath.row]];
    connectCell.title = names[indexPath.row];
    connectCell.color = colors[indexPath.row];
    connectCell.backgroundColor = [UIColor clearColor];
    return connectCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ResolverDetailController *connect = [[ResolverDetailController alloc]initWithNibName:@"ResolverDetailController" bundle:nil];
    connect.color = colors[indexPath.row];
    connect.resolverTitle = [names objectAtIndex:indexPath.row];
    connect.tag = indexPath.row;
    connect.resolverImage = [UIImage imageNamed:names[indexPath.row]];
    UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:connect];
    connect.preferredContentSize = CGSizeMake(280,200);
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

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}
@end
