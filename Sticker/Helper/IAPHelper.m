//
//  IAPHelper.m
//  Sticker
//
//  Created by Q on 11/23/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "IAPHelper.h"

@implementation IAPHelper

+ (instancetype)sharedIAPHelper
{
    static IAPHelper *_sharedIAPHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedIAPHelper = [[IAPHelper alloc] init];
    });
    
    return _sharedIAPHelper;
}

- (void)buyItemsWithIdentifier:(NSString *)productIdentifier
{
    // Use the product identifier from iTunes to register a handler.
    [PFPurchase addObserverForProduct:productIdentifier
                                block:^(SKPaymentTransaction *transaction) {
        // Write business logic that should run once this product is purchased.
        //isPro = YES;
    }];
}

@end
