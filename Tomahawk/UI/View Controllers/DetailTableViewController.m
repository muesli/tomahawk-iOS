//
//  DetailTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "DetailTableViewController.h"

@interface DetailTableViewController () {
    NSArray *textLabels, *detailTextLabels, *images, *secondDetailTextLabels;
}

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL hasNextPage;
@property (assign, nonatomic) int currentPage;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.currentPage = 0;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, -35, 0);
    [self loadNextPage:self.currentPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return textLabels.count;
}


-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        float reload_distance = 10;
        if(y > h + reload_distance && self.isLoading == FALSE) {
            [self loadNextPage:++self.currentPage];
        }
    }
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    [cell.myAccessoryButton addTarget:self action:@selector(moreButtonTouched:forEvent:)forControlEvents:UIControlEventTouchUpInside];
    NSString *albums = [secondDetailTextLabels objectAtIndex:indexPath.row];
    NSString *text = albums ? [NSString stringWithFormat:@"%@ • %@", [detailTextLabels objectAtIndex:indexPath.row], albums] : [detailTextLabels objectAtIndex:indexPath.row];
    cell.myDetailTextLabel.text = text;
    cell.myTextLabel.text = [textLabels objectAtIndex:indexPath.row];
    [[images objectAtIndex:indexPath.row] isKindOfClass:[NSNull class]] ? [cell.myImageView setImage:[UIImage imageNamed:@"PlaceholderSongs"]] :[cell.myImageView setImageWithURL:[NSURL URLWithString:[images objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderSongs"]];
    return cell;
}

- (void)loadNextPage:(int)pageNumber {
    if (self.isLoading) return;
    self.isLoading = YES;
    [TEngine searchSongsBySongName:self.query resolver:RAppleMusic limit:30 page:pageNumber completion:^(id response) {
        if ([response isKindOfClass:[NSError class]]) {
            UIAlertController *error = [self error:response];
            [self presentViewController:error animated:YES completion:nil];
            return;
        }else {
            textLabels = textLabels ? [textLabels arrayByAddingObjectsFromArray:[response objectForKey:@"songNames"]] : [response objectForKey:@"songNames"];
            detailTextLabels = detailTextLabels ? [detailTextLabels arrayByAddingObjectsFromArray:[response objectForKey:@"artistNames"]] : [response objectForKey:@"artistNames"];
            images = images ? [images arrayByAddingObjectsFromArray:[response objectForKey:@"songImages"]] : [response objectForKey:@"songImages"];
            secondDetailTextLabels = secondDetailTextLabels ? [secondDetailTextLabels arrayByAddingObjectsFromArray:[response objectForKey:@"albumNames"]] : [response objectForKey:@"albumNames"];
        }
        [self.tableView reloadData];
        self.isLoading = NO;
    }];
}

- (UIAlertController *) error:(NSError *)message {
    UIAlertController *error = [UIAlertController alertControllerWithTitle:@"Error" message:[[message userInfo]objectForKey:NSLocalizedDescriptionKey] preferredStyle:UIAlertControllerStyleAlert];
    [error addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
    return error;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.toolbar.hidden = NO;
}

@end
