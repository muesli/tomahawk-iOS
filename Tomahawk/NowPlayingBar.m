//
//  NowPlayingBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 21/11/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "NowPlayingBar.h"

@interface NowPlayingBar ()

@end

@implementation NowPlayingBar

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    CGRect targetRect = self.toolbar.frame;
    UITouch *touch = [touches anyObject];
    CGPoint touchLocation = [touch locationInView:self.view];
    
    if (CGRectContainsPoint(targetRect, touchLocation)) {
        [self performSegueWithIdentifier:@"showNowPlaying" sender:self];
    }
}




@end
