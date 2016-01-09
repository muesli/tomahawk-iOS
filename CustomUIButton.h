//
//  CustomUIButton.h
//  Tomahawk
//
//  Created by Mark Bourke on 09/01/2016.
//  Copyright © 2016 Mark Bourke. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    AXWireButtonHighlightStyleSimple = 0,
    AXWireButtonHighlightStyleFilled,
} AXWireButtonHighlightStyle;

IB_DESIGNABLE
@interface CustomUIButton : UIButton

@property (nonatomic) AXWireButtonHighlightStyle highlightStyle;
@property (nonatomic) IBInspectable CGFloat borderWidth;
@property (nonatomic) IBInspectable CGFloat cornerRadius;
@property (nonatomic, getter = isEmphasized) BOOL emphasized;

@end
