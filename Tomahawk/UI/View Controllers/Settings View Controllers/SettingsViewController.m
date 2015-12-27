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


@implementation SettingsViewController

-(IBAction)segmentedControlChangeValue:(UISegmentedControl*)segmentedControl{
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
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 1 && indexPath.section == 2) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"Sign Out" message:@"Are you sure you want to sign out?" preferredStyle:UIAlertControllerStyleAlert];
        [alert addAction:[UIAlertAction actionWithTitle:@"Sign Out" style:UIAlertActionStyleDestructive handler:^(UIAlertAction *action) {
            //Sign out
        }]];
        [alert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
        [self presentViewController:alert animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else if (indexPath.row == 0 && indexPath.section == 0) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:@"itms://itunes.apple.com/us/app/apple-store/id375380948?mt=8"]];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }else if(indexPath.row == 1 && indexPath.section == 0){
        UIActivityViewController *share = [[UIActivityViewController alloc]initWithActivityItems:@[@"Tomahawk is good and stuff"] applicationActivities:nil];
        [self presentViewController:share animated:YES completion:nil];
        [tableView deselectRowAtIndexPath:indexPath animated:YES];
    }
}



@end