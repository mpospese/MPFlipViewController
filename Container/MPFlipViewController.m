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
@property (nonatomic, assign) BOOL gesturesAdded;
@property (nonatomic, assign, getter = isAnimating) BOOL animating;
@property (nonatomic, assign) MPFlipViewControllerDirection direction;

@end

@implementation MPFlipViewController

@synthesize dataSource = _dataSource;

@synthesize orientation = _orientation;
@synthesize childViewController = _childViewController;
@synthesize gesturesAdded = _gesturesAdded;
@synthesize animating = _animating;
@synthesize direction = _direction;

- (id)initWithOrientation:(MPFlipViewControllerOrientation)orientation
{
    self = [super init];
    if (self) {
        // Custom initialization
		_orientation = orientation;
		_direction = MPFlipViewControllerDirectionForward;
		_gesturesAdded = NO;
		_animating = NO;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
	
	[self addGestures];
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

#pragma mark - private instance methods

- (void)addGestures
{
	if ([self gesturesAdded])
		return;
	
	// Add our swipe gestures
	BOOL isHorizontal = ([self orientation] == MPFlipViewControllerOrientationHorizontal);
	UISwipeGestureRecognizer *left = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipeNext:)];
	left.direction = isHorizontal? UISwipeGestureRecognizerDirectionLeft : UISwipeGestureRecognizerDirectionUp;
	[self.view addGestureRecognizer:left];
	
	UISwipeGestureRecognizer *right = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipePrev:)];
	right.direction = isHorizontal? UISwipeGestureRecognizerDirectionRight : UISwipeGestureRecognizerDirectionDown;
	[self.view addGestureRecognizer:right];
	
	UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
	[self.view addGestureRecognizer:tap];
		
	[self setGesturesAdded:YES];
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
		[self setAnimating:YES];
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
									  [self setAnimating:NO];
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

#pragma mark - Gesture handlers

- (void)handleTap:(UITapGestureRecognizer *)gestureRecognizer
{
	if ([self isAnimating])
		return;
	
	CGPoint tapPoint = [gestureRecognizer locationInView:self.view];
	BOOL isHorizontal = [self orientation] == MPFlipViewControllerOrientationHorizontal;
	CGFloat value = isHorizontal? tapPoint.x : tapPoint.y;
	CGFloat dimension = isHorizontal? self.view.bounds.size.width : self.view.bounds.size.height;
	NSLog(@"Tap to flip");
	if (value <= MARGIN)
		[self gotoPreviousPage];
	else if (value >= dimension - MARGIN)
		[self gotoNextPage];
}

- (void)handleSwipePrev:(UIGestureRecognizer *)gestureRecognizer
{
	if ([self isAnimating])
		return;
	
	NSLog(@"Swipe to previous page");
	[self gotoPreviousPage];
}

- (void)handleSwipeNext:(UIGestureRecognizer *)gestureRecognizer
{
	if ([self isAnimating])
		return;
	
	NSLog(@"Swipe to next page");
	[self gotoNextPage];
}

#pragma mark - Private instance methods

- (void)gotoPreviousPage
{
	if (![self dataSource])
		return;
	
	UIViewController *previousController = [[self dataSource] flipViewController:self viewControllerBeforeViewController:[self viewController]];
	if (!previousController)
		return;
	
	[self setViewController:previousController direction:MPFlipViewControllerDirectionReverse animated:YES completion:nil];
}

- (void)gotoNextPage
{
	if (![self dataSource])
		return;
	
	UIViewController *nextController = [[self dataSource] flipViewController:self viewControllerAfterViewController:[self viewController]];
	if (!nextController)
		return;
	
	[self setViewController:nextController direction:MPFlipViewControllerDirectionForward animated:YES completion:nil];	
}

@end
