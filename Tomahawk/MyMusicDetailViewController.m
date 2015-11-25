//
//  PlaylistsDetailViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 17/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "MyMusicDetailViewController.h"

@interface MyMusicDetailViewController ()

@end

@implementation MyMusicDetailViewController{
    NSString *myCellText;
    NSString *artistName;
    CMTime time;
    NSArray *myArray;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]
                          atScrollPosition:UITableViewScrollPositionTop animated:NO];
    self.tableView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1.0];
    
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    
    myCellText = @"Placeholder";
    
    UIImageView *background = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 161)];
    background.image = [UIImage imageNamed:@"blurExample1"];
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = background.bounds;
    [self.view addSubview:background];
    [background addSubview:effectView];
    [_followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
    _followButton.layer.borderWidth = 0.5;
    _followButton.layer.masksToBounds = YES;
    _followButton.layer.cornerRadius = 3.0;
    _followButton.layer.borderColor = [UIColor whiteColor].CGColor;
    [self.view addSubview:_followButton];
    _playlistImage.image = [UIImage imageNamed:@"blurExample1"];
    [self.view addSubview:_playlistImage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 100;
}
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return 70;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
    headerView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0];
    
    UIButton *more = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *download = [UIButton buttonWithType:UIButtonTypeCustom];
    UIButton *shuffle = [UIButton buttonWithType:UIButtonTypeCustom];
    myArray = [NSArray arrayWithObjects: more, download, shuffle, nil];
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
    textLabel.text = @"53 Songs in the Playlist";
    textLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:textLabel];
    
    [more setImage:[UIImage imageNamed:@"More"] forState:UIControlStateNormal];
    [download setImage:[UIImage imageNamed:@"Cloud"] forState:UIControlStateNormal];
    [shuffle setImage:[UIImage imageNamed:@"Shuffle"] forState:UIControlStateNormal];
    
    //More Button Right Constraint
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:more
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                          multiplier:0.95
                                                            constant:0.0]];

    //Download Button Right Constraint
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:download
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                          multiplier:0.83
                                                            constant:0.0]];
    
    //Shuffle Button Right Constraint
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:shuffle
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                          multiplier:0.70
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    [[self tableView]setDelaysContentTouches:NO];
    [[self tableView] setAlwaysBounceVertical:NO];
    [[self tableView]setBounces:NO];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
//    artistName = @"OMI";
//    cell.detailTextLabel.text = [NSString stringWithFormat:@"ARTIST: %@ • LENGTH: %@", artistName, time];
    UIButton *more=[UIButton buttonWithType:UIButtonTypeCustom];
    UIImage *image = [UIImage imageNamed:@"More"];
    [more setImage:image forState:UIControlStateNormal];
    more.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    more.tag = indexPath.row;
    [more addTarget:self action:@selector(moreButtonTouched:forEvent:)forControlEvents:UIControlEventTouchUpInside];
    [more setContentMode:UIViewContentModeScaleToFill];
    cell.accessoryView = more;
    [[cell textLabel] setTextColor:([UIColor whiteColor])];
    cell.textLabel.text = myCellText;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:(29.0/255.0) green:(30.0/255.0) blue:(35.0/255.0) alpha:(1.0)];
    return cell;
}



-(IBAction)moreButtonTouched:(id)sender forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    // Lookup the index path of the cell whose more button was modified.
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    //Do Stuff
}

-(IBAction) buttonTouchDown:(id)sender {
    if(isButtonSelected == TRUE){
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
        _followButton.backgroundColor = [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)];
    }else{
        [_followButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        _followButton.backgroundColor = [UIColor whiteColor];
        _followButton.layer.borderColor = [UIColor whiteColor].CGColor;
    }
}
- (IBAction)buttonTouchUpOutside:(id)sender {
    if(isButtonSelected == TRUE){
        _followButton.backgroundColor = [UIColor whiteColor];
        _followButton.titleLabel.textColor = [UIColor blackColor];
    }else{
        _followButton.backgroundColor = [UIColor clearColor];
        _followButton.titleLabel.textColor = [UIColor whiteColor];
    }
}

-(IBAction) buttonTouchUpInside:(id)sender {
    MBProgressHUD *HUD = [[MBProgressHUD alloc] initWithView:self.navigationController.view];
    [self.navigationController.view addSubview:HUD];
    HUD.customView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"Checkmark"]];
    // Set custom view mode
    HUD.mode = MBProgressHUDModeCustomView;
    HUD.delegate = self;
    HUD.labelText = @"Success!";
    if(isButtonSelected == TRUE){
        isButtonSelected = FALSE;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        [_followButton setTitle:@"FOLLOW" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _followButton.backgroundColor = [UIColor clearColor];
        [[_followButton layer]setBorderColor:[UIColor whiteColor].CGColor];
    }else{
        isButtonSelected = TRUE;
        [HUD show:YES];
        [HUD hide:YES afterDelay:1];
        [_followButton setTitle:@"UNFOLLOW" forState:UIControlStateNormal];
        [_followButton setTitleColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)] forState:UIControlStateNormal];
        [_followButton setBackgroundColor:[UIColor clearColor]];
        [[_followButton layer]setBorderColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)].CGColor];

    }
}

-(void)follow:(BOOL)isFollow{
    //unfollow person
    
}

@end
