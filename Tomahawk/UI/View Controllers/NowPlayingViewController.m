//
//  NowPlayingViewController.m
//  Tomahawk
//
//  Created by Mark Bourke on 26/10/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NowPlayingViewController.h"
#import "UIKit+Tomahawk.h"
#import "CastIconButton.h"
#import "SLColorArt.h"

@interface NowPlayingViewController (){
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
    

    
}

- (void) extractColors {
    NSArray *buttons = @[_expandArrow, googleCast, _lyrics, _like, _queue, _share, _playPause, _next, _previous, _repeat, _shuffle];
    
    
    SLColorArt *colorArt = [[SLColorArt alloc]initWithImage:self.backgroundImageView.image];
    self.view.backgroundColor = colorArt.backgroundColor;
    UIColor *primaryColor = colorArt.primaryColor;
    UIColor *secondaryColor = colorArt.secondaryColor;
    
    for (UIButton *myButton in buttons) {
        myButton.imageView.image = [myButton.imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
        [myButton setImage:myButton.imageView.image forState:UIControlStateNormal];
        myButton.tintColor = primaryColor;
    }
    
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
