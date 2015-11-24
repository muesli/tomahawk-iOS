//
//  InsideSettingsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 09/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "InsideSettingsViewController.h"

@interface InsideSettingsViewController (){
    NSMutableArray *settings;
}

@end

@implementation InsideSettingsViewController

-(void)viewWillAppear:(BOOL)animated{
    //Deselect tableview cell before view loads
    [self.tableView deselectRowAtIndexPath:self.tableView.indexPathForSelectedRow animated:YES];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = _currentSetting.name;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    settings = [[NSMutableArray alloc]init];
    NSMutableArray *settingsNames = [[NSMutableArray alloc]initWithObjects:@"Connect", @"Advanced", @"Info", nil];
    for (NSString *name in settingsNames) {
        Settings *newSettings = [Settings new];
        newSettings.name = name;
        [settings addObject:newSettings];
    }
    UITableViewCell *connectCell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    UITableViewCell *advancedCell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    UITableViewCell *infoCell = [tableView dequeueReusableCellWithIdentifier:@"settingsCell"];
    switch (indexPath.section) {
        case 0:
            connectCell.textLabel.text = [[settings objectAtIndex:0] valueForKey:@"name"];
            connectCell.textLabel.textColor = [UIColor whiteColor];
            connectCell.imageView.image = [UIImage imageNamed:[[settings objectAtIndex:0] valueForKey:@"name"]];
            return connectCell;
        case 1:
            advancedCell.textLabel.text = [[settings objectAtIndex:1] valueForKey:@"name"];
            advancedCell.textLabel.textColor = [UIColor whiteColor];
            advancedCell.imageView.image = [UIImage imageNamed:[[settings objectAtIndex:1] valueForKey:@"name"]];
            return advancedCell;
        case 2:
            infoCell.textLabel.text = [[settings objectAtIndex:2] valueForKey:@"name"];
            infoCell.textLabel.textColor = [UIColor whiteColor];
            infoCell.imageView.image = [UIImage imageNamed:[[settings objectAtIndex:2] valueForKey:@"name"]];
            return infoCell;
        default:
            return nil;
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    InsideSettingsViewController *svc = [segue destinationViewController];
    // Pass the selected object to the new view controller.
    NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
    if (currentCell.section == 0){
        Settings *selectedCell = settings[currentCell.row];
        svc.currentSetting = selectedCell;
    }
    else if(currentCell.section == 1){
        Settings *selectedCell = settings[currentCell.row+1];
        svc.currentSetting = selectedCell;
    }
    else{
        Settings *selectedCell = settings[currentCell.row+2];
        svc.currentSetting = selectedCell;
    }
    
}



@end
