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

@property (strong, nonatomic) IBOutlet UIButton *expandArrow;
@property (strong, nonatomic) IBOutlet UIButton *playPause;
@property (strong, nonatomic) IBOutlet UIButton *next;
@property (strong, nonatomic) IBOutlet UIButton *previous;
@property (strong, nonatomic) IBOutlet UIButton *shuffle;
@property (strong, nonatomic) IBOutlet UIButton *repeat;
@property (strong, nonatomic) IBOutlet UIButton *like;
@property (strong, nonatomic) IBOutlet UIButton *queue;
@property (strong, nonatomic) IBOutlet UIButton *share;
@property (strong, nonatomic) IBOutlet UIButton *lyrics;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImageView;
@property (strong, nonatomic) IBOutlet UIImageView *previousSongImageView;
@property (strong, nonatomic) IBOutlet UIImageView *currentSongImageView;
@property (strong, nonatomic) IBOutlet UIImageView *nextSongImageView;
@property (strong, nonatomic) IBOutlet UILabel *playlistTitle;
@property (strong, nonatomic) IBOutlet UILabel *playlistArtist;
@property (strong, nonatomic) IBOutlet UILabel *songTitle;
@property (strong, nonatomic) IBOutlet UILabel *songArtist;
@property (strong, nonatomic) IBOutlet UIProgressView *progress;

@property(nonatomic,retain) UIPopoverPresentationController *resolver;

- (void) extractColors;


@end
