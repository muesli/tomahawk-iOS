//
//  PlaylistsTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 04/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "PlaylistsTableViewController.h"
#import "CustomTableViewCell.h"

@interface PlaylistsTableViewController ()

@end

@implementation PlaylistsTableViewController

-(IBAction)moreButtonTouched:(UIButton *)button forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:currentTouchPosition];
    CustomTableViewCell *selectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    NSString *playlist = selectedCell.myTextLabel.text;
    NSString *artist = selectedCell.myDetailTextLabel.text;
    UIAlertController *more = [UIAlertController alertControllerWithTitle:playlist message:artist preferredStyle:UIAlertControllerStyleActionSheet];
    [more addAction:[UIAlertAction actionWithTitle:@"Play Next" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Play next
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Add to Queue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Add to queue
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Share
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Go to Artist" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Goto Artist
    }]];

    [more addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.view.window.rootViewController presentViewController:more animated:YES completion:nil];

        
}

- (void)viewWillAppear:(BOOL)animated {
    NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
    [self.tableView deselectRowAtIndexPath:currentCell animated:YES];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.tableFooterView = [UIView new];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
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
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    cell.myTextLabel.text = @"Title";
    cell.myDetailTextLabel.text = @"Artist";
    cell.detailTextLabel.textColor = [UIColor colorWithWhite:1 alpha:0.5];
    [cell.myAccessoryButton addTarget:self action:@selector(moreButtonTouched:forEvent:)forControlEvents:UIControlEventTouchUpInside];
    cell.myImageView.image = [UIImage imageNamed:@"PlaceholderPlaylists"];
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
