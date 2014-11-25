//
//  ViewController.m
//  Sticker
//
//  Created by Q on 11/23/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "ViewController.h"
#import "BPDynamicTransition.h"
#import "BPTransition.h"

@interface ViewController () <ECSlidingViewControllerDelegate>
@property (nonatomic, strong) BPTransition *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) CHTStickerView *selectedView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Test
    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
    testView.backgroundColor = [UIColor redColor];
    
    CHTStickerView *stickerView = [[CHTStickerView alloc] initWithContentView:testView];
    stickerView.center = self.view.center;
    stickerView.delegate = self;
    stickerView.outlineBorderColor = [UIColor blueColor];
    [stickerView setImage:[UIImage imageNamed:@"Close"] forHandler:CHTStickerViewHandlerClose];
    [stickerView setImage:[UIImage imageNamed:@"Rotate"] forHandler:CHTStickerViewHandlerRotate];
    [stickerView setImage:[UIImage imageNamed:@"Flip"] forHandler:CHTStickerViewHandlerFlip];
    [stickerView setHandlerSize:40];
    [self.view addSubview:stickerView];
    
    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
    testLabel.text = @"Test Label";
    testLabel.textAlignment = NSTextAlignmentCenter;
    
    CHTStickerView *stickerView2 = [[CHTStickerView alloc] initWithContentView:testLabel];
    stickerView2.center = CGPointMake(100, 100);
    stickerView2.delegate = self;
    [stickerView2 setImage:[UIImage imageNamed:@"Close"] forHandler:CHTStickerViewHandlerClose];
    [stickerView2 setImage:[UIImage imageNamed:@"Rotate"] forHandler:CHTStickerViewHandlerRotate];
    stickerView2.showEditingHandlers = NO;
    [self.view addSubview:stickerView2];
    
    self.selectedView = stickerView;
    
    // Setup Reveal
    [[Helper sharedHelper] setupRevealWithNavigationVC:self.navigationController
                                            withTransition:self.transitions
                                            withECSliderVC:self.slidingViewController
                                               andGuesture:self.dynamicTransitionPanGesture];
    self.slidingViewController.panGesture.enabled = YES;
    
    NSLog(@"CATEGORY : %@", [[Helper sharedHelper] getStickerCategory]);
    NSLog(@"LIST : %@", [[Helper sharedHelper] getStickerListWithKey:@"War"]);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Properties

- (BPTransition *)transitions
{
    if (_transitions) return _transitions;
    
    _transitions = [[BPTransition alloc] init];
    
    return _transitions;
}

- (UIPanGestureRecognizer *)dynamicTransitionPanGesture
{
    if (_dynamicTransitionPanGesture) return _dynamicTransitionPanGesture;
    
    _dynamicTransitionPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self.transitions.dynamicTransition action:@selector(handlePanGesture:)];
    
    return _dynamicTransitionPanGesture;
}


#pragma mark - Functions

- (void)setSelectedView:(CHTStickerView *)selectedView
{
    if (_selectedView != selectedView)
    {
        if (_selectedView)
        {
            _selectedView.showEditingHandlers = NO;
        }
        _selectedView = selectedView;
        
        if (_selectedView)
        {
            _selectedView.showEditingHandlers = YES;
            [_selectedView.superview bringSubviewToFront:_selectedView];
        }
    }
}

- (void)stickerViewDidBeginMoving:(CHTStickerView *)stickerView
{
    self.selectedView = stickerView;
}

- (void)stickerViewDidTap:(CHTStickerView *)stickerView
{
    self.selectedView = stickerView;
}

/*
- (void)createImagePicker {
    
    imagePicker = [[UIImagePickerController alloc] init];
    imagePicker.sourceType = UIImagePickerControllerSourceTypeCamera;
    
    imagePicker.mediaTypes = [NSArray arrayWithObject:@"public.movie"];
    imagePicker.cameraCaptureMode = UIImagePickerControllerCameraCaptureModeVideo;
    
    imagePicker.allowsEditing = NO;
    imagePicker.showsCameraControls = NO;
    
    // transform preview to full screen
    CGSize screenSize = [[UIScreen mainScreen] bounds].size;
    
    // iOS is going to calculate a size which constrains the 4:3 aspect ratio
    // to the screen size. We're basically mimicking that here to determine
    // what size the system will likely display the image at on screen.
    // NOTE: screenSize.width may seem odd in this calculation - but, remember,
    // the devices only take 4:3 images when they are oriented *sideways*.
    float cameraAspectRatio = 4.0 / 3.0;
    float imageWidth = floorf(screenSize.width * cameraAspectRatio);
    float scale = ceilf((screenSize.height / imageWidth) * 10.0) / 10.0;
    
    imagePicker.cameraViewTransform = CGAffineTransformMakeScale(scale, scale);
    
    imagePicker.delegate = self;
}
 */

@end
