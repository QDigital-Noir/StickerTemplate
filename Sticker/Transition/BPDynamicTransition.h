//
//  BPDynamicTransition.h
//  BeerPal
//
//  Created by Q on 8/20/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"
#import "ECPercentDrivenInteractiveTransition.h"

@interface BPDynamicTransition : NSObject <UIViewControllerInteractiveTransitioning, UIDynamicAnimatorDelegate, ECSlidingViewControllerDelegate>

@property (nonatomic, assign) ECSlidingViewController *slidingViewController;

- (void)handlePanGesture:(UIPanGestureRecognizer *)recognizer;

@end
