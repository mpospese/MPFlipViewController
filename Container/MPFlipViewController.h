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

@protocol MPFlipViewControllerDelegate, MPFlipViewControllerDataSource;

@interface MPFlipViewController : UIViewController<UIGestureRecognizerDelegate>

@property (nonatomic, readonly) MPFlipViewControllerOrientation orientation; // horizontal or vertical
@property (nonatomic, readonly) UIViewController *viewController;
@property (nonatomic, readonly) NSArray *gestureRecognizers;
@property (nonatomic, assign) id <MPFlipViewControllerDelegate> delegate;
@property (nonatomic, assign) id <MPFlipViewControllerDataSource> dataSource; // If nil, user gesture-driven navigation will be disabled.

// designated initializer
- (id)initWithOrientation:(MPFlipViewControllerOrientation)orientation;

// flip to a new page
- (void)setViewController:(UIViewController *)viewController direction:(MPFlipViewControllerDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion;

@end

@protocol MPFlipViewControllerDelegate<NSObject>

@optional
// handle this to be notified when page flip animations have finished
- (void)flipViewController:(MPFlipViewController *)flipViewController didFinishAnimating:(BOOL)finished previousViewController:(UIViewController *)previousViewController transitionCompleted:(BOOL)completed;

// handle this and return the desired orientation (horizontal or vertical) for the new interface orientation
// called when MPFlipViewController handles willRotateToInterfaceOrientation:duration: callback
- (MPFlipViewControllerOrientation)flipViewController:(MPFlipViewController *)flipViewController orientationForInterfaceOrientation:(UIInterfaceOrientation)orientation;

@end

@protocol MPFlipViewControllerDataSource 
@required

- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerBeforeViewController:(UIViewController *)viewController; // get previous page, or nil for none
- (UIViewController *)flipViewController:(MPFlipViewController *)flipViewController viewControllerAfterViewController:(UIViewController *)viewController; // get next page, or nil for none

@end

// Notifications
// All of the following notifications have an `object' that is the sending MPFipViewController.

// The following notification has a userInfo key "MPAnimationFinished" with an NSNumber (bool, YES/NO) value,
// an "MPTransitionCompleted" key with an NSNumber (bool, YES/NO) value,
// an "MPPreviousController" key with a UIViewController value, and
// an "MPNewController" key with a UIViewController value (will be NSNull for rubber-banding past first/last controller)
#define MPAnimationFinishedKey @"MPAnimationFinished"
#define MPTransitionCompletedKey @"MPTransitionCompleted"
#define MPPreviousControllerKey @"MPPreviousController"
#define MPNewControllerKey @"MPNewController"
extern NSString *MPFlipViewControllerDidFinishAnimatingNotification;

