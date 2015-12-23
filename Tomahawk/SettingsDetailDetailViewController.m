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
    UITableView *advanced, *info;
    UISwitch *private;
}

@end

@implementation SettingsDetailDetailViewController


-(IBAction)buttonHighlight:(UIButton *)button{
    if (button == bugReport) {
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }else if (button == twitter){
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }else{
        [UIView animateWithDuration:0.2 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:0.3];
                         }
                         completion:nil];
    }

}
-(IBAction)buttonUnhighlight:(UIButton *)button{
    if (button == bugReport) {
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }else if (button == twitter){
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }else{
        [UIView animateWithDuration:0.4 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:1];
                         }
                         completion:nil];
    }
}
-(IBAction)buttonSelected:(UIButton *)button{
    if (button == bugReport) {
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:1];
                         }
                         completion:^(BOOL finished){
                             [self performSegueWithIdentifier:@"bugReport" sender:button];
                         }];
    }else if (button == twitter){
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:1];
                         }
                         completion:^(BOOL finished){
                             [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"https://twitter.com/tomahawk"]];
                         }];
    }else{
        [UIView animateWithDuration:0.0 delay:0.0 options:UIViewAnimationOptionAllowUserInteraction|UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             [button.titleLabel setAlpha:1];
                         }
                         completion:^(BOOL finished){
                             SFSafariViewController *svc = [[SFSafariViewController alloc]initWithURL:[NSURL URLWithString:@"http://tomahawk-player.org"]];
                             svc.view.tintColor = self.view.window.tintColor;
                             [self presentViewController:svc animated:TRUE completion:nil];
                         }];
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
        advanced = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
        advanced.delaysContentTouches = NO;
        advanced.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
        advanced.separatorColor = [UIColor colorWithRed:52.0/255.0 green:53.0/255.0 blue:57.0/255.0 alpha:1];
        advanced.delegate = self;
        advanced.dataSource = self;
        [advanced registerClass:[UITableViewCell class] forCellReuseIdentifier:@"advancedCell"];
        [self.view addSubview:advanced];
    }else if ([_currentSetting.name isEqual:@"Info"]){
        info = [[UITableView alloc]initWithFrame:self.view.frame style:UITableViewStyleGrouped];
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
    unsigned long long int j = indexPath.row;
    j++;
    for (unsigned long long int i = indexPath.row; i<j; i++) {
        connectCell.image = [[UIImageView alloc]initWithImage:[[[resolvers objectAtIndex:i]valueForKey:@"image"]valueForKey:@"image"]];
        connectCell.color = [[resolvers objectAtIndex:i]valueForKey:@"color"];
    }
    connectCell.backgroundColor = [UIColor clearColor];
    return connectCell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    ConnectAlertController *connect = [ConnectAlertController alertControllerWithTitle:@"Cock" message:nil preferredStyle:UIAlertControllerStyleAlert];
    connect.color = [[resolvers objectAtIndex:indexPath.row]valueForKey:@"color"];
    connect.resolverTitle = [names objectAtIndex:indexPath.row];
    connect.resolverImage = [[[resolvers objectAtIndex:indexPath.row]valueForKey:@"image"]valueForKey:@"image"];
    [self presentViewController:connect animated:YES completion:nil];
}

#pragma mark - Info Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    if (tableView == info) {
        return 3;
    }else{
        return 4;
    }
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (tableView == info) {
        if (section == 1) {
            return 3;
        }
        return 1;
    }else{
        return 1;
    }
}
-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    if (tableView == info) {
        if (section == 0) {
            return @"VERSION";
        }else if (section == 1){
            return @"ABOUT US";
        }else{
            return @"LICENSES";
        }
    }else{
        if (section == 0) {
            return @"PRIVATE LISTENING";
        }else{
            return nil;
        }
    }
}

