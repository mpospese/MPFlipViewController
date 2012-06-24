//
//  ContentViewController.h
//  MPFlipViewController
//
//  Created by Mark Pospesel on 6/5/12.
//  Copyright (c) 2012 Mark Pospesel. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ContentViewController : UIViewController

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

// Empty view that holds the image and description
@property (weak, nonatomic) IBOutlet UIView *contentArea;

// White border for movie image (to give it a Polaroid look)
@property (weak, nonatomic) IBOutlet UIView *imageFrame;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (weak, nonatomic) IBOutlet UITextView *descriptionField;

// Index of the movie (1 - 3)
@property (assign, nonatomic) NSUInteger movieIndex;

@end
