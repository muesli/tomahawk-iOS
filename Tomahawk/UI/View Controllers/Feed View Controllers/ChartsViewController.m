//
//  ChartsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 27/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "ChartsViewController.h"
#import "StickyHeaderFlowLayout.h"
#import "CustomUIButton.h"
#import "TableViewCollectionViewCell.h"
#import "NowPlayingViewController.h"
#import "UIImageView+AFNetworking.h"
#import "TEngine.h"

@interface ChartsViewController () {
    NSArray *titles, *subtitles, *images;
    UIActivityIndicatorView *activityIndicatorView;
    UIView *collectionViewBG;
    ChartsHeader *header;
    UICollectionReusableView *sectionHeader;
    UIButton *button;
    UILabel *messageLabel;
    UIImageView *image;
    NSError *myError;
}

@property (assign, nonatomic) BOOL isLoading;
@property (assign, nonatomic) BOOL hasNextPage;
@property (assign, nonatomic) int currentPage;
@property (assign, nonatomic) charts currentChart;

@end

@implementation ChartsViewController

- (void)viewDidAppear:(BOOL)animated {
    [self performBlock:^{
        NSArray *indexPath = [self.collectionView indexPathsForSelectedItems];
        if (indexPath.count != 0) {
            [self updateCellColorWithTint:NO atIndexPath:indexPath[0] animated:YES];
            [self.collectionView deselectItemAtIndexPath:indexPath[0] animated:NO];
        }
    } afterDelay:0.2];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    StickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[StickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(self.view.frame.size.width, 230);
        layout.parallaxHeaderMinimumReferenceSize = CGSizeMake(self.view.frame.size.width, 0);
        layout.itemSize = CGSizeMake(self.view.frame.size.width, layout.itemSize.height);
    }
    [self.collectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"ChartsHeader" bundle:nil] forSupplementaryViewOfKind:StickyHeaderParallaxHeader withReuseIdentifier:@"header"];
    [self.collectionView.collectionViewLayout registerClass:[TableViewCollectionViewCell class] forDecorationViewOfKind:@"Separator"];
    [self.collectionView registerNib:[UINib nibWithNibName:@"TableViewCollectionViewCell" bundle:nil] forCellWithReuseIdentifier:@"cell"];
    
    self.currentChart = kTracks;
    self.currentPage = 0;
    self.edgesForExtendedLayout = UIRectEdgeNone;
    activityIndicatorView = [[UIActivityIndicatorView alloc]initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    activityIndicatorView.center = self.collectionView.center;
    self.collectionView.backgroundView = activityIndicatorView;
    [activityIndicatorView sizeToFit];
    [activityIndicatorView startAnimating];
    [self loadNextPage:self.currentPage];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView == self.collectionView) {
        CGPoint offset = scrollView.contentOffset;
        CGRect bounds = scrollView.bounds;
        CGSize size = scrollView.contentSize;
        UIEdgeInsets inset = scrollView.contentInset;
        float y = offset.y + bounds.size.height - inset.bottom;
        float h = size.height;
        float reload_distance = 10;
        if(y > h + reload_distance && self.isLoading == FALSE && self.hasNextPage == YES) {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 233, 0);
            collectionViewBG =  collectionViewBG ? : [[UIView alloc]init];
            activityIndicatorView =  activityIndicatorView ? : ({
                UIActivityIndicatorView *myView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [myView setTranslatesAutoresizingMaskIntoConstraints:NO];
                [collectionViewBG addSubview:myView];
                myView;
            });
            [collectionViewBG addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:collectionViewBG attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [collectionViewBG addConstraint:[NSLayoutConstraint constraintWithItem:activityIndicatorView attribute:NSLayoutAttributeBottom relatedBy:NSLayoutRelationEqual toItem:collectionViewBG attribute:NSLayoutAttributeBottom multiplier:1 constant:-180]];
            [activityIndicatorView startAnimating];
            
            [self.collectionView setBackgroundView:collectionViewBG];
            [self loadNextPage:++self.currentPage];
        }
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    TableViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.textLabel.text = [titles objectAtIndex:indexPath.row];
    cell.detailTextLabel.text = subtitles.count == 0 ? @"" : [subtitles objectAtIndex:indexPath.row];
    [cell.imageView setImageWithURL:[NSURL URLWithString:[images objectAtIndex:indexPath.row]] placeholderImage:[UIImage imageNamed:@"PlaceholderCharts"]];
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return titles.count;
}


- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        sectionHeader = sectionHeader ? : ({
            UICollectionReusableView *myView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
            myView.backgroundColor = [UIColor whiteColor];
            button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.layer.borderWidth = 1;
            button.layer.borderColor = [UIColor colorWithRed:0.0 green:0.0 blue:0.0 alpha:0.1].CGColor;
            [button setImage:[UIImage imageNamed:@"Down Chevron"] forState:UIControlStateNormal];
            [button setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 130.0)];
            [button setContentEdgeInsets:UIEdgeInsetsMake(0, 100, 0, 0)];
            [button setTitle:@"TRACKS" forState:UIControlStateNormal];
            [button addTarget:self action:@selector(changeChart:) forControlEvents:UIControlEventTouchUpInside];
            [button.titleLabel setFont:[UIFont systemFontOfSize:11 weight: UIFontWeightBold]];
            [button setTintColor:[UIColor blackColor]];
            button.layer.cornerRadius = 5;
            [myView addSubview:button];
            [button setTranslatesAutoresizingMaskIntoConstraints:NO];
            [myView addConstraint:[NSLayoutConstraint constraintWithItem:myView attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterX multiplier:1 constant:0]];
            [myView addConstraint:[NSLayoutConstraint constraintWithItem:myView attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeCenterY multiplier:1 constant:0]];
            [myView addConstraint:[NSLayoutConstraint constraintWithItem:myView attribute:NSLayoutAttributeLeadingMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeLeading multiplier:1 constant:0]];
            [myView addConstraint:[NSLayoutConstraint constraintWithItem:myView attribute:NSLayoutAttributeTrailingMargin relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeTrailing multiplier:1 constant:0]];
            [myView addConstraint:[NSLayoutConstraint constraintWithItem:myView attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:button attribute:NSLayoutAttributeHeight multiplier:1 constant:20]];
            myView;
        });
        return sectionHeader;
    } else {
        header = header ? : ({
            ChartsHeader *myView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"header" forIndexPath:indexPath];
            myView.delegate = self;
            myView;
        });
        return header;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(nonnull NSIndexPath *)indexPath {
    [self updateCellColorWithTint:YES atIndexPath:indexPath animated:NO];
}

-(void)collectionView:(UICollectionView *)collectionView didUnhighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateCellColorWithTint:NO atIndexPath:indexPath animated:NO];
}

-(void)collectionView:(UICollectionView *)collectionView didHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
    [self updateCellColorWithTint:YES atIndexPath:indexPath animated:NO];
}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    [self.collectionView deselectItemAtIndexPath:indexPath animated:NO];
    [self updateCellColorWithTint:NO atIndexPath:indexPath animated:NO];
}

