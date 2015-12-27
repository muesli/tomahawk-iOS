//
//  SearchBar.m
//  Tomahawk
//
//  Created by Mark Bourke on 01/12/2015.
//  Copyright © 2015 Mark Bourke. All rights reserved.
//

#import "SearchBar.h"

@implementation SearchBar

-(void)setShowsCancelButton:(BOOL)showsCancelButton animated:(BOOL)animated{
    [super setShowsCancelButton:showsCancelButton animated:YES];
}
-(void)drawRect:(CGRect)rect{
    [super drawRect:rect];
    self.keyboardAppearance = UIKeyboardAppearanceDark;
}

@end
