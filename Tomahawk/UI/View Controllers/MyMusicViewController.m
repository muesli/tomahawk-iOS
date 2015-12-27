//
//  MyMusicViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 16/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "MyMusicViewController.h"

@interface MyMusicViewController ()

@end
@implementation MyMusicViewController{
    NSString *myCellText;
    int shouldShowDetails;
    NSArray *myArray;
    UIButton *more;
}

- (IBAction)inboxButton:(id *)sender {
    //Insert Code Here
}

-(IBAction)moreButtonSelected:(UIButton *)button forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    // Lookup the index path of the cell whose checkbox was modified.
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"Row is :%ld and Section is: %ld", (long)indexPath.row, indexPath.section);
}

-(void)viewWillAppear:(BOOL)animated{
    NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:currentCell animated:YES];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage new]
                       forBarPosition:UIBarPositionAny
                           barMetrics:UIBarMetricsDefault];
    
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
    self.tableView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1.0];
    myCellText = @"Placeholder";

#pragma mark - Custom Segmented Control
    HMSegmentedControl *segmentedControl1 = [[HMSegmentedControl alloc] initWithSectionTitles:@[@"PLAYLISTS", @"SONGS"]];
    segmentedControl1.autoresizingMask = UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleWidth;
    segmentedControl1.frame = CGRectMake(7, 0, CGRectGetWidth(self.view.frame)*0.95, 40);
    segmentedControl1.segmentEdgeInset = UIEdgeInsetsMake(0, 0, 0, 0);
    segmentedControl1.selectionStyle = HMSegmentedControlSelectionStyleFullWidthStripe;
    segmentedControl1.selectionIndicatorLocation = HMSegmentedControlSelectionIndicatorLocationDown;
    segmentedControl1.verticalDividerEnabled = NO;
    [segmentedControl1 setTitleFormatter:^NSAttributedString *(HMSegmentedControl *segmentedControl, NSString *title, NSUInteger index, BOOL selected) {
        NSAttributedString *attString = [[NSAttributedString alloc] initWithString:title attributes:@{NSForegroundColorAttributeName : [UIColor whiteColor], NSFontAttributeName : [UIFont systemFontOfSize:12.0f weight:0.3f]}];
        return attString;
    }];
    [segmentedControl1 addTarget:self action:@selector(segmentedControlChangedValue:) forControlEvents:UIControlEventValueChanged];
    UIView *barbackground = [[UIView alloc]initWithFrame:CGRectMake(0, CGRectGetMinY(segmentedControl1.frame),  CGRectGetWidth(self.view.frame), CGRectGetHeight(segmentedControl1.frame))];
    barbackground.backgroundColor = [UIColor colorWithRed:49.0f/255.0f green:49.0f/255.0f blue:61.0f/255.0f alpha:1.0f];
    [self.view addSubview:barbackground];
    [self.view addSubview:segmentedControl1];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table View

- (void)killScroll{
    CGPoint offset = _tableView.contentOffset;
    offset.x = 0;
    offset.y = 50;
    [_tableView setContentOffset:offset animated:NO];
}



-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if(shouldShowDetails == 1){
        return 70;
    }
    return 0;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if(shouldShowDetails == 1){
        
        UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
        headerView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0];
        
        UIButton *download = [UIButton buttonWithType:UIButtonTypeCustom];
        UIButton *shuffle = [UIButton buttonWithType:UIButtonTypeCustom];
        myArray = [NSArray arrayWithObjects: download, shuffle, nil];
        for (UIButton *buttons in myArray) {
            [buttons setTranslatesAutoresizingMaskIntoConstraints:NO];
            [headerView addSubview:buttons];
            [headerView addConstraint:[NSLayoutConstraint constraintWithItem:buttons
                                                                   attribute:NSLayoutAttributeCenterY
                                                                   relatedBy:NSLayoutRelationEqual
                                                                      toItem:headerView
                                                                   attribute:NSLayoutAttributeCenterY
                                                                  multiplier:1.0
                                                                    constant:0.0]];
        }
        
        UILabel *textLabel = [[UILabel alloc]init];
        [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        textLabel.text = @"61 Songs Saved";
        textLabel.textColor = [UIColor whiteColor];
        [headerView addSubview:textLabel];
        
        [download setImage:[UIImage imageNamed:@"Cloud"] forState:UIControlStateNormal];
        [shuffle setImage:[UIImage imageNamed:@"Shuffle"] forState:UIControlStateNormal];
        
        
        //Download Button Right Constraint
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:download
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:0.95
                                                                constant:0.0]];
        
        //Shuffle Button Right Constraint
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:shuffle
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:0.83
                                                                constant:0.0]];
        
        
        //Label Left Constraint
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                              multiplier:3.3
                                                                constant:0.0]];
        //Label Top Constraint
        [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
    return headerView;
    }
    [tableView.tableHeaderView removeFromSuperview];
    return nil;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0 && indexPath.section == 0) {
        [self killScroll];
    }
    
    [[self tableView]setAlwaysBounceVertical:NO];
    [[self tableView]setBounces:NO];
    [[self tableView]setDelaysContentTouches:NO];
    //    artistName = @"OMI";
    //    CMTime time;
    //    cell.detailTextLabel.text = [NSString stringWithFormat:@"ARTIST: %@ • LENGTH: %@", artistName, time];
    more = [UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"More"];
    [more setImage:image forState:UIControlStateNormal];
    more.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [more addTarget:self action:@selector(moreButtonSelected:forEvent:) forControlEvents: UIControlEventTouchUpInside];
    [more setContentMode:UIViewContentModeScaleToFill];
    
    if (shouldShowDetails == 1){
        UITableViewCell *songsCell = [tableView dequeueReusableCellWithIdentifier:@"Songs"];
        songsCell.accessoryView = more;
        songsCell.textLabel.textColor = [UIColor whiteColor];
        songsCell.textLabel.text = myCellText;
        songsCell.backgroundColor = [UIColor colorWithRed:(29.0/255.0) green:(30.0/255.0) blue:(35.0/255.0) alpha:(1.0)];
        return songsCell;

    }else if (shouldShowDetails == 0){
        UITableViewCell *playlistsCell = [tableView dequeueReusableCellWithIdentifier:@"Playlists"];
        [playlistsCell setAccessoryView: more];
        [[playlistsCell textLabel] setTextColor:([UIColor whiteColor])];
        [[playlistsCell textLabel]setText:myCellText];
        [playlistsCell setBackgroundColor:[UIColor colorWithRed:(29.0/255.0) green:(30.0/255.0) blue:(35.0/255.0) alpha:(1.0)]];
        return playlistsCell;
    }
    return nil;
}



#pragma mark - Segmented Control changes

- (void)segmentedControlChangedValue:(HMSegmentedControl *)segmentedControl {
    if(segmentedControl.selectedSegmentIndex == 1){
        myCellText = @"PLACEHOLDER";
        //Reset Scroll Position when change Segment
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                         atScrollPosition:UITableViewScrollPositionTop animated:NO];
        shouldShowDetails = 1;
        [self.tableView reloadData];
        
    }else{
        shouldShowDetails = 0;
        myCellText = @"Placeholder";
        //Reset Scroll Position when change Segment
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                              atScrollPosition:UITableViewScrollPositionTop animated:NO];
        [self.tableView reloadData];
    }

}



#pragma Preparing for segue
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    MyMusicDetailViewController *svc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
     NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
    
}

@end