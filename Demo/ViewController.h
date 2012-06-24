//
//  ViewController.h
//  MPFlipViewController
//
//  Created by Mark Pospesel on 6/4/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MPFlipViewController.h"

@interface ViewController : UIViewController<MPFlipViewControllerDataSource>

@property (strong, nonatomic) MPFlipViewController *flipViewController;
@property (weak, nonatomic) IBOutlet UIView *frame;
@property (weak, nonatomic) IBOutlet UIView *frameShadow;
@property (weak, nonatomic) IBOutlet UIView *corkboard;
@property (weak, nonatomic) IBOutlet UIStepper *stepper;
- (IBAction)stepperValueChanged:(UIStepper *)sender;

@end
