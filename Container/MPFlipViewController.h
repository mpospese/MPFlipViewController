//
//  MPFlipViewController.h
//  MPFlipViewController
//
//  Created by Mark Pospesel on 6/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPTransitionEnumerations.h"

enum {
    MPFlipViewControllerOrientationHorizontal = 0,
    MPFlipViewControllerOrientationVertical = 1
};
typedef NSInteger MPFlipViewControllerOrientation;

/*enum {
    MPFlipViewControllerSpineLocationNone = 0, // Undefined
    MPFlipViewControllerSpineLocationMin = 1,  // Spine is at Left or Top
    MPFlipViewControllerSpineLocationMid = 2,  // Spine is in middle
    MPFlipViewControllerSpineLocationMax = 3   // Spine is at Right or Bottom
};
typedef NSInteger MPFlipViewControllerSpineLocation;*/

enum {
    MPFlipViewControllerDirectionForward,
    MPFlipViewControllerDirectionReverse
};
typedef NSInteger MPFlipViewControllerDirection; // For 'MPFlipViewControllerOrientationHorizontal', 'forward' is right-to-left, like pages in a book. For 'MPFlipViewControllerOrientationVertical', bottom-to-top, like pages in a wall calendar.

@interface MPFlipViewController : UIViewController

@property (nonatomic, readonly) MPFlipViewControllerOrientation orientation;
@property (nonatomic, readonly) UIViewController *viewController;

- (id)initWithOrientation:(MPFlipViewControllerOrientation)orientation;

- (void)setViewController:(UIViewController *)viewController direction:(MPFlipViewControllerDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end
