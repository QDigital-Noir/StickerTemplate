//
//  Helper.m
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "Helper.h"

@interface Helper ()

@property (nonatomic, strong) PQFBouncingBalls *bouncingBalls;

@end

@implementation Helper

+ (instancetype)sharedHelper
{
    static Helper *_sharedHelper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedHelper = [[Helper alloc] init];
    });
    
    return _sharedHelper;
}

- (void)setupRevealWithNavigationVC:(UINavigationController *)navVC
                     withTransition:(BPTransition *)transitions
                     withECSliderVC:(ECSlidingViewController *)slidingVC
                        andGuesture:(UIPanGestureRecognizer *)transitionPanGesture
{
    navVC.navigationBarHidden = YES;
    transitions.dynamicTransition.slidingViewController = slidingVC;
    
    NSDictionary *transitionData = transitions.all[0];
    id<ECSlidingViewControllerDelegate> transition = transitionData[@"transition"];
    if (transition == (id)[NSNull null]) {
        slidingVC.delegate = nil;
    } else {
        slidingVC.delegate = transition;
    }
    
    NSString *transitionName = transitionData[@"name"];
    if ([transitionName isEqualToString:BPTransitionNameDynamic]) {
        slidingVC.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGestureCustom;
        slidingVC.customAnchoredGestures = @[transitionPanGesture];
        [navVC.view removeGestureRecognizer:slidingVC.panGesture];
        [navVC.view addGestureRecognizer:transitionPanGesture];
    } else {
        slidingVC.topViewAnchoredGesture = ECSlidingViewControllerAnchoredGestureTapping | ECSlidingViewControllerAnchoredGesturePanning;
        slidingVC.customAnchoredGestures = @[];
        [navVC.view removeGestureRecognizer:transitionPanGesture];
        [navVC.view addGestureRecognizer:slidingVC.panGesture];
    }
}

- (NSArray *)getStickerCategory
{
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StickerList" ofType:@"plist"]];

    return [dictRoot allKeys];
}

- (NSArray *)getStickerListWithKey:(NSString *)key
{
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StickerList" ofType:@"plist"]];
    
    return (NSArray *)[dictRoot objectForKey:key];
}

#pragma mark - HUD

- (void)showHUD
{
    UIWindow *mainWindow = [[[UIApplication sharedApplication] delegate] window];
    
    self.bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:mainWindow];
    self.bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.0];
    self.bouncingBalls.center = CGPointMake(mainWindow.frame.size.width/2, (mainWindow.frame.size.height/2));
    [self.bouncingBalls show];
}

- (void)hideHUD
{
    [self.bouncingBalls remove];
}

@end
