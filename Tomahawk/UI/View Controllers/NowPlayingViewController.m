//
//  NowPlayingViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 26/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "CCColorCube.h"
#import "MyAdditions.h"
#import "CastIconButton.h"

@interface NowPlayingViewController (){
    UIColor *primaryColor, *secondaryColor;
    CastIconButton *googleCast;
}

@end

@implementation NowPlayingViewController


-(IBAction)buttonTouched:(UIButton *)sender{
    if (sender == _playPause) {
        STKAudioPlayer *player = [STKAudioPlayer new];
        [player playURL:[NSURL URLWithString:@"http://www.stephaniequinn.com/Music/Allegro%20from%20Duet%20in%20C%20Major.mp3"]];
    }else if (sender == self.expandArrow){
        [self dismissViewControllerAnimated:YES completion:nil];
    } else if (sender == googleCast) {
        UITableViewController *controller = [[UITableViewController alloc]initWithStyle:UITableViewStylePlain];
        controller.tableView.frame = CGRectMake(0, 0, 100, 100);
        controller.tableView.delegate = self;
        controller.tableView.dataSource = self;
        controller.navigationController.navigationBarHidden = TRUE;
        UINavigationController *destNav = [[UINavigationController alloc] initWithRootViewController:controller];
        destNav.navigationBarHidden = TRUE;
        controller.preferredContentSize = CGSizeMake(150 , 100);
        destNav.modalPresentationStyle = UIModalPresentationPopover;
        self.resolver = destNav.popoverPresentationController;
        self.resolver.delegate = self;
        self.resolver.sourceView = self.view;
        self.resolver.sourceRect = sender.frame;
        [self.resolver setPermittedArrowDirections:UIPopoverArrowDirectionUp];
        [self presentViewController:destNav animated:YES completion:nil];
        [self scanForDevicesWithPassiveScan:NO];
    }
}

-(void)deviceDidComeOnline:(GCKDevice *)device {
    NSLog(@"Chromecast has come online with name:%@", device.friendlyName);
    [googleCast setStatus:CIBCastAvailable];
}
-(void)viewDidLoad {
    [super viewDidLoad];
    self.backgroundImageView.image = [UIImage imageNamed:@"PlaceholderSongs"];
    googleCast = googleCast ? : ({
        CastIconButton *myButton = [CastIconButton buttonWithFrame:CGRectMake(CGRectGetMaxX(self.view.frame) - 36, self.expandArrow.frame.origin.y, 22, 22)];
        [myButton setStatus:CIBCastUnavailable];
        [myButton addTarget:self action:@selector(buttonTouched:) forControlEvents:UIControlEventTouchUpInside];
        [self.view addSubview:myButton];
        [self scanForDevicesWithPassiveScan:YES];
        myButton;
    });
    NSArray *myArray = @[self.currentSongImageView, self.previousSongImageView, self.nextSongImageView];
    for (UIImageView *imageView in myArray) {
        imageView.layer.cornerRadius = 5.0;
        imageView.layer.masksToBounds = YES;
    }
    
    //Get Dark Colors from Background
    CCColorCube *colorCube = [[CCColorCube alloc] init];
    myArray = [colorCube extractColorsFromImage:self.backgroundImageView.image flags:CCAvoidWhite & CCOnlyBrightColors count:2];
    
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
    
    
    NSArray *buttons = @[_expandArrow, googleCast, _lyrics, _like, _queue, _share, _playPause, _next, _previous, _repeat, _shuffle]; //Create array of all buttons
    
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

-(void)scanForDevicesWithPassiveScan:(BOOL) passiveScan {
    GCKDeviceScanner *scanner = [[GCKDeviceScanner alloc]initWithFilterCriteria:[GCKFilterCriteria criteriaForAvailableApplicationWithID:@"9C7DD1A8"]];
    [scanner addListener:self];
    scanner.passiveScan = passiveScan;
    [scanner startScan];
    while ([scanner scanning]) {
        NSLog(@"Scanning");
    }
    NSLog(@"Devices are %@", [scanner devices]);
}

-(void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cast = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    if (!cast) {
        cast = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:@"cell"];
    }
    return cast;
}
- (UIModalPresentationStyle) adaptivePresentationStyleForPresentationController: (UIPresentationController * ) controller {
    return UIModalPresentationNone;
}


@end
