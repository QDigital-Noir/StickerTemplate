//
//  Helper.h
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "BPDynamicTransition.h"
#import "BPTransition.h"

@interface Helper : NSObject
+ (instancetype)sharedHelper;
- (void)setupRevealWithNavigationVC:(UINavigationController *)navVC
                     withTransition:(BPTransition *)transitions
                     withECSliderVC:(ECSlidingViewController *)slidingVC
                        andGuesture:(UIPanGestureRecognizer *)transitionPanGesture;
- (NSArray *)getStickerCategory;
- (NSArray *)getStickerListWithKey:(NSString *)key;
- (void)showHUDWithView:(UIView *)view;
- (void)hideHUD;
@end
