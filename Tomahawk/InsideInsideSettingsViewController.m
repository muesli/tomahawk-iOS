//
//  InsideInsideSettingsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 23/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "InsideInsideSettingsViewController.h"

int i = 0;

@interface InsideInsideSettingsViewController (){
    NSArray *names;
    NSMutableArray *resolvers;
}

@end

@implementation InsideInsideSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _currentSetting.name;
    if ([_currentSetting.name  isEqual: @"Connect"]) {
        UICollectionViewFlowLayout *flowLayout = [[UICollectionViewFlowLayout alloc]init];
        flowLayout.itemSize = CGSizeMake(125, 125);
        [flowLayout setSectionInset:UIEdgeInsetsMake(20, 40, 20, 40)];
        [flowLayout setMinimumInteritemSpacing:10];
        [flowLayout setMinimumLineSpacing:40];
        [flowLayout setScrollDirection:UICollectionViewScrollDirectionVertical];
        UICollectionView *connect = [[UICollectionView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height) collectionViewLayout:flowLayout];
        connect.delaysContentTouches = NO;
        connect.delegate = self;
        connect.dataSource = self;
        [connect registerClass:[ConnectCell class] forCellWithReuseIdentifier:@"connectCell"];
        connect.backgroundColor = [UIColor clearColor];
        connect.backgroundView = [[UIView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:connect];
        names = @[@"Last.fm", @"Spotify", @"Google Play Music", @"Rdio", @"Soundcloud"];
            resolvers = [[NSMutableArray alloc]init];
        NSArray *colors = [[NSArray alloc]initWithObjects:[UIColor colorWithRed:204.0/255.0 green:61.0/255.0 blue:67.0/255.0 alpha:1], [UIColor colorWithRed:30.0/255.0 green:215.0/255.0 blue:96.0/255.0 alpha:1], [UIColor colorWithRed:236.0/255.0 green:138.0/255.0 blue:61.0/255.0 alpha:1], [UIColor colorWithRed:60.0/255.0 green:128.0/255.0 blue:197.0/255.0 alpha:1], [UIColor colorWithRed:236.0/255.0 green:100.0/255.0 blue:51.0/255.0 alpha:1], nil];
        for (NSString *name in names) {
            ConnectCell *connectioncell = [ConnectCell new];
            connectioncell.title = [[UILabel alloc]init];
            connectioncell.title.text = name;
            connectioncell.title.textColor = [UIColor whiteColor];
            connectioncell.title.font = [UIFont systemFontOfSize:10];
            connectioncell.image = [[UIImageView alloc]init];
            connectioncell.image.image = [UIImage imageNamed:name];
            connectioncell.color = colors[i];
            [resolvers addObject:connectioncell];
            [self.view addSubview:connectioncell.title];
            i++;
        }
        i = 0;
    }else if ([_currentSetting.name isEqual:@"Advanced"]){
    }else if ([_currentSetting.name isEqual:@"Info"]){
        UITableView *info = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        info.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
        info.separatorColor = [UIColor colorWithRed:52.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1];
        info.delegate = self;
        info.dataSource = self;
        [info registerClass:[UITableViewCell class] forCellReuseIdentifier:@"infoCell"];
        [self.view addSubview:info];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Collection View

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return names.count;
}
-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    ConnectCell *connectCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"connectCell" forIndexPath:indexPath];
    long long int j = indexPath.row;
    j++;
    for (long long int i = indexPath.row; i<j; i++) {
        connectCell.image = [[UIImageView alloc]initWithImage:[[[resolvers objectAtIndex:i]valueForKey:@"image"]valueForKey:@"image"]];
        connectCell.color = [[resolvers objectAtIndex:i]valueForKey:@"color"];
    }

    connectCell.backgroundColor = [UIColor clearColor];

    return connectCell;
}

#pragma mark - Info Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    infoCell.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:45.0/255.0 alpha:1];
    return infoCell;
}

@end
