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
    self.navigationController.navigationBar.topItem.title = @"Settings";
    self.navigationController.navigationBar.barStyle = UIStatusBarStyleLightContent;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

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



@end
