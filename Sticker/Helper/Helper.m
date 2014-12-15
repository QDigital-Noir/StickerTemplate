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

    return [[dictRoot allKeys] sortedArrayUsingSelector:@selector(localizedCaseInsensitiveCompare:)];
}

- (NSArray *)getStickerListWithKey:(NSString *)key
{
    // Read plist from bundle and get Root Dictionary out of it
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"StickerList" ofType:@"plist"]];
    
    return (NSArray *)[dictRoot objectForKey:key];
}

- (NSString *)getClientKeyWithKey:(NSString *)key
{
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"]];
    
    return dictRoot[key];
}

- (NSString *)getIAPIdentifierWithKey:(NSString *)key
{
    NSDictionary *dictRoot = [NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"Settings" ofType:@"plist"]];
    
    return dictRoot[@"IAP"][key];
}

#pragma mark - Update user default

- (void)updateUnlockedSticker:(BOOL)unlocked withKey:(NSString *)key
{
    NSUserDefaults *appDefault = [NSUserDefaults standardUserDefaults];
    [appDefault setObject:[NSNumber numberWithBool:unlocked] forKey:key];
    [appDefault synchronize];
}

- (BOOL)getUnlockedStickerWithKey:(NSString *)key
{
    NSUserDefaults *appDefault = [NSUserDefaults standardUserDefaults];
    BOOL isUnlock = [[appDefault objectForKey:key] boolValue];
    return isUnlock;
}

#pragma mark - HUD

- (void)showHUDWithView:(UIView *)view
{
    self.bouncingBalls = [[PQFBouncingBalls alloc] initLoaderOnView:view];
    self.bouncingBalls.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.0];
    self.bouncingBalls.center = CGPointMake(view.frame.size.width/2, (view.frame.size.height/2) - 64);
    [self.bouncingBalls show];
}

- (void)hideHUD
{
    [self.bouncingBalls remove];
}

/*
 for (NSString* family in [UIFont familyNames])
 {
 NSLog(@"%@", family);
 
 for (NSString* name in [UIFont fontNamesForFamilyName: family])
 {
 NSLog(@"  %@", name);
 }
 }
 
 #pragma mark - Image Helper
 
 - (UIImage *)imageByScalingProportionallyToSize:(CGSize)targetSize andImage:(UIImage *)sourceImage
 {
 UIImage *newImage = nil;
 
 CGSize imageSize = sourceImage.size;
 CGFloat width = imageSize.width;
 CGFloat height = imageSize.height;
 
 CGFloat targetWidth = targetSize.width;
 CGFloat targetHeight = targetSize.height;
 
 CGFloat scaleFactor = 0.0;
 CGFloat scaledWidth = targetWidth;
 CGFloat scaledHeight = targetHeight;
 
 CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
 
 if (CGSizeEqualToSize(imageSize, targetSize) == NO) {
 
 CGFloat widthFactor = targetWidth / width;
 CGFloat heightFactor = targetHeight / height;
 
 if (widthFactor < heightFactor)
 scaleFactor = widthFactor;
 else
 scaleFactor = heightFactor;
 
 scaledWidth  = width * scaleFactor;
 scaledHeight = height * scaleFactor;
 
 // center the image
 
 if (widthFactor < heightFactor) {
 thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
 } else if (widthFactor > heightFactor) {
 thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
 }
 }
 
 
 // this is actually the interesting part:
 
 UIGraphicsBeginImageContext(targetSize);
 
 CGRect thumbnailRect = CGRectZero;
 thumbnailRect.origin = thumbnailPoint;
 thumbnailRect.size.width  = scaledWidth;
 thumbnailRect.size.height = scaledHeight;
 
 [sourceImage drawInRect:thumbnailRect];
 
 newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 if(newImage == nil) NSLog(@"could not scale image");
 
 
 return newImage ;
 }
 
 - (UIImage *)mergeImage:(UIImage *)bottomImg withImage:(UIImage *)topImg withSize:(CGSize)size
 {
 UIImage *scaledTopImg = [self imageByScalingProportionallyToSize:size andImage:topImg];
 
 UIGraphicsBeginImageContext(scaledTopImg.size);
 CGContextRef ctx = UIGraphicsGetCurrentContext();
 CGContextTranslateCTM(ctx, scaledTopImg.size.width * 0.5f, scaledTopImg.size.height  * 0.5f);
 CGFloat angle = atan2(self.originalImageView.transform.b, self.originalImageView.transform.a);
 CGContextRotateCTM(ctx, angle);
 [scaledTopImg drawInRect:CGRectMake(- scaledTopImg.size.width * 0.5f, -(scaledTopImg.size.height  * 0.5f), scaledTopImg.size.width, scaledTopImg.size.height)];
 UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
 UIGraphicsEndImageContext();
 
 UIGraphicsBeginImageContext(bottomImg.size);
//    [bottomImg drawInRect:CGRectMake(0, 0, bottomImg.size.width, bottomImg.size.height)];
[newImage drawInRect:CGRectMake(_selectedView.frame.origin.x, _selectedView.frame.origin.y, newImage.size.width, newImage.size.height) blendMode:kCGBlendModeNormal alpha:1.0];
UIImage *newImage2 = UIGraphicsGetImageFromCurrentImageContext();
UIGraphicsEndImageContext();

return newImage2;
}

 */

@end
