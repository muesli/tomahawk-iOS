//
//  ChartsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ChartsViewController.h"

@interface ChartsViewController ()

@end

@implementation ChartsViewController

-(IBAction)moreButtonTouched:(UIButton *)button forEvent:(UIEvent *)event{
    NSSet *touches = [event allTouches];
    UITouch *touch = [touches anyObject];
    CGPoint currentTouchPosition = [touch locationInView:self.top];
    NSIndexPath *indexPath = [self.top indexPathForRowAtPoint:currentTouchPosition];
    CustomTableViewCell *selectedCell = [self.top cellForRowAtIndexPath:indexPath];
    NSString *textLabel = selectedCell.myTextLabel.text;
    NSString *detailTextLabel = selectedCell.myDetailTextLabel.text;
    
    UIAlertController *more = [UIAlertController alertControllerWithTitle:textLabel message:detailTextLabel preferredStyle:UIAlertControllerStyleActionSheet];
    
    indexPath.section == 0 ? [more addAction:[UIAlertAction actionWithTitle:@"Save" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Save song
    }]] : [more addAction:[UIAlertAction actionWithTitle:@"Follow" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Follow Artist
    }]];
    indexPath.section == 0 ? [more addAction:[UIAlertAction actionWithTitle:@"Play Next" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Play next
    }]] : nil;
    indexPath.section == 0 ? [more addAction:[UIAlertAction actionWithTitle:@"Add to Queue" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Add to queue
    }]]: nil;
    [more addAction:[UIAlertAction actionWithTitle:@"Share" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Share
    }]];
    [more addAction:[UIAlertAction actionWithTitle:@"Start Radio" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Start Radio
    }]];
    
    indexPath.section == 0 ? [more addAction:[UIAlertAction actionWithTitle:@"Go to Artist" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Goto Artist
    }]] : nil;
    
    indexPath.section == 0 ? [more addAction:[UIAlertAction actionWithTitle:@"Go to Album" style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        //Goto Album
    }]] : nil;
    [more addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self.view.window.rootViewController presentViewController:more animated:YES completion:nil];
}

-(void)viewDidLayoutSubviews {
    [super viewDidLayoutSubviews];
    [self.scrollView layoutIfNeeded];
    self.scrollView.contentSize = self.contentView.bounds.size;
}

-(void)viewDidLoad {
    [super viewDidLoad];
    [self.chartsByCountry registerNib:[UINib nibWithNibName:@"CollectionView" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    [self.top registerNib:[UINib nibWithNibName:@"CustomTableViewCell" bundle:nil] forCellReuseIdentifier:@"cell"];
    
}

#pragma mark - Collection view

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 14;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    CollectionViewCell *chartsByCountry = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    chartsByCountry.image.image = [UIImage imageNamed:@"PlaceholderCountryCharts"];
    return chartsByCountry;
}

#pragma mark - Table view

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 4;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CustomTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    if (indexPath.section == 0) {
        [TEngine getTopTracksWithCompletionBlock:^(id response) {
            if ([response isKindOfClass:[NSError class]]) {
                NSLog(@"Error is %@", response);
            }else {
                cell.myTextLabel.text = [[response objectForKey:@"songNames"]objectAtIndex:indexPath.row];
                cell.myDetailTextLabel.text = [[response objectForKey:@"artistNames"]objectAtIndex:indexPath.row];
                [cell.myImageView setImageWithURL:[NSURL URLWithString:[[response objectForKey:@"mediumImages"]objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderCharts"]];
            }
        }];
    }else{
        [TEngine getTopArtistsWithCompletionBlock:^(id response) {
            if ([response isKindOfClass:[NSError class]]) {
                NSLog(@"Error is %@", response);
            }else {
                cell.myTextLabel.text = [[response objectForKey:@"artistNames"]objectAtIndex:indexPath.row];
                NSNumberFormatter *numberFormatter = [NSNumberFormatter new];
                [numberFormatter setNumberStyle:NSNumberFormatterDecimalStyle];
                NSString *followers = [NSString stringWithFormat:@"Listeners: %@", [numberFormatter numberFromString:[[response objectForKey:@"artistListeners"]objectAtIndex:indexPath.row]]];
                cell.myDetailTextLabel.text = followers;
                [cell.myImageView setImageWithURL:[NSURL URLWithString:[[response objectForKey:@"mediumImages"]objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderCharts"]];
            }
        }];
    }
    [cell.myAccessoryButton addTarget:self action:@selector(moreButtonTouched:forEvent:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *headerView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor clearColor];
    
    UILabel *headerTitle = [UILabel new];
    
    headerTitle.text = section == 0 ? @"TOP SONGS" : @"TOP ARTISTS";
    
    headerTitle.font = [UIFont systemFontOfSize:12 weight:0.2];
    headerTitle.alpha = 0.5;
    headerTitle.textColor = [UIColor whiteColor];
    [headerTitle setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:headerTitle];
    
    
    UIButton *seeAll = [UIButton buttonWithType:UIButtonTypeSystem];
    
    [seeAll setImage:[UIImage imageNamed:@"More Than"] forState:UIControlStateNormal];
    [seeAll setTitleEdgeInsets:UIEdgeInsetsMake(0, -105.0, 0, 0)];
    [seeAll setImageEdgeInsets:UIEdgeInsetsMake(3, -2, 3, 18)];
    [seeAll setContentEdgeInsets:UIEdgeInsetsMake(0, 66, 0, 0)];
    [seeAll setTitle:@"SEE ALL" forState:UIControlStateNormal];
    [seeAll setReversesTitleShadowWhenHighlighted:YES];
    [seeAll setTintColor:[UIColor whiteColor]];
    [[seeAll titleLabel] setFont:[UIFont systemFontOfSize:12]];
    [seeAll setTranslatesAutoresizingMaskIntoConstraints:NO];
    [headerView addSubview:seeAll];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeTrailingMargin multiplier:1 constant:-5]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    
    [seeAll addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:15]];
    
    [seeAll addConstraint:[NSLayoutConstraint constraintWithItem:seeAll attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:0 constant:70]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerTitle attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeLeadingMargin multiplier:1 constant:20]];
    
    [headerView addConstraint:[NSLayoutConstraint constraintWithItem:headerTitle attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:headerView attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
    return headerView;
    
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 40; //Have to add this in code and in IB otherwise ios doesn't execute the first header code at all
}



@end
