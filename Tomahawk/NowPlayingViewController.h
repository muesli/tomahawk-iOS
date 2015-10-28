//
//  NowPlayingViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 26/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NowPlayingViewController : UIViewController

@property (strong, nonatomic) IBOutlet UIButton *expandArrow;
@property (strong, nonatomic) IBOutlet UIButton *googleCast;
@property (strong, nonatomic) IBOutlet UIButton *playPause;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UIButton *previous;
@property (strong, nonatomic) IBOutlet UIButton *shuffle;
@property (strong, nonatomic) IBOutlet UIButton *repeat;
@property (strong, nonatomic) IBOutlet UIButton *like;
@property (strong, nonatomic) IBOutlet UIButton *queue;
@property (strong, nonatomic) IBOutlet UIButton *share;
@property (strong, nonatomic) IBOutlet UIButton *lyrics;


@end
