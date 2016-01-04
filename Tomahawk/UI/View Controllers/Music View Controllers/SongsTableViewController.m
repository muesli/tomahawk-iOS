//
//  SongsTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 04/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "SongsTableViewController.h"

@interface SongsTableViewController ()

@end

@implementation SongsTableViewController

-(IBAction)moreButtonTouched:(UIButton *)button forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    // Lookup the index path of the cell whose checkbox was modified.
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    NSLog(@"selected with index path row of %ld", (long)indexPath.row);
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:currentCell animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    cell.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
    cell.textLabel.text = @"Title";
    cell.textLabel.textColor = [UIColor whiteColor];
    cell.detailTextLabel.text = @"Artist";
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    
    UIButton *more = [UIButton buttonWithType:UIButtonTypeSystem];
    UIImage *image = [UIImage imageNamed:@"More"];
    [more setTintColor:[UIColor whiteColor]];
    [more setImage:image forState:UIControlStateNormal];
    more.frame = CGRectMake(0, 0, image.size.width, image.size.height);
    [more addTarget:self action:@selector(moreButtonTouched:forEvent:)forControlEvents:UIControlEventTouchUpInside];
    [more setContentMode:UIViewContentModeScaleToFill];
    cell.accessoryView = more;
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 70)];
    headerView.backgroundColor = [UIColor colorWithRed:37.0/255.0 green:38.0/255.0 blue:43.0/255.0 alpha:1.0];
    
    UIButton *download = [UIButton buttonWithType:UIButtonTypeSystem];
    UIButton *shuffle = [UIButton buttonWithType:UIButtonTypeSystem];
    NSArray *myArray = @[download, shuffle];
    for (UIButton *buttons in myArray) {
        [buttons setTranslatesAutoresizingMaskIntoConstraints:NO];
        [headerView addSubview:buttons];
        [buttons setTintColor:[UIColor whiteColor]];
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
    textLabel.text = @"3 Songs Saved";
    textLabel.textColor = [UIColor whiteColor];
    [headerView addSubview:textLabel];
        
    [download setImage:[UIImage imageNamed:@"Cloud"] forState:UIControlStateNormal];
    [shuffle setImage:[UIImage imageNamed:@"Shuffle"] forState:UIControlStateNormal];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:download
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:0.95
                                                                constant:0.0]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:shuffle
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeTrailingMargin
                                                              multiplier:0.83
                                                                constant:0.0]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeLeadingMargin
                                                              multiplier:3.3
                                                                constant:0.0]];

    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:textLabel
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:headerView
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1.0
                                                                constant:0.0]];
    return headerView;
}



#pragma mark - Table view delegate

//- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    // Navigation logic may go here, for example:
//    // Create the next view controller.
//    <#DetailViewController#> *detailViewController = [[<#DetailViewController#> alloc] initWithNibName:<#@"Nib name"#> bundle:nil];
//    
//    // Pass the selected object to the new view controller.
//    
//    // Push the view controller.
//    [self.navigationController pushViewController:detailViewController animated:YES];
//}


@end
