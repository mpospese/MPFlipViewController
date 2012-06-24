//
//  MPFlipTransition.h
//  MPTransition (v1.1.0)
//
//  Created by Mark Pospesel on 5/15/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "MPFlipEnumerations.h"
#import "MPTransition.h"

@interface MPFlipTransition : MPTransition

#pragma mark - Properties

@property (assign, nonatomic) MPFlipStyle style;
@property (assign, nonatomic) CGFloat coveredPageShadowOpacity;
@property (assign, nonatomic) CGFloat flippingPageShadowOpacity;
@property (strong, nonatomic) UIColor *flipShadowColor;
@property (readonly, nonatomic) MPFlipAnimationStage stage;
@property (assign, nonatomic) CGFloat rubberbandMaximumProgress; // how far up rubberband animation should pull

// Whether all 4 halves of to and from views should be rendered as bitmap contexts, or 
// if it should attempt to use the views themselves (with masks) for the facing and reveal pages
// If YES, will always render all 4 page halves.  
// If NO, will attempt to only render the front and back page halves, and use the actual views to display the static page halves (facing and reveal).  
// In order for the destination view to be used for the reveal page, it must already be in the same view hierarchy as the source view or else completionAction must not be MPTransitionActionNone
@property (assign, nonatomic) BOOL shouldRenderAllViews; 

#pragma mark - init

- (id)initWithSourceView:(UIView *)sourceView destinationView:(UIView *)destinationView duration:(NSTimeInterval)duration style:(MPFlipStyle)style completionAction:(MPTransitionAction)action;

#pragma mark - Instance methods

// builds the layers for the flip animation
- (void)buildLayers;

// performs the flip animation
- (void)perform:(void (^)(BOOL finished))completion;

- (void)performRubberband:(void (^)(BOOL finished))completion;

// set view to any position within either half of the animation
// progress ranges from 0 (start) to 1 (complete) within each of 2 animation stages
- (void)setStage:(MPFlipAnimationStage)stage progress:(CGFloat)progress;

// moves layers into position for beginning of stage 2 (flip back page to vertical)
- (void)prepareForStage2;

- (void)animateFromProgress:(CGFloat)fromProgress shouldFallBack:(BOOL)shouldFallBack completion:(void (^)(BOOL finished))completion;

#pragma mark - Class methods

// For generic UIViewController transitions
+ (void)transitionFromViewController:(UIViewController *)fromController 
					toViewController:(UIViewController *)toController 
							duration:(NSTimeInterval)duration
							   style:(MPFlipStyle)style 
						  completion:(void (^)(BOOL finished))completion;

// For generic UIView transitions
+ (void)transitionFromView:(UIView *)fromView toView:(UIView *)toView duration:(NSTimeInterval)duration style:(MPFlipStyle)style transitionAction:(MPTransitionAction)action completion:(void (^)(BOOL finished))completion;

// To present a view controller modally
+ (void)presentViewController:(UIViewController *)viewControllerToPresent from:(UIViewController *)presentingController duration:(NSTimeInterval)duration style:(MPFlipStyle)style completion:(void (^)(BOOL finished))completion;

// To dismiss a modal view controller
+ (void)dismissViewControllerFromPresentingController:(UIViewController *)presentingController duration:(NSTimeInterval)duration style:(MPFlipStyle)style completion:(void (^)(BOOL finished))completion;

@end

#pragma mark - UIViewController extensions

// Convenience method extensions for UIViewController
@interface UIViewController(MPFlipTransition)

// present view controller modally with fold transition
// use like presentViewController:animated:completion:
- (void)presentViewController:(UIViewController *)viewControllerToPresent flipStyle:(MPFlipStyle)style completion:(void (^)(BOOL finished))completion;

// dismiss presented controller with fold transition
// use like dismissViewControllerAnimated:completion:
- (void)dismissViewControllerWithFlipStyle:(MPFlipStyle)style completion:(void (^)(BOOL finished))completion;

@end

#pragma mark - UINavigationController extensions

// Convenience method extensions for UINavigationController
@interface UINavigationController(MPFlipTransition)

//- (void)pushViewController:(UIViewController *)viewController animated:(BOOL)animated
- (void)pushViewController:(UIViewController *)viewController flipStyle:(MPFlipStyle)style;

//- (UIViewController *)popViewControllerAnimated:(BOOL)animated;
- (UIViewController *)popViewControllerWithFlipStyle:(MPFlipStyle)style;

@end
