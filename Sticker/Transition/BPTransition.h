//
//  BPTransition.h
//  BeerPal
//
//  Created by Q on 8/20/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ECSlidingViewController.h"
#import "BPDynamicTransition.h"

FOUNDATION_EXPORT NSString *const BPTransitionNameDefault;
FOUNDATION_EXPORT NSString *const BPTransitionNameDynamic;

@interface BPTransition : NSObject
{
    NSArray *_all;
}

@property (nonatomic, strong) BPDynamicTransition *dynamicTransition;
@property (nonatomic, strong, readonly) NSArray *all;

@end
