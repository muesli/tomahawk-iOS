//
//  PlaylistsTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 04/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "PlaylistsTableViewController.h"

@interface PlaylistsTableViewController ()

@end

@implementation PlaylistsTableViewController

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
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
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
    cell.backgroundColor = [UIColor colorWithRed:29.0/255.0 green:30.0/255.0 blue:35.0/255.0 alpha:1];
    cell.imageView.image = [UIImage imageNamed:@"PlaceholderPlaylists"];
    CGFloat widthScale = 60 / cell.imageView.image.size.width;
    CGFloat heightScale = 60 / cell.imageView.image.size.height;
    cell.imageView.transform = CGAffineTransformMakeScale(widthScale, heightScale);
    [cell.imageView.layer setMinificationFilter:kCAFilterTrilinear];
    return cell;
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
