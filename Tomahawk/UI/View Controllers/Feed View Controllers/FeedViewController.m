//
//  FeedViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 19/09/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "FeedViewController.h"
#import <JavaScriptCore/JavaScriptCore.h>
#import "GenresCollectionViewController.h"
#import "SearchTableViewController.h"
#import "LibraryCollectionViewController.h"


@interface FeedViewController ()

@end

@implementation FeedViewController

- (IBAction)showResults:(UIBarButtonItem *)sender {
    SearchTableViewController *searchView = [[SearchTableViewController alloc]initWithNibName:@"SearchTableViewController" bundle:nil];
    UINavigationController *navCtlr = [[UINavigationController alloc]initWithRootViewController:searchView];
    UISearchController *searchController = [[UISearchController alloc]initWithSearchResultsController:navCtlr];
    [searchController setDefinesPresentationContext:YES];
    searchController.delegate = searchView;
    searchController.searchResultsUpdater = searchView;
    searchView.definesPresentationContext = YES;
    searchController.searchBar.delegate = searchView;
    navCtlr.definesPresentationContext = YES;
    searchView.searchController = searchController;
    searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    [self presentViewController:searchController animated:YES completion:nil];
}

-(IBAction)segmentedValueChanged:(id)sender {
    if (self.segmentedControl.selectedIndex == 0) {
        NSLog(@"First");
    } else if (self.segmentedControl.selectedIndex == 1){
        NSLog(@"Second");
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.segmentedControl = [[ADVSegmentedControl alloc]initWithFrame:CGRectMake(0, 0, 250, 25)];
    self.segmentedControl.layer.borderWidth = 1;
    self.segmentedControl.items = @[@"FEED", @"MY MUSIC"];
    self.segmentedControl.font = [UIFont systemFontOfSize:10 weight:UIFontWeightBold];
    self.segmentedControl.borderColor = [UIColor colorWithWhite:1.0 alpha:0.3];
    self.segmentedControl.selectedIndex = 0;
    [self.segmentedControl addTarget:self action:@selector(segmentedValueChanged:) forControlEvents:UIControlEventValueChanged];
    self.navigationItem.titleView = self.segmentedControl;
    
    
    JSContext *context = [[JSContext alloc]init];
    NSString* filePath = [[NSBundle mainBundle] pathForResource:@"Tomahawk" ofType:@"js"];
    NSString* filePath1 = [[NSBundle mainBundle] pathForResource:@"Soundcloud" ofType:@"js"];
    NSString* filePath2 = [[NSBundle mainBundle] pathForResource:@"rsvp-latest.min" ofType:@"js"];
    NSString *Tomahawk = [NSString stringWithContentsOfFile:filePath encoding:NSUTF8StringEncoding error:nil];
    NSString *resolver = [NSString stringWithContentsOfFile:filePath1 encoding:NSUTF8StringEncoding error:nil];
    NSString *rsvp = [NSString stringWithContentsOfFile:filePath2 encoding:NSUTF8StringEncoding error:nil];
    [context evaluateScript:rsvp];
    [context evaluateScript:Tomahawk];
    [context evaluateScript:resolver];
    JSValue *exceptuion = [context exception];
    JSValue *cock = [[[context objectForKeyedSubscript:@"Tomahawk"]objectForKeyedSubscript:@"resolver"]objectForKeyedSubscript:@"instance"];
    id SC = [cock toObject];
    JSValue *function = context[@"Tomahawk.PluginManager.registerPlugin"];
    JSValue *object = [function callWithArguments:@[@"resolver", SC]];
    NSLog(@"Object is %d", [object toInt32]);
    
    
    UITableViewController *songsController1 = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
    songsController1.title = @"CHARTS";
    LibraryCollectionViewController *playlistsController = [[LibraryCollectionViewController alloc]initWithNibName:@"LibraryCollectionViewController" bundle:nil];
    playlistsController.title = @"FOR YOU";
    GenresCollectionViewController *songsController = [[GenresCollectionViewController alloc]initWithNibName:@"GenresCollectionViewController" bundle:nil];
    songsController.title = @"RADIO";
    
    NSArray *controllerArray = @[songsController, playlistsController, songsController1];
    NSDictionary *parameters = @{
                                 CAPSPageMenuOptionScrollMenuBackgroundColor: [UIColor whiteColor],
                                 CAPSPageMenuOptionViewBackgroundColor: [UIColor colorWithRed:242.0/255.0 green:242.0/255.0 blue:242.0/255.0 alpha:1.0],
                                 CAPSPageMenuOptionSelectionIndicatorColor: [UIColor clearColor],
                                 CAPSPageMenuOptionMenuItemFont: [UIFont systemFontOfSize:11 weight:UIFontWeightSemibold],
                                 CAPSPageMenuOptionScrollAnimationDurationOnMenuItemTap : @(300),
                                 CAPSPageMenuOptionMenuHeight: @(40.0),
                                 CAPSPageMenuOptionMenuItemWidth: @(65),
                                 CAPSPageMenuOptionCenterMenuItems: @(YES),
                                 CAPSPageMenuOptionSelectedMenuItemLabelColor : [UIColor blackColor],
                                 CAPSPageMenuOptionUnselectedMenuItemLabelColor: [UIColor lightGrayColor]
                                 };
    self.pageMenu.delegate = self;
    self.pageMenu = [[CAPSPageMenu alloc] initWithViewControllers:controllerArray frame:CGRectMake(0.0, 64.0, self.view.frame.size.width, self.view.frame.size.height) options:parameters];
    [self.view addSubview:_pageMenu.view];
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}



@end
