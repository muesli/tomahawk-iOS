//
//  NowPlayingViewController.h
//  Tomahawk
//
//  Created by Mark Bourke on 26/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STKAudioPlayer.h"
#import "GoogleCast/GoogleCast.h"


@interface NowPlayingViewController : UIViewController <STKAudioPlayerDelegate, STKDataSourceDelegate, GCKDeviceScannerListener, UIPopoverPresentationControllerDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UIButton *expandArrow;
@property (weak, nonatomic) IBOutlet UIButton *playPause;
@property (weak, nonatomic) IBOutlet UIButton *next;
@property (weak, nonatomic) IBOutlet UIButton *previous;
@property (weak, nonatomic) IBOutlet UIButton *shuffle;
@property (weak, nonatomic) IBOutlet UIButton *repeat;
@property (weak, nonatomic) IBOutlet UIButton *like;
@property (weak, nonatomic) IBOutlet UIButton *queue;
@property (weak, nonatomic) IBOutlet UIButton *share;
@property (weak, nonatomic) IBOutlet UIButton *lyrics;
@property (weak, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (weak, nonatomic) IBOutlet UIImageView *previousSongImageView;
@property (weak, nonatomic) IBOutlet UIImageView *currentSongImageView;
@property (weak, nonatomic) IBOutlet UIImageView *nextSongImageView;
@property (weak, nonatomic) IBOutlet UILabel *playlistTitle;
@property (weak, nonatomic) IBOutlet UILabel *playlistArtist;
@property (weak, nonatomic) IBOutlet UILabel *songTitle;
@property (weak, nonatomic) IBOutlet UILabel *songArtist;
@property (weak, nonatomic) IBOutlet UIProgressView *progress;

@property(nonatomic,retain) UIPopoverPresentationController *resolver;


@end
