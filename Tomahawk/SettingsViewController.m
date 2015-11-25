//
//  SettingsViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 08/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "SettingsViewController.h"

@interface SettingsViewController ()

@end


@implementation SettingsViewController{
    NSMutableArray *settings;
    long long int selectedSegmentIndex;
    NSString *equaliserQuality;

}

-(IBAction)segmentedControlChangeValue:(UISegmentedControl*)segmentedControl{
    selectedSegmentIndex = segmentedControl.selectedSegmentIndex;
    switch (segmentedControl.selectedSegmentIndex) {
        case 0:
            //save value in CoreData and change thing to Low
            break;
        case 1:
            //save value in CoreData and change thing to Medium
            break;
        case 2:
            //save value in CoreData and change thing to Low
            break;
        default:
            break;
    }
    
}


- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.topItem.title = @"Settings";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 3;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    //Create settings objects and name them
    settings = [[NSMutableArray alloc]init];
    NSMutableArray *settingsNames = [[NSMutableArray alloc]initWithObjects:@"Rate the App", @"Tell Your Friends", @"Quality", @"Equaliser", @"Account", @"Sign Out", nil];
    for (NSString *name in settingsNames) {
        Settings *newSettings = [Settings new];
        newSettings.name = name;
        [settings addObject:newSettings];
    }
    UITableViewCell *cell;
    if (indexPath.row == 1 && indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"equaliserCell"];
    }else{
        cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    }
    [[cell textLabel] setTextColor:([UIColor whiteColor])];
    if (indexPath.row == 0 && indexPath.section == 0){
        cell.textLabel.text = [[settings objectAtIndex:0] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:0] valueForKey:@"name"]];
    }else if(indexPath.row == 1 && indexPath.section == 0){
        cell.textLabel.text = [[settings objectAtIndex:1] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:1] valueForKey:@"name"]];
    }else if (indexPath.row ==0 && indexPath.section == 1){
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        cell.textLabel.text = [[settings objectAtIndex:2] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:2] valueForKey:@"name"]];
        UISegmentedControl *streamingQuality = [[UISegmentedControl alloc]initWithItems:[NSArray arrayWithObjects:@"Low", @"Medium", @"High", nil]];
        streamingQuality.translatesAutoresizingMaskIntoConstraints = NO;
        streamingQuality.tintColor = [UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)];
        [cell addSubview:streamingQuality];
        [streamingQuality setWidth:50 forSegmentAtIndex:2];
        [streamingQuality setWidth:60 forSegmentAtIndex:1];
        [streamingQuality setWidth:50 forSegmentAtIndex:0];
        streamingQuality.selectedSegmentIndex = selectedSegmentIndex;
        [streamingQuality addTarget:self action:@selector(segmentedControlChangeValue:) forControlEvents:UIControlEventValueChanged];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:streamingQuality
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                              relatedBy:NSLayoutRelationEqual
                                                                 toItem:cell
                                                              attribute:NSLayoutAttributeTrailingMargin
                                                             multiplier:1
                                                               constant:-13.0]];
        [cell addConstraint:[NSLayoutConstraint constraintWithItem:streamingQuality
                                                         attribute:NSLayoutAttributeCenterY
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:cell
                                                         attribute:NSLayoutAttributeCenterY
                                                        multiplier:1
                                                          constant:0]];
    }else if (indexPath.row ==1 && indexPath.section == 1){
        cell.textLabel.text = [[settings objectAtIndex:3] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:3] valueForKey:@"name"]];
        UILabel *equaliserStatus = [[UILabel alloc]init];
        equaliserStatus.text = @"High";
    }else if (indexPath.row ==0 && indexPath.section == 2){
        cell.textLabel.text = [[settings objectAtIndex:4] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:4] valueForKey:@"name"]];
    }else if (indexPath.row ==1 && indexPath.section == 2){
        cell.textLabel.text = [[settings objectAtIndex:5] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:5] valueForKey:@"name"]];
    }
    if (indexPath.row == 0 && indexPath.section == 1) {
        cell.accessoryType = UITableViewCellAccessoryNone;
    }else{
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    return cell;
   
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 && indexPath.section == 2) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sign Out"
                                                                       message:@"Are you sure you want to sign out?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
            //Do Stuff
        }];
        [alert addAction:defaultAction];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
        return nil;
    }else if (indexPath.row == 0 && indexPath.section == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"]];
        return nil;
    }else if (indexPath.row == 0 && indexPath.section == 1){
        return nil;
    }else if(indexPath.row == 1 && indexPath.section == 0){
        NSString *myString = @"Tomahawk is good and stuff";
        NSArray *myArray = @[myString];
        UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:myArray applicationActivities:nil];
        [self presentViewController:share animated:YES completion:nil];
        return nil;
    }else{
    return indexPath;
    }
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
     InsideInsideSettingsViewController *iisvc = [segue destinationViewController];
     InsideSettingsViewController *svc = [segue destinationViewController];
 // Pass the selected object to the new view controller.
     NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
     if (currentCell.section == 1) {
         Settings *c = settings[currentCell.row+2];
         iisvc.currentSetting = c;
     }else{
         Settings *e = settings[currentCell.row+4];
         svc.currentSetting = e;
     }
     
 }



@end
