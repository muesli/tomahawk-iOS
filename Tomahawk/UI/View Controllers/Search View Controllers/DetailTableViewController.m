//
//  DetailTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "DetailTableViewController.h"
#import "CustomTableViewCell.h"
#import "TEngine.h"
#import "UIImageView+AFNetworking.h"

@interface DetailTableViewController () {
    NSArray *textLabels, *detailTextLabels, *images, *secondDetailTextLabels;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *tableViewBG;
}

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL hasNextPage;
@property (assign, nonatomic) int currentPage;

@end

@implementation DetailTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.backgroundColor = [UIColor groupTableViewBackgroundColor];
    [self.tableView registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    self.currentPage = 0;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
    self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 44, 0);
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.tableView.center;
    self.tableView.backgroundView = activityIndicatorView;
    [activityIndicatorView sizeToFit];
    [activityIndicatorView startAnimating];
    [self loadNextPage:self.currentPage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (textLabels.count == 0 && detailTextLabels.count == 0 && images.count == 0) {
        UIActivityIndicatorView *indicator = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
        indicator.center = self.tableView.center;
        self.tableView.backgroundView = indicator;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        [indicator sizeToFit];
        [indicator startAnimating];
        return 0;
    }else {
        self.tableView.backgroundView = nil;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
        return 1;
    }

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return textLabels.count;
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.tableView) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        float reload_distance = 10;
        if(y > h + reload_distance && self.isLoading == FALSE && self.hasNextPage == YES) {
            self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 85, 0);
            self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 85, 0);
            tableViewBG =  tableViewBG ? : ({
                UIView *myView = [[UIView alloc]init];
                myView;
            });
            activityIndicatorView =  activityIndicatorView ? : ({
                UIActivityIndicatorView *myView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [myView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [tableViewBG addSubview:myView];
                myView;
            });
            [tableViewBG addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:tableViewBG attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [tableViewBG addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:tableViewBG attribute:NSLayoutAttributeBottom multiplier:1 constant:-50]];
            [activityIndicatorView startAnimating];

            [self.tableView setBackgroundView:tableViewBG];
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
    self.hasNextPage = NO;
    [TEngine searchSongsBySongName:self.query resolver:RDeezer limit:30 page:pageNumber completion:^(id response) {
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
        [self.tableView setBackgroundView:nil];
        self.tableView.contentInset = UIEdgeInsetsMake(0, 0, 44, 0);
        self.tableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 44, 0);
        tableViewBG = nil;
        if ([response isKindOfClass:[NSError class]]) {
            UIAlertController *error = [response createAlertFromError];
            [self presentViewController:error animated:YES completion:nil];
            self.hasNextPage = YES;
            return;
        }else {
            textLabels = textLabels ? [textLabels arrayByAddingObjectsFromArray:[response objectForKey:@"songNames"]] : [response objectForKey:@"songNames"];
            detailTextLabels = detailTextLabels ? [detailTextLabels arrayByAddingObjectsFromArray:[response objectForKey:@"artistNames"]] : [response objectForKey:@"artistNames"];
            images = images ? [images arrayByAddingObjectsFromArray:[response objectForKey:@"songImages"]] : [response objectForKey:@"songImages"];
            secondDetailTextLabels = secondDetailTextLabels ? [secondDetailTextLabels arrayByAddingObjectsFromArray:[response objectForKey:@"albumNames"]] : [response objectForKey:@"albumNames"];
        }
        if ([[response objectForKey:@"songNames"] count] != 0 && [[response objectForKey:@"artistNames"] count] != 0 && [[response objectForKey:@"songImages"] count] != 0 ) {
            self.hasNextPage = YES;
        }
        [self.tableView reloadData];
        self.isLoading = NO;
    }];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 80;
}



@end
