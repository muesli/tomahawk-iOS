/*
 * This file is part of the StickyHeaderFlowLayout package.
 * (c) James Tang <j@jamztang.com>
 *
 * For the full copyright and license information, please view the LICENSE
 * file that was distributed with this source code.
 */

#import <UIKit/UIKit.h>

//! Project version number for StickyHeaderFlowLayout.
FOUNDATION_EXPORT double StickyHeaderFlowLayoutVersionNumber;

//! Project version string for StickyHeaderFlowLayout.
FOUNDATION_EXPORT const unsigned char StickyHeaderFlowLayoutVersionString[];

// Import All public headers
#import "StickyHeaderFlowLayoutAttributes.h"

#pragma mark -

extern NSString *const StickyHeaderParallaxHeader;

@interface StickyHeaderFlowLayout : UICollectionViewFlowLayout

@property (nonatomic) CGSize parallaxHeaderReferenceSize;
@property (nonatomic) CGSize parallaxHeaderMinimumReferenceSize;
@property (nonatomic) BOOL parallaxHeaderAlwaysOnTop;
@property (nonatomic) BOOL disableStickyHeaders;

@end
