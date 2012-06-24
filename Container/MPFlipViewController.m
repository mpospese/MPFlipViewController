//
//  MPFlipViewController.m
//  MPFlipViewController
//
//  Created by Mark Pospesel on 6/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "MPFlipViewController.h"
#import	"MPFlipTransition.h"

#define MARGIN	44
#define SWIPE_THRESHOLD	125.0f
#define SWIPE_ESCAPE_VELOCITY 650.0f

@interface MPFlipViewController ()

@property (nonatomic, assign) MPFlipViewControllerOrientation orientation;
@property (nonatomic, strong) UIViewController *childViewController;
@property (nonatomic, assign) MPFlipViewControllerDirection direction;

@end

@implementation MPFlipViewController

@synthesize orientation = _orientation;
@synthesize childViewController = _childViewController;
@synthesize direction = _direction;

- (id)initWithOrientation:(MPFlipViewControllerOrientation)orientation
{
    self = [super init];
    if (self) {
        // Custom initialization
		_orientation = orientation;
		_direction = MPFlipViewControllerDirectionForward;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return YES;
}

#pragma mark - Properties

- (UIViewController *)viewController
{
	return [self childViewController];
}

#pragma mark - public Instance methods

- (void)setViewController:(UIViewController *)viewController direction:(MPFlipViewControllerDirection)direction animated:(BOOL)animated completion:(void (^)(BOOL finished))completion
{
	UIViewController *previousController = [self viewController];
	
	BOOL isForward = (direction == MPFlipViewControllerDirectionForward);
	BOOL isVertical = ([self orientation] == MPFlipViewControllerOrientationVertical);
	[[viewController view] setFrame:[self.view bounds]];
	[self addChildViewController:viewController]; // this calls [viewController willMoveToParentViewController:self] for us
	[self setChildViewController:viewController];
	[previousController willMoveToParentViewController:nil];
	
	if (animated && previousController)
	{
		[MPFlipTransition transitionFromView:previousController.view 
									  toView:viewController.view 
									duration:0.5 
									   style:((isForward? MPFlipStyleDefault : MPFlipStyleDirectionBackward) | (isVertical? MPFlipStyleOrientationVertical : MPFlipStyleDefault)) 
							transitionAction:MPTransitionActionAddRemove 
								  completion:^(BOOL finished) {
									  // final set of containment notifications
									  [viewController didMoveToParentViewController:self];
									  if (completion)
										  completion(finished);
									  [previousController removeFromParentViewController]; // this calls [previousController didMoveToParentViewController:nil] for us
								  }];
	}
	else 
	{
		[[self view] addSubview:[viewController view]];
		[[previousController view] removeFromSuperview];
		[viewController didMoveToParentViewController:self];
		if (completion)
			completion(YES);
		[previousController removeFromParentViewController]; // this calls [previousController didMoveToParentViewController:nil] for us
	}
}

@end