-(NSString *)tableView:(UITableView *)tableView titleForFooterInSection:(NSInteger)section{
    if (tableView == advanced) {
        if (section == 0) {
            return @"Hides your song activity from your friends";
        }
    }
    return nil;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (tableView == info) {
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
            NSMutableArray *myArray = [[NSMutableArray alloc]init];
            if (indexPath.row == 0) {
                infoCell.textLabel.text = @"Bug Report";
                infoCell.textLabel.textColor = [UIColor whiteColor];
                if (!bugReport) {
                    bugReport = [UIButton buttonWithType:UIButtonTypeCustom];
                    [infoCell addSubview:bugReport];
                    [myArray addObject:bugReport];
                    
                }
                [bugReport setTitle:@"Report a Bug" forState:UIControlStateNormal];
            }else if (indexPath.row == 1){
                infoCell.textLabel.text = @"Twitter";
                infoCell.textLabel.textColor = [UIColor whiteColor];
                if (!twitter) {
                    twitter = [UIButton buttonWithType:UIButtonTypeCustom];
                    [infoCell addSubview:twitter];
                    [myArray addObject:twitter];
                    
                }
                [twitter setTitle:@"@tomahawk" forState:UIControlStateNormal];

                
            }else{
                infoCell.textLabel.text = @"Website";
                infoCell.textLabel.textColor = [UIColor whiteColor];
                if (!website) {
                    website = [UIButton buttonWithType:UIButtonTypeCustom];
                    [infoCell addSubview:website];
                    [myArray addObject:website];
                    
                }
                [website setTitle:@"tomahawk-player.org" forState:UIControlStateNormal];
            }
            for (UIButton *buttons in myArray) {
                [buttons setTitleColor: [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] forState:UIControlStateNormal];
                buttons.translatesAutoresizingMaskIntoConstraints = NO;
                [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                                     attribute:NSLayoutAttributeTrailingMargin
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:infoCell
                                                                     attribute:NSLayoutAttributeTrailingMargin
                                                                    multiplier:1
                                                                      constant:-13.0]];
                [infoCell addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                                     attribute:NSLayoutAttributeCenterY
                                                                     relatedBy:NSLayoutRelationEqual
                                                                        toItem:infoCell
                                                                     attribute:NSLayoutAttributeCenterY
                                                                    multiplier:1
                                                                      constant:0]];
                [buttons addTarget:self action:@selector(buttonHighlight:) forControlEvents:UIControlEventTouchDown | UIControlEventTouchDragInside];
                [buttons addTarget:self action:@selector(buttonUnhighlight:) forControlEvents: UIControlEventTouchUpOutside | UIControlEventTouchDragExit];
                [buttons addTarget:self action:@selector(buttonSelected:) forControlEvents: UIControlEventTouchUpInside];
            }
            infoCell.selectionStyle = UITableViewCellSelectionStyleNone;
        }
        return infoCell;
    }else{
        UITableViewCell *advancedCell = [tableView dequeueReusableCellWithIdentifier:@"advancedCell"];
        advancedCell.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:45.0/255.0 alpha:1];
        [advancedCell setSelectionStyle:UITableViewCellSelectionStyleNone];
        if (indexPath.section == 0) {
            advancedCell.textLabel.text = @"Private Listening";
            advancedCell.textLabel.textColor = [UIColor whiteColor];
            if (!private) {
                private = [[UISwitch alloc]init];
                [advancedCell addSubview:private];
            }
            private.translatesAutoresizingMaskIntoConstraints = NO;
            [private setOnTintColor:self.view.window.tintColor];
            [advancedCell addConstraint:[NSLayoutConstraint constraintWithItem:private
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:advancedCell
                                                                 attribute:NSLayoutAttributeTrailingMargin
                                                                multiplier:1
                                                                  constant:-13.0]];
            
            [advancedCell addConstraint:[NSLayoutConstraint constraintWithItem:private
                                                                 attribute:NSLayoutAttributeCenterY
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:advancedCell
                                                                 attribute:NSLayoutAttributeCenterY
                                                                multiplier:1
                                                                  constant:0]];
        }
        return advancedCell;
    }
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0 || indexPath.section == 1) {
        return nil;
    }else{
        return indexPath;
    }
}

@end
