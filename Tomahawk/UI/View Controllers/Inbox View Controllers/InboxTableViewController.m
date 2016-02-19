//
//  InboxTableViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 08/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import "InboxTableViewController.h"
#import "UIKit+Tomahawk.h"

@interface InboxTableViewController (){
    NSMutableArray *messages;
}

@end

@implementation InboxTableViewController

- (IBAction)newMessage:(UIBarButtonItem *)button {
    
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.navigationController.tabBarController.tabBar.hidden = YES;
    self.navigationController.toolbar.hidden = YES;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName:[UIColor whiteColor]}]; //Force title to be white because it changes to orange sometimes
    self.tableView.tableFooterView = [UIView new];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemCompose target:self action:@selector(newMessage:)];
    [self getMessages:^(NSUInteger messageCount) {
        NSLog(@"message count is %ld", (long)messageCount);
        dispatch_sync(dispatch_get_main_queue(), ^{
            [self.tableView reloadData];
        });
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return messages.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    SWTableViewCell *cell = (SWTableViewCell *)[tableView dequeueReusableCellWithIdentifier:@"cell" forIndexPath:indexPath];
    cell.rightUtilityButtons = [self rightButtons];
    cell.textLabel.text = @"Title";
    cell.delegate = self;
    cell.detailTextLabel.text = @"Subtitle";
    return cell;
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:self.view.window.tintColor icon:[UIImage image:[UIImage imageNamed:@"Trash"] withColor:[UIColor whiteColor]]];
    return rightUtilityButtons;
}

- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index {
    [messages removeObjectAtIndex:index];
    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:index inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
}

- (void)getMessages:(void (^)(NSUInteger))completion {
    dispatch_queue_t get_messages = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0);
    dispatch_async(get_messages, ^{
        NSString *test = @"Test string";
        [NSThread sleepForTimeInterval:5];
        messages = [[NSMutableArray alloc]initWithObjects:test, nil];
        completion(messages.count);
    });
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/


-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    self.navigationController.tabBarController.tabBar.hidden = NO;
    self.navigationController.toolbar.hidden = NO;
}

@end
