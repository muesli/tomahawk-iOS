//
//  ConnectCollectionViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ConnectCollectionViewController.h"

@interface ConnectCollectionViewController (){
    NSArray *names;
    NSMutableArray *myArray;
    UILabel *label;
}

@end

@implementation ConnectCollectionViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    [self.collectionView registerClass:[ConnectCell class] forCellWithReuseIdentifier:@"connectCell"];
    names = @[@"Last.fm", @"Spotify", @"Google Play Music", @"Apple Music", @"SoundCloud", @"Tidal", @"Deezer", @"Grooveshark", @"Official.fm"];
    myArray = [NSMutableArray new];
    
    NSArray *colors = @[[UIColor colorWithRed:204.0/255.0 green:61.0/255.0 blue:67.0/255.0 alpha:1],
                        [UIColor colorWithRed:30.0/255.0 green:215.0/255.0 blue:96.0/255.0 alpha:1],
                        [UIColor colorWithRed:236.0/255.0 green:138.0/255.0 blue:61.0/255.0 alpha:1],
                        [UIColor colorWithRed:108.0/255.0 green:97.0/255.0 blue:299.0/255.0 alpha:1],
                        [UIColor colorWithRed:236.0/255.0 green:100.0/255.0 blue:51.0/255.0 alpha:1],
                        [UIColor colorWithRed:95.0/255.0 green:248.0/255.0 blue:251.0/255.0 alpha:1],
                        [UIColor colorWithRed:177.0/255.0 green:209.0/255.0 blue:36.0/255.0 alpha:1],
                        [UIColor colorWithRed:226.0/255.0 green:115.0/255.0 blue:36.0/255.0 alpha:1],
                        [UIColor colorWithRed:209.0/255.0 green:55.0/255.0 blue:36.0/255.0 alpha:1]];

    
    for (int i = 0; i<names.count; i++) {
        NSString *name = [names objectAtIndex:i];
        ConnectCell *connectioncell = [ConnectCell new];
        connectioncell.title = [[UILabel alloc]init];
        connectioncell.title.text = name;
        connectioncell.title.textColor = [UIColor whiteColor];
        connectioncell.title.font = [UIFont systemFontOfSize:10];
        connectioncell.image = [[UIImageView alloc]init];
        connectioncell.image.image = [UIImage imageNamed:name];
        connectioncell.color = colors[i];
        [myArray addObject:connectioncell];
        [self.view addSubview:connectioncell.title];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return names.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConnectCell *connectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"connectCell" forIndexPath:indexPath];
    label = label ?: ({
        UILabel *mylabel = [UILabel new];
        [mylabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [connectCell addSubview:mylabel];
        [connectCell addConstraint:[NSLayoutConstraint constraintWithItem:mylabel attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:connectCell attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
        [connectCell addConstraint:[NSLayoutConstraint constraintWithItem:mylabel attribute:NSLayoutAttributeTop relatedBy:NSLayoutRelationEqual toItem:connectCell attribute:NSLayoutAttributeBottom multiplier:1 constant:20]];
        mylabel.textColor = [UIColor whiteColor];
        mylabel.font = [UIFont systemFontOfSize:12];
        mylabel;
    });
#warning doesnt work and scrolling will put multiple images on one cell
    
    for (NSUInteger i = indexPath.row; i<=indexPath.row; i++) {
        connectCell.image = [[UIImageView alloc]initWithImage:[[[myArray objectAtIndex:i]valueForKey:@"image"]valueForKey:@"image"]];
        connectCell.color = [[myArray objectAtIndex:i]valueForKey:@"color"];
        label.text = [names objectAtIndex:i];
    }
    connectCell.backgroundColor = [UIColor clearColor];
    
    return connectCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ResolverDetailController *connect = [[ResolverDetailController alloc]initWithNibName:@"ResolverDetailController" bundle:nil];
    connect.color = [[myArray objectAtIndex:indexPath.row]valueForKey:@"color"];
    connect.resolverTitle = [names objectAtIndex:indexPath.row];
    connect.tag = indexPath.row;
    connect.resolverImage = [[[myArray objectAtIndex:indexPath.row]valueForKey:@"image"]valueForKey:@"image"];
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
