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

- (IBAction)likeButtonTouched:(id)sender{
    [sender setEnabled:NO];
    [sender setHidden:YES];
    [_likeSelected setEnabled:YES];
    [_likeSelected setHidden:NO];
    _likeSelected.imageView.image = [_likeSelected.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
    [_likeSelected setImage:[UIImage imageNamed:@"Like Selected"] forState:UIControlStateNormal];
    _likeSelected.tintColor = secondaryColor;
    //Follow Code
}

- (IBAction)likeSelectedButtonTouched:(id)sender {
    [sender setEnabled:NO];
    [sender setHidden:YES];
    [_like setEnabled:YES];
    [_like setHidden:NO];
    //Unfollow Code
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [_likeSelected setEnabled:NO];
    [_likeSelected setHidden:YES];
    
    _backgroundImageView.image = [UIImage imageNamed:@"blurExample6"]; //Set Background Image
    UIVisualEffect *effect = [UIBlurEffect effectWithStyle:UIBlurEffectStyleLight]; //Create Blur Effect
    UIVisualEffectView *effectView = [[UIVisualEffectView alloc] initWithEffect:effect];
    effectView.frame = _backgroundImageView.bounds;
    [_backgroundImageView addSubview:effectView];//Add Blur to Background
    
    //Get Dark Colors from Background
    CCColorCube *colorCube = [[CCColorCube alloc] init];
    //NSArray *myArray = [colorCube extractDarkColorsFromImage:_backgroundImageView.image avoidColor:self.view.backgroundColor count:2]; //Return 2 Dark Colors and add to array myArray
    NSArray *myArray = [colorCube extractColorsFromImage:_backgroundImageView.image flags:CCOnlyDistinctColors & CCOrderByBrightness & CCAvoidWhite count:2];
    //Set Primary and Secondary Colors from Results
    primaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:0]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:0]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:0]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
    
    secondaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:1]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:1]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:1]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
    
    CGFloat threshhold = 0.02+0.02+0.02; //Create Threshold for Checking if Colors are too Dark
    
    //Check if colors are too dark. If they are, get only bright colors from background and update primary and secondary colors
    if (([[[myArray objectAtIndex:0]valueForKey:@"redComponent"] floatValue]+[[[myArray objectAtIndex:0]valueForKey:@"greenComponent"] floatValue] + [[[myArray objectAtIndex:0]valueForKey:@"blueComponent"] floatValue]) <= threshhold) {
        myArray = [colorCube extractBrightColorsFromImage:_backgroundImageView.image avoidColor:self.view.backgroundColor count:2];
        primaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:0]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:0]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:0]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
        secondaryColor = [UIColor colorWithRed:[[[myArray objectAtIndex:1]valueForKey:@"redComponent"] floatValue] green:[[[myArray objectAtIndex:1]valueForKey:@"greenComponent"] floatValue] blue:[[[myArray objectAtIndex:1]valueForKey:@"blueComponent"] floatValue] alpha:1.0f];
    }
    
    
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
    
#pragma mark - Auto Layout Constraints
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_queue
                                                           attribute:NSLayoutAttributeCenterX
                                                           relatedBy:NSLayoutRelationEqual
                                                              toItem:self.view
                                                           attribute:NSLayoutAttributeCenterX
                                                          multiplier:1.25
                                                            constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_share
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:0.7
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_next
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:1.4
                                                           constant:0.0]];
    
    [self.view addConstraint:[NSLayoutConstraint constraintWithItem:_previous
                                                          attribute:NSLayoutAttributeCenterX
                                                          relatedBy:NSLayoutRelationEqual
                                                             toItem:self.view
                                                          attribute:NSLayoutAttributeCenterX
                                                         multiplier:0.6
                                                           constant:0.0]];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
@end
