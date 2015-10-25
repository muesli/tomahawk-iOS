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
    //self.tableView.contentInset = UIEdgeInsetsMake(20.0f, 0.0f, 0.0f, 0.0f);
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
    settings = [[NSMutableArray alloc]init];
    Settings *settingsStar = [[Settings alloc]init];
    settingsStar.name = @"Rate the App";
    settingsStar.image = [UIImage imageNamed:@"Star"];
    [settings addObject:settingsStar];
    
    Settings *settingsShare = [[Settings alloc]init];
    settingsShare.name = @"Tell Your Friends";
    settingsShare.image = [UIImage imageNamed:@"Share"];
    [settings addObject:settingsShare];
    
    Settings *settingsQuality = [[Settings alloc]init];
    settingsQuality.name = @"Streaming Quality";
    settingsQuality.image = [UIImage imageNamed:@"Quality"];
    [settings addObject:settingsQuality];
    
    Settings *settingsEqualiser = [[Settings alloc]init];
    settingsEqualiser.name = @"Equaliser";
    settingsEqualiser.image = [UIImage imageNamed:@"Equaliser"];
    [settings addObject:settingsEqualiser];
    
    Settings *settingsAccount = [[Settings alloc]init];
    settingsAccount.name = @"Account";
    settingsAccount.image = [UIImage imageNamed:@"Account"];
    [settings addObject:settingsAccount];
    
    Settings *settingsSignOut = [[Settings alloc]init];
    settingsSignOut.name = @"Sign Out";
    settingsSignOut.image = [UIImage imageNamed:@"Sign Out"];
    [settings addObject:settingsSignOut];
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    [[cell textLabel] setTextColor:([UIColor whiteColor])];
    if (indexPath.row == 0 && indexPath.section == 0){[[cell textLabel] setText:settingsStar.name]; cell.imageView.image = settingsStar.image;}
    else if(indexPath.row == 1 && indexPath.section == 0){[[cell textLabel] setText:settingsShare.name];cell.imageView.image = settingsShare.image;}
    else if (indexPath.row ==0 && indexPath.section == 1){[[cell textLabel] setText:settingsQuality.name]; cell.imageView.image = settingsQuality.image;}
    else if (indexPath.row ==1 && indexPath.section == 1){[[cell textLabel] setText:settingsEqualiser.name];cell.imageView.image = settingsEqualiser.image;}
    else if (indexPath.row ==0 && indexPath.section == 2){[[cell textLabel] setText:settingsAccount.name]; cell.imageView.image = settingsAccount.image;}
    else if (indexPath.row ==1 && indexPath.section == 2){[[cell textLabel] setText:settingsSignOut.name];cell.imageView.image = settingsSignOut.image;}
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.backgroundColor = [UIColor colorWithRed:(37.0/255.0) green:(38.0/255.0) blue:(45.0/255.0) alpha:(1.0)];
    return cell;
   
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



@end
