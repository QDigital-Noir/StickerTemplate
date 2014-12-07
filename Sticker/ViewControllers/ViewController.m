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

@interface ViewController () <ECSlidingViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate>
@property (nonatomic, strong) BPTransition *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) CHTStickerView *selectedView;

@end

@implementation ViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    // Setup Reveal
    [[Helper sharedHelper] setupRevealWithNavigationVC:self.navigationController
                                            withTransition:self.transitions
                                            withECSliderVC:self.slidingViewController
                                               andGuesture:self.dynamicTransitionPanGesture];
    self.slidingViewController.panGesture.enabled = YES;
    [self setupScreen];
    [[Helper sharedHelper] showHUD];
}

- (void)didReceiveMemoryWarning
{
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

#pragma mark - Main Functions

- (void)openImagePicker
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera])
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        picker.delegate = self;
        picker.allowsEditing = NO;
        
        NSArray *mediaTypes = [[NSArray alloc]initWithObjects:(NSString *)kUTTypeImage, nil];
        
        picker.mediaTypes = mediaTypes;
        
        [self presentViewController:picker animated:YES completion:nil];
        
    }
    else
    {
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"I'm afraid there's no camera on this device!" delegate:nil cancelButtonTitle:@"Dang!" otherButtonTitles:nil, nil];
        [alertView show];
    }
}

- (void)setupScreen
{
    self.navigationController.title = @"Action Sticker Props";
    
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
}

- (void)test
{
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
}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // user hit cancel
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    
//    // grab our movie URL
//    NSURL *chosenMovie = [info objectForKey:UIImagePickerControllerMediaURL];
//    
//    // save it to the documents directory
//    NSURL *fileURL = [self grabFileURL:@"video.mov"];
//    NSData *movieData = [NSData dataWithContentsOfURL:chosenMovie];
//    [movieData writeToURL:fileURL atomically:YES];
//    
//    // save it to the Camera Roll
//    UISaveVideoAtPathToSavedPhotosAlbum([chosenMovie path], nil, nil, nil);
    
    // and dismiss the picker
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

@end
