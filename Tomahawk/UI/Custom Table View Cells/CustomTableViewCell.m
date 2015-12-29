//
//  CustomTableViewCell.m
//  Tomahawk
//
//  Created by Mark Bourke on 28/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "CustomTableViewCell.h"

@implementation CustomTableViewCell

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

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if(self != nil) {
        self.imageColor = [UIColor whiteColor];
        self.customAccessoryView = NO;
    }
    return self;
}

- (void)awakeFromNib {
    self.imageView.image = [self.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [self.imageView setTintColor:self.imageColor];
    if (self.customAccessoryView) {
        UISegmentedControl *qualitySelector = [[UISegmentedControl alloc]initWithItems:@[@"Low", @"Medium", @"High"]];
        [qualitySelector setTintColor:[UIColor colorWithRed:(226.0/255.0) green:(56.0/255.0) blue:(83.0/255.0) alpha:(1.0)]];
        qualitySelector.frame = CGRectMake(0, 0, 177, 29);
        [qualitySelector setContentMode:UIViewContentModeScaleToFill];
        [qualitySelector addTarget:self action:@selector(segmentedControlChangeValue:) forControlEvents:UIControlEventValueChanged];
        qualitySelector.selectedSegmentIndex = 0;
        self.accessoryView = qualitySelector;
    }
}

@end
