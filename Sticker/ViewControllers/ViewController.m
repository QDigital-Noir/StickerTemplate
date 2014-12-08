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
{
    
}

@property (nonatomic, strong) BPTransition *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) CHTStickerView *selectedView;
@property (nonatomic, strong) UIImageView *originalImageView;
@property (nonatomic, strong) UIImageView *stickerImageView;

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
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    CGSize stickerSize = CGSizeMake(AppDelegateAccessor.stickerImage.size.width, AppDelegateAccessor.stickerImage.size.height);
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, stickerSize.width, stickerSize.height)];
    imageView.image = AppDelegateAccessor.stickerImage;

    CHTStickerView *stickerView = [[CHTStickerView alloc] initWithContentView:imageView];
    stickerView.center = self.view.center;
    stickerView.delegate = self;
    stickerView.outlineBorderColor = [UIColor blueColor];
    [stickerView setImage:[UIImage imageNamed:@"Close"] forHandler:CHTStickerViewHandlerClose];
    [stickerView setImage:[UIImage imageNamed:@"Rotate"] forHandler:CHTStickerViewHandlerRotate];
    [stickerView setImage:[UIImage imageNamed:@"Flip"] forHandler:CHTStickerViewHandlerFlip];
    [stickerView setHandlerSize:40];
    [self.view addSubview:stickerView];
    
    
//    UIImage *bottomImage = self.originalImageView.image;
//    
//    
//    float oldWidth = self.view.frame.size.width;
//    float scaleFactor = 280 / oldWidth;
//    
//    float newHeight = self.view.frame.size.height * scaleFactor;
//    float newWidth = oldWidth * scaleFactor;
//    
//    CGSize newSize = CGSizeMake(newWidth, newHeight);
//    UIGraphicsBeginImageContext(newSize);
//    
//    // Use existing opacity as is
//    [bottomImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    
//    // Apply supplied opacity if applicable
//    [AppDelegateAccessor.stickerImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height) blendMode:kCGBlendModeNormal alpha:0.8];
//    
//    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
//    
//    UIGraphicsEndImageContext();
//    
//    self.originalImageView.image = newImage;
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
    /*
    for (NSString* family in [UIFont familyNames])
    {
        NSLog(@"%@", family);
        
        for (NSString* name in [UIFont fontNamesForFamilyName: family])
        {
            NSLog(@"  %@", name);
        }
    }
    */
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 30, 30)];
    [btnRight setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [barBtnRight setTintColor:[UIColor whiteColor]];
    [self.slidingViewController.navigationItem setLeftBarButtonItem:barBtnRight];

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Portrait"]];
    
//    [self test];
    
    [self openImagePicker];
    
    self.originalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.originalImageView.backgroundColor = [UIColor redColor];
    [self.view addSubview:self.originalImageView];
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
    
    
    UIImage *chosenImage = info[UIImagePickerControllerOriginalImage];
//    CGSize newSize = CGSizeMake(100.0f, 100.0f);
//    UIGraphicsBeginImageContext(newSize);
//    [chosenImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)];
//    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
//    UIGraphicsEndImageContext();
    
    if (chosenImage.size.width > chosenImage.size.height)
    {
        // Landscape
        float oldWidth = self.view.frame.size.width;
        float scaleFactor = 200 / oldWidth;
        
        float newHeight = self.view.frame.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        
        CGRect rect = self.originalImageView.frame;
        rect.size.height = newWidth;
        rect.size.width = newHeight;
        
        self.originalImageView.frame = rect;
        self.originalImageView.center = CGPointMake(self.view.frame.size.width/2 , self.view.frame.size.height/2);
        self.originalImageView.image = chosenImage;
        self.originalImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    else
    {
        // Portrait
        float oldWidth = self.view.frame.size.width;
        float scaleFactor = 280 / oldWidth;
        
        float newHeight = self.view.frame.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        
        CGRect rect = self.originalImageView.frame;
        rect.size.height = newHeight;
        rect.size.width = newWidth;
        
        self.originalImageView.frame = rect;
        self.originalImageView.center = CGPointMake(self.view.frame.size.width/2 , self.view.frame.size.height/2);
        self.originalImageView.image = chosenImage;
        self.originalImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    
    // and dismiss the picker
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (UIImage *)imageWithImage:(UIImage *)sourceImage scaledToWidth:(float)i_width
{
    float oldWidth = sourceImage.size.width;
    float scaleFactor = i_width / oldWidth;
    
    float newHeight = sourceImage.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
    [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - Navigation Button methods

- (void)menuTapped:(id)sender
{
    NSLog(@"Menu tapped!!");
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

@end
