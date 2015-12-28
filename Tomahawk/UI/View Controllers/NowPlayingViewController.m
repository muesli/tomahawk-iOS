//
//  NowPlayingViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 26/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NowPlayingViewController.h"

@interface NowPlayingViewController (){
    UIColor *primaryColor, *secondaryColor;
}

@end

@implementation NowPlayingViewController

-(IBAction)buttonTouched:(UIButton *)sender{
    if (sender == _playPause) {
        //set Play button to pause icon if it is play and visa versa
        [_playPause setImage:[UIImage imageNamed:@"Pause"] forState:UIControlStateNormal];
        NSError *error;
        self.player = [[AVAudioPlayer alloc]initWithContentsOfURL:[NSURL URLWithString:nil] error:&error];
        [self.player play];
        
        
    }
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
     NSLog(@"Current song image view width and height are %f", self.currentSongImageView.frame.size.width);
}

- (void)viewDidLoad {
    [super viewDidLoad];
   
    
    _backgroundImageView.image = [UIImage imageNamed:@"blurExample"];
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]];
    effectView.frame = CGRectMake(0, 0, self.view.frame.size.width+10, self.view.frame.size.height);
    [_backgroundImageView addSubview:effectView];
    [self.view sendSubviewToBack:self.backgroundImageView];
    
    NSArray *myArray = @[self.currentSongImageView, self.previousSongImageView, self.nextSongImageView];
    for (UIImageView *imageView in myArray) {
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
    }
    
    //Get Dark Colors from Background
    CCColorCube *colorCube = [[CCColorCube alloc] init];
    myArray = [colorCube extractColorsFromImage:_backgroundImageView.image flags:CCOrderByBrightness &CCAvoidWhite & CCOnlyBrightColors count:2];
    
    //Set Primary and Secondary Colors from Results
    primaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:0]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:0]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:0]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
    
    secondaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:1]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:1]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:1]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
    
//    CGFloat threshhold = 0.02+0.02+0.02; //Create Threshold for Checking if Colors are too Dark
    
    //Check if colors are too dark. If they are, get only bright colors from background and update primary and secondary colors
//    if (([[[myArray objectAtIndex:0]valueForKey:@"redComponent"] floatValue]+[[[myArray objectAtIndex:0]valueForKey:@"greenComponent"] floatValue] + [[[myArray objectAtIndex:0]valueForKey:@"blueComponent"] floatValue]) <= threshhold) {
//        myArray = [colorCube extractBrightColorsFromImage:_backgroundImageView.image avoidColor:self.view.backgroundColor count:2];
//        primaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:0]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:0]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:0]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
//        secondaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:1]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:1]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:1]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
//    }
    
    
    NSArray *buttons = @[_expandArrow, _googleCast, _lyrics, _like, _queue, _share, _playPause, _next, _previous, _repeat, _shuffle]; //Create array of all buttons
    
    //Set Button Properties
    for (UIButton *myButton in buttons) {
        myButton.imageView.image = [myButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [myButton setImage:myButton.imageView.image forState:UIControlStateNormal];
        myButton.tintColor = primaryColor;
    }
    
    
    //Set text properties
    _playlistTitle.textColor = primaryColor;
    _playlistArtist.textColor = secondaryColor;
    _songTitle.textColor = primaryColor;
    _songArtist.textColor = secondaryColor;
    
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