- (void)updateCellColorWithTint:(BOOL)tint atIndexPath:(NSIndexPath *)indexPath animated:(BOOL)animated {
    TableViewCollectionViewCell* cell = (TableViewCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
    if (animated) {
        [UIView beginAnimations:nil context:nil];
        cell.backgroundColor = tint ? [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0] : [UIColor clearColor];
        [UIView commitAnimations];
    } else {
        cell.backgroundColor = tint ? [UIColor colorWithRed:217.0/255.0 green:217.0/255.0 blue:217.0/255.0 alpha:1.0] : [UIColor clearColor];
    }
    
}

- (void)loadNextPage:(int)pageNumber {
    if (self.isLoading) return;
    self.isLoading = YES;
    self.hasNextPage = NO;
    [TEngine getChartsWithOption:self.currentChart page:pageNumber limit:10 completion:^(id response) {
        [activityIndicatorView removeFromSuperview];
        activityIndicatorView = nil;
        [self.collectionView setBackgroundView:nil];
        collectionViewBG = nil;
        if ([response isKindOfClass:[NSError class]]) {
            [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
            titles = nil;
            subtitles = nil;
            images = nil;
            [self.collectionView reloadData];
            myError = response;
            self.hasNextPage = YES;
            self.isLoading = NO;
            return;
        } else {
            [self.collectionView reloadData];
            titles = titles ? [titles arrayByAddingObjectsFromArray:[response objectForKey:@"titles"]] : [response objectForKey:@"titles"];
            subtitles = subtitles ? [subtitles arrayByAddingObjectsFromArray:[response objectForKey:@"subtitles"]] : [response objectForKey:@"subtitles"];
            images = images ? [images arrayByAddingObjectsFromArray:[response objectForKey:@"images"]] : [response objectForKey:@"images"];
        }
        if ([[response objectForKey:@"titles"] count] != 0 && [[response objectForKey:@"images"] count] != 0 ) {
            self.hasNextPage = YES;
        } else {
            self.collectionView.contentInset = UIEdgeInsetsMake(0, 0, 148, 0);
        }
        [self.collectionView reloadData];
        [self.view.window.rootViewController dismissViewControllerAnimated:YES completion:nil];
        self.isLoading = NO;
    }];
}

- (IBAction)changeChart:(UIButton *)sender {
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UITableViewController *chartsController = [storyboard instantiateViewControllerWithIdentifier:@"ChartsController"];
    chartsController.modalPresentationStyle = UIModalPresentationPopover;
    chartsController.view.backgroundColor = [UIColor clearColor];
    chartsController.tableView.delegate = self;
    chartsController.tableView.layoutMargins = UIEdgeInsetsZero;
    self.resolver = chartsController.popoverPresentationController;
    self.resolver.delegate = self;
    self.resolver.sourceView = self.collectionView;
    [self.resolver setPermittedArrowDirections:UIPopoverArrowDirectionUp];
    self.resolver.sourceRect = [[self.collectionView visibleSupplementaryViewsOfKind:UICollectionElementKindSectionHeader]objectAtIndex:0].frame;
    [self.view.window.rootViewController presentViewController:chartsController animated:YES completion:nil];
}

- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    self.currentChart = (int)indexPath.row;
    titles = nil;
    subtitles = nil;
    images = nil;
    NSString *title;
    switch (self.currentChart) {
        case kTracks:
            title = @"TRACKS";
            break;
        case kArtists:
            title = @"ARTISTS";
            break;
        case kAlbums:
            title = @"ALBUMS";
            break;
        default:
            break;
    }
    [button setTitle:title forState:UIControlStateNormal];
    [self.collectionView setContentOffset:CGPointZero animated:YES];
    self.currentPage = 0;
    [self loadNextPage:self.currentPage];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (titles.count == 0 && subtitles.count == 0 && images.count == 0 && myError) {
        messageLabel = messageLabel ? : [[UILabel alloc]initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
        image = image ? : [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 50, 50)];
        messageLabel.text = [myError.userInfo objectForKey:NSLocalizedDescriptionKey];
        image.image = [UIImage imageNamed:@"Error"];
        UIView *background = [[UIView alloc]initWithFrame:CGRectMake(0, 50, self.collectionView.bounds.size.width, self.collectionView.bounds.size.height)];
        [background addSubview:messageLabel];
        [background addSubview:image];
        messageLabel.textColor = [UIColor darkGrayColor];
        messageLabel.numberOfLines = 2;
        messageLabel.textAlignment = NSTextAlignmentCenter;
        messageLabel.font = [UIFont systemFontOfSize:20 weight:UIFontWeightSemibold];
        messageLabel.center = background.center;
        image.center = CGPointMake(background.center.x, background.center.y - 60);
        self.collectionView.backgroundView = background;
    }else {
        self.collectionView.backgroundView = nil;
    }
    return 1;
}




@end
