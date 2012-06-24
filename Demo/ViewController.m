//
//  ViewController.m
//  MPFlipViewController
//
//  Created by Mark Pospesel on 6/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import "ViewController.h"
#import "ContentViewController.h"
#import <QuartzCore/QuartzCore.h>

#define CONTENT_IDENTIFIER @"ContentViewController"
#define FRAME_MARGIN	60
@interface ViewController ()

@property (assign, nonatomic) int previousIndex;

@end

@implementation ViewController
@synthesize frame = _frame;
@synthesize frameShadow = _frameShadow;

@synthesize flipViewController = _flipViewController;
@synthesize corkboard = _corkboard;
@synthesize stepper = _stepper;
@synthesize previousIndex = _previousIndex;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
	
	self.previousIndex = (int)self.stepper.value;
	
	// Configure the page view controller and add it as a child view controller.
	self.flipViewController = [[MPFlipViewController alloc] initWithOrientation:MPFlipViewControllerOrientationHorizontal];
	
	// Set the page view controller's bounds using an inset rect so that self's view is visible around the edges of the pages.
	BOOL hasFrame = self.frame != nil;
	CGRect pageViewRect = self.view.bounds;
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
	{
		pageViewRect = CGRectInset(pageViewRect, 20 + (hasFrame? FRAME_MARGIN : 0), 20 + (hasFrame? FRAME_MARGIN : 0));
		pageViewRect.size.height -= self.stepper.bounds.size.height + (hasFrame? 0 : 10);
		self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleWidth;
	}
	else
	{
		pageViewRect = CGRectMake((self.view.bounds.size.width - 600)/2, (self.view.bounds.size.height - 600)/2, 600, 600);
		self.flipViewController.view.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
	}
	self.flipViewController.view.frame = pageViewRect;
	[self addChildViewController:self.flipViewController];
	[self.view addSubview:self.flipViewController.view];
	[self.flipViewController didMoveToParentViewController:self];
	
	[self.flipViewController setViewController:[self contentView] direction:MPFlipViewControllerDirectionForward animated:NO completion:nil];
		
	[self.corkboard setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern - Corkboard"]]];	
	if (self.frame)
	{
		[self.frame setBackgroundColor:[UIColor colorWithPatternImage:[UIImage imageNamed:@"Pattern - Apple Wood"]]];
	}
}

- (void)viewDidUnload
{
    [self setStepper:nil];
	[self setCorkboard:nil];
	[self setFrame:nil];
	[self setFrameShadow:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
	return YES;
}

- (IBAction)stepperValueChanged:(UIStepper *)sender {
	// TODO: figure forward backward
	sender.userInteractionEnabled = NO;
	int previousIndex = self.previousIndex;
	BOOL isForward = sender.value > previousIndex;
	if ((sender.value == sender.minimumValue && previousIndex == sender.maximumValue) || (sender.value == sender.maximumValue && previousIndex == sender.minimumValue))
		isForward = !isForward;
	[self.flipViewController setViewController:[self contentView] direction:isForward? MPFlipViewControllerDirectionForward : MPFlipViewControllerDirectionReverse animated:YES completion:^(BOOL finished) {
		sender.userInteractionEnabled = YES;
		self.previousIndex = (int)self.stepper.value;
	}];
}

- (ContentViewController *)contentView
{
	return [self contentViewWithIndex:(int)[self.stepper value]];
}

- (NSString *)storyboardName
{
	// fetch the appropriate storyboard name depending on platform
	if ([[UIDevice currentDevice] userInterfaceIdiom] == UIUserInterfaceIdiomPhone)
		return @"MainStoryboard_iPhone";
	else
		return @"MainStoryboard_iPad";
}

- (ContentViewController *)contentViewWithIndex:(int)index
{
	UIStoryboard *storyboard = [UIStoryboard storyboardWithName:[self storyboardName] bundle:nil];
	ContentViewController *page = [storyboard instantiateViewControllerWithIdentifier:CONTENT_IDENTIFIER];
	page.movieIndex = index;
	page.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
	return page;
}

@end
