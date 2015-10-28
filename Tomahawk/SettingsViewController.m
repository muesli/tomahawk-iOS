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
    NSMutableArray *settingsNames = [[NSMutableArray alloc]initWithObjects:@"Rate the App", @"Tell Your Friends", @"Streaming Quality", @"Equaliser", @"Account", @"Sign Out", nil];
    for (NSString *name in settingsNames) {
        Settings *newSettings = [Settings new];
        newSettings.name = name;
        [settings addObject:newSettings];
    }
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [[cell textLabel] setTextColor:([UIColor whiteColor])];
    if (indexPath.row == 0 && indexPath.section == 0){
        cell.textLabel.text = [[settings objectAtIndex:0] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:0] valueForKey:@"name"]];
    }
    else if(indexPath.row == 1 && indexPath.section == 0){
        cell.textLabel.text = [[settings objectAtIndex:1] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:1] valueForKey:@"name"]];
    }
    else if (indexPath.row ==0 && indexPath.section == 1){
        cell.textLabel.text = [[settings objectAtIndex:2] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:2] valueForKey:@"name"]];
    }
    else if (indexPath.row ==1 && indexPath.section == 1){
        cell.textLabel.text = [[settings objectAtIndex:3] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:3] valueForKey:@"name"]];
    }
    else if (indexPath.row ==0 && indexPath.section == 2){
        cell.textLabel.text = [[settings objectAtIndex:4] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:4] valueForKey:@"name"]];
    }
    else if (indexPath.row ==1 && indexPath.section == 2){
        cell.textLabel.text = [[settings objectAtIndex:5] valueForKey:@"name"];
        cell.imageView.image = [UIImage imageNamed: [[settings objectAtIndex:5] valueForKey:@"name"]];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:(37.0/255.0) green:(38.0/255.0) blue:(45.0/255.0) alpha:(1.0)];
    return cell;
   
}


-(NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 && indexPath.section == 2) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sign Out"
                                                                       message:@"Are you sure you want to sign out?"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDefault handler:^(UIAlertAction * action) {
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            
        }];
        UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:^(UIAlertAction *cancel){
            [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
            //Do Stuff
        }];
        [alert addAction:defaultAction];
        [alert addAction:cancel];
        
        [self presentViewController:alert animated:YES completion:nil];
    }
    return indexPath;
}

 #pragma mark - Navigation
 
 - (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
 // Get the new view controller using [segue destinationViewController].
     Inside_Settings *svc = [segue destinationViewController];
 // Pass the selected object to the new view controller.
     NSIndexPath *currentCell = [[self tableView]indexPathForSelectedRow];
     if (currentCell.section == 0){
      Settings *c = settings[currentCell.row];
         svc.currentSetting = c;
     }
     else if(currentCell.section == 1){
         Settings *d = settings[currentCell.row+2];
         svc.currentSetting = d;
     }
    else{
         Settings *e = settings[currentCell.row+4];
         svc.currentSetting = e;
     }
     
 }

//    Settings *settingsStar = [[Settings alloc]init];
//    settingsStar.name = @"Rate the App";
//    settingsStar.image = [UIImage imageNamed:@"Star"];
//    [settings addObject:settingsStar];
//
//    Settings *settingsShare = [[Settings alloc]init];
//    settingsShare.name = @"Tell Your Friends";
//    settingsShare.image = [UIImage imageNamed:@"Share"];
//    [settings addObject:settingsShare];
//
//    Settings *settingsQuality = [[Settings alloc]init];
//    settingsQuality.name = @"Streaming Quality";
//    settingsQuality.image = [UIImage imageNamed:@"Quality"];
//    [settings addObject:settingsQuality];
//
//    Settings *settingsEqualiser = [[Settings alloc]init];
//    settingsEqualiser.name = @"Equaliser";
//    settingsEqualiser.image = [UIImage imageNamed:@"Equaliser"];
//    [settings addObject:settingsEqualiser];
//
//    Settings *settingsAccount = [[Settings alloc]init];
//    settingsAccount.name = @"Account";
//    settingsAccount.image = [UIImage imageNamed:@"Account"];
//    [settings addObject:settingsAccount];
//
//    Settings *settingsSignOut = [[Settings alloc]init];
//    settingsSignOut.name = @"Sign Out";
//    settingsSignOut.image = [UIImage imageNamed:@"Sign Out"];
//    [settings addObject:settingsSignOut];


@end
