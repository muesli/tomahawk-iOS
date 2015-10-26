//
//  InsidePlaylistsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 17/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "InsidePlaylistsViewController.h"

@interface InsidePlaylistsViewController ()

@end

@implementation InsidePlaylistsViewController{
    NSString *myCellText;
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.backBarButtonItem.tintColor = [UIColor whiteColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1.0];
    myCellText = @"Placeholder";
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleDark];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = self.imageView.bounds;
    [self.imageView addSubview:effectView];
    // Do any additional setup after loading the view.
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


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    self.tableView.delaysContentTouches = NO;   //Removes stupid delay when button selecting
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell1"];
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
    cell.detailTextLabel.text = @"Placeholder";
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:(29.0/255.0) green:(30.0/255.0) blue:(35.0/255.0) alpha:(1.0)];
    //Create Buttons
    [[self tableView] setAlwaysBounceVertical:NO];
    [[self tableView]setBounces:NO];
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
    headerView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0];
    UILabel *textLabel = [[UILabel alloc]init];
    [textLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    textLabel.text = @"53 Songs in the Playlist";
    textLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:textLabel];
    
    UIButton *moreHeader = [UIButton buttonWithType:UIButtonTypeCustom];
    [moreHeader setTranslatesAutoresizingMaskIntoConstraints:NO];
    [moreHeader setImage:[UIImage imageNamed:@"More"] forState:UIControlStateNormal];
    [headerView addSubview:moreHeader];
    
    UIButton *download = [UIButton buttonWithType:UIButtonTypeCustom];
    [download setTranslatesAutoresizingMaskIntoConstraints:NO];
    [download setImage:[UIImage imageNamed:@"Cloud"] forState:UIControlStateNormal];
    [headerView addSubview:download];
    
    UIButton *shuffle = [UIButton buttonWithType:UIButtonTypeCustom];
    [shuffle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [shuffle setImage:[UIImage imageNamed:@"Shuffle"] forState:UIControlStateNormal];
    [headerView addSubview:shuffle];
#pragma mark - AutoLayout Constraints
    
    //More Button Right
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:moreHeader
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:headerView
                                                          attribute:NSLayoutAttributeTrailingMargin
                                                         multiplier:0.95
                                                           constant:0.0]];
    //More Button Top
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:moreHeader
                                                     attribute:NSLayoutAttributeCenterY
                                                     relatedBy:NSLayoutRelationEqual
                                                        toItem:headerView
                                                     attribute:NSLayoutAttributeCenterY
                                                    multiplier:1.0
                                                      constant:0.0]];
    //Download Button Right
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:download
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                          multiplier:0.83
                                                            constant:0.0]];
    //Download Button Top
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:download
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0.0]];
    //Shuffle Button Right
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:shuffle
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeTrailingMargin
                                                          multiplier:0.70
                                                            constant:0.0]];
    //Shuffle Button Top
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:shuffle
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0.0]];

    //Label Left
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                           attribute:NSLayoutAttributeLeadingMargin
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeLeadingMargin
                                                          multiplier:3.3
                                                            constant:0.0]];
    //Label Top
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                           attribute:NSLayoutAttributeCenterY
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:headerView
                                                           attribute:NSLayoutAttributeCenterY
                                                          multiplier:1.0
                                                            constant:0.0]];

    self.tableView.tableHeaderView = headerView;
//    [self tableView:tableView viewForHeaderInSection:(NSInteger)]
    return cell;
}


- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell* cell = [self.tableView cellForRowAtIndexPath:indexPath];
    if(cell.accessoryType == UITableViewCellAccessoryNone){
        return nil;
    }
    return indexPath;
}


-(IBAction)moreButtonTouched:(id)sender forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    
    // Lookup the index path of the cell whose more button was modified.
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"Cock.jpg");
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
