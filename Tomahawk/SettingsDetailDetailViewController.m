//
//  SettingsDetailDetailViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 23/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "SettingsDetailDetailViewController.h"

int i = 0;

@interface SettingsDetailDetailViewController (){
    NSArray *names;
    NSMutableArray *resolvers;
    UILabel *version;
    UIButton *bugReport, *twitter, *website;
}

@end

@implementation SettingsDetailDetailViewController

-(IBAction)button:(UIButton *)button{
    if (button == bugReport) {
        NSLog(@"Bug Report Button");
    }else if (button == twitter){
        NSLog(@"Twitter Button");
    }else{
        NSLog(@"Website Button");
    }
}

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
        info.delaysContentTouches = NO;
        info.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
        info.separatorColor = [UIColor colorWithRed:52.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1];
        info.delegate = self;
        info.dataSource = self;
        [info registerClass:[UITableViewCell class] forCellReuseIdentifier:@"infoCell"];
        [self.view addSubview:info];
    }else if([_currentSetting.name  isEqual: @"Equaliser"]){
        //Equaliser Object
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
    if (section == 1) {
        return 3;
    }
    return 1;
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (section == 0) {
        return @"VERSION";
    }else if (section == 1){
        return @"ABOUT US";
    }else{
        return @"LICENSES";
    }
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"infoCell"];
    infoCell.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:45.0/255.0 alpha:1];
    if (indexPath.section == 0) {
        infoCell.textLabel.text = @"Version";
        infoCell.textLabel.textColor = [UIColor whiteColor];
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        if (!version) {
            version = [[UILabel alloc]init];
            [infoCell addSubview:version];
        }
        version.textColor = [UIColor colorWithRed:1 green:1 blue:1 alpha:0.3];
        version.text = @"0.0.1";
        version.font = [UIFont systemFontOfSize:14];
        version.translatesAutoresizingMaskIntoConstraints = NO;
        [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:version
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:infoCell
                                                         attribute:NSLayoutAttributeTrailingMargin
                                                        multiplier:1
                                                          constant:-13.0]];
        [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:version
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:infoCell
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
    }else if (indexPath.section == 1){
        if (indexPath.row == 0) {
            infoCell.textLabel.text = @"Bug Report";
            infoCell.textLabel.textColor = [UIColor whiteColor];
            if (!bugReport) {
                bugReport = [UIButton buttonWithType:UIButtonTypeCustom];
                [infoCell addSubview:bugReport];
                
            }
            [bugReport setTitle:@"Report a Bug" forState:UIControlStateNormal];
            [bugReport setTitleColor: [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] forState:UIControlStateNormal];
            [bugReport setTitleColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(0.3)] forState:UIControlStateHighlighted];
            bugReport.translatesAutoresizingMaskIntoConstraints = NO;
            [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:bugReport
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:infoCell
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                multiplier:1
                                                                  constant:-13.0]];
            [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:bugReport
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:infoCell
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
            [bugReport addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        }else if (indexPath.row == 1){
            infoCell.textLabel.text = @"Twitter";
            infoCell.textLabel.textColor = [UIColor whiteColor];
            if (!twitter) {
                twitter = [UIButton buttonWithType:UIButtonTypeCustom];
                [infoCell addSubview:twitter];
                
            }
            [twitter setTitle:@"@tomahawk" forState:UIControlStateNormal];
            [twitter setTitleColor: [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] forState:UIControlStateNormal];
            [twitter setTitleColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(0.3)] forState:UIControlStateHighlighted];
            twitter.translatesAutoresizingMaskIntoConstraints = NO;
            [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:twitter
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:infoCell
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                multiplier:1
                                                                  constant:-13.0]];
            [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:twitter
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:infoCell
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
            [twitter addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];

        }else{
            infoCell.textLabel.text = @"Website";
            infoCell.textLabel.textColor = [UIColor whiteColor];
            if (!website) {
                website = [UIButton buttonWithType:UIButtonTypeCustom];
                [infoCell addSubview:website];
                
            }
            [website setTitle:@"tomahawk-player.org" forState:UIControlStateNormal];
            [website setTitleColor: [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] forState:UIControlStateNormal];
            [website setTitleColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(0.3)] forState:UIControlStateHighlighted];
            website.translatesAutoresizingMaskIntoConstraints = NO;
            [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:website
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:infoCell
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                multiplier:1
                                                                  constant:-13.0]];
            [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:website
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:infoCell
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
            [website addTarget:self action:@selector(button:) forControlEvents:UIControlEventTouchUpInside];
        }
        infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return infoCell;
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return nil;
    }else{
        return indexPath;
    }
}

@end
