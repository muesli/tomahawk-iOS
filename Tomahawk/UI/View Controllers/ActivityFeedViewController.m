//
//  ActivityFeedViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ActivityFeedViewController.h"
#import "CollectionViewCell.h"
#import <JavaScriptCore/JavaScriptCore.h>


@interface ActivityFeedViewController ()

@end

@implementation ActivityFeedViewController

-(void)viewDidLayoutSubviews{
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    JSContext *context = [[JSContext alloc]init];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Tomahawk" ofType:@"js"];
    NSString* filePath1 = [[NSBundle mainBundle] pathForResource:@"Soundcloud" ofType:@"js"];
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"rsvp-latest.min" ofType:@"js"];
    NSString *Tomahawk = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *resolver = [NSString stringWithContentsOfFile:filePath1 encoding:NSUTF8StringEncoding error:nil];
    NSString *rsvp = [NSString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:Tomahawk];
    [context evaluateScript:resolver];
    [context evaluateScript:rsvp];
    JSValue *function = context[@"Tomahawk.timestamp"];
    JSValue *result = [function callWithArguments:nil];
    NSLog(@"ApiVersion is: %d", [result toInt32] );
    

    [self.recentSongs registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.recentPlaylists registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new] forBarPosition:UIBarPositionAny barMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    if ([collectionView isEqual:self.recentSongs]) {
        CollectionViewCell *recommendedSongs = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedSongs.image.image = [UIImage imageNamed:@"PlaceholderSongs"];
        return recommendedSongs;
    }else{
        CollectionViewCell *recommendedPlaylists = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
        recommendedPlaylists.image.image = [UIImage imageNamed:@"PlaceholderPlaylists"];
        return recommendedPlaylists;
    }
}


@end
