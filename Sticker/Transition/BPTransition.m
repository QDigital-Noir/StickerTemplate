//
//  BPTransition.m
//  BeerPal
//
//  Created by Q on 8/20/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "BPTransition.h"

NSString * const BPTransitionNameDefault = @"Default";
NSString * const BPTransitionNameDynamic = @"UIKit Dynamics";

@implementation BPTransition

#pragma mark - Public

- (NSArray *)all
{
    if (_all) return _all;
    
    _all = @[@{ @"name" : BPTransitionNameDefault, @"transition" : [NSNull null]},
             @{ @"name" : BPTransitionNameDynamic, @"transition" : self.dynamicTransition }];
    
    return _all;
}

#pragma mark - Properties

- (BPDynamicTransition *)dynamicTransition {
    if (_dynamicTransition) return _dynamicTransition;
    
    _dynamicTransition = [[BPDynamicTransition alloc] init];
    
    return _dynamicTransition;
}

@end
