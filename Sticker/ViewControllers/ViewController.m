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
#import "FCVerticalMenu.h"

@interface ViewController () <ECSlidingViewControllerDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, FCVerticalMenuDelegate, UIDocumentInteractionControllerDelegate, MFMailComposeViewControllerDelegate, MFMessageComposeViewControllerDelegate, RevMobAdsDelegate, UIAlertViewDelegate>
{
    UIImage *img;
}

@property (nonatomic, strong) BPTransition *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;
@property (nonatomic, strong) CHTStickerView *selectedView;
@property (nonatomic, strong) UIImageView *originalImageView;
@property (nonatomic, strong) UIImageView *stickerImageView;
@property (nonatomic, strong) UIImage *chosenImage;
@property (nonatomic, strong) FCVerticalMenu *verticalMenu;

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
    
    if (AppDelegateAccessor.isFromStickers)
    {
        CGSize stickerSize = CGSizeMake(AppDelegateAccessor.stickerImage.size.width, AppDelegateAccessor.stickerImage.size.height);
        
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, stickerSize.width/5, stickerSize.height/5)];
        imageView.image = AppDelegateAccessor.stickerImage;

        CHTStickerView *stickerView = [[CHTStickerView alloc] initWithContentView:imageView];
        stickerView.center = CGPointMake(self.originalImageView.frame.size.width/2, self.originalImageView.frame.size.height/2);
        stickerView.delegate = self;
        stickerView.outlineBorderColor = [UIColor whiteColor];
        [stickerView setImage:[UIImage imageNamed:@"Close"] forHandler:CHTStickerViewHandlerClose];
        [stickerView setImage:[UIImage imageNamed:@"Rotate"] forHandler:CHTStickerViewHandlerRotate];
        [stickerView setImage:[UIImage imageNamed:@"Flip"] forHandler:CHTStickerViewHandlerFlip];
        [stickerView setHandlerSize:30];
        [self.originalImageView addSubview:stickerView];
        
        AppDelegateAccessor.isFromStickers = NO;
    }
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


#pragma mark - Sticker Delegate

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
    NSLog(@"HEY");
    CGPoint pointInWindow = [_selectedView convertPoint:_selectedView.frame.origin toView:self.originalImageView];
    NSLog(@"pointInWindow %@", NSStringFromCGPoint(pointInWindow));
}

- (void)stickerViewDidTap:(CHTStickerView *)stickerView
{
    self.selectedView = stickerView;

    if (!self.selectedView.showEditingHandlers)
    {
        self.selectedView.showEditingHandlers = YES;
        NSLog(@"YES");
    }
    else
    {
        self.selectedView.showEditingHandlers = NO;
        NSLog(@"NO");
    }
}

#pragma mark - Main Functions

- (void)openImagePicker
{
    
    if ([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary])
    {
        
        UIImagePickerController *picker = [[UIImagePickerController alloc]init];
        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
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
    // Setup Navigation Bar Button
    UIButton *btnLeft = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnLeft setFrame:CGRectMake(0, 0, 30, 30)];
    [btnLeft setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [btnLeft addTarget:self action:@selector(stickerTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnLeft = [[UIBarButtonItem alloc] initWithCustomView:btnLeft];
    [barBtnLeft setTintColor:[UIColor whiteColor]];
    [self.slidingViewController.navigationItem setLeftBarButtonItem:barBtnLeft];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 30, 30)];
    [btnRight setImage:[UIImage imageNamed:@"menu_icon"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(menuTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [barBtnRight setTintColor:[UIColor whiteColor]];
    [self.slidingViewController.navigationItem setRightBarButtonItem:barBtnRight];
    

    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Portrait"]];
    
//    [self test];
    
    [self configVerticalView];
    [self openImagePicker];
    
    self.originalImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height)];
    self.originalImageView.backgroundColor = [UIColor clearColor];
    self.originalImageView.userInteractionEnabled = YES;
    [self.view addSubview:self.originalImageView];
}

//- (void)test
//{
//    // Test
//    UIView *testView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 100)];
//    testView.backgroundColor = [UIColor redColor];
//    
//    CHTStickerView *stickerView = [[CHTStickerView alloc] initWithContentView:testView];
//    stickerView.center = self.view.center;
//    stickerView.delegate = self;
//    stickerView.outlineBorderColor = [UIColor blueColor];
//    [stickerView setImage:[UIImage imageNamed:@"Close"] forHandler:CHTStickerViewHandlerClose];
//    [stickerView setImage:[UIImage imageNamed:@"Rotate"] forHandler:CHTStickerViewHandlerRotate];
//    [stickerView setImage:[UIImage imageNamed:@"Flip"] forHandler:CHTStickerViewHandlerFlip];
//    [stickerView setHandlerSize:40];
//    [self.view addSubview:stickerView];
//    
//    UILabel *testLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 100, 50)];
//    testLabel.text = @"Test Label";
//    testLabel.textAlignment = NSTextAlignmentCenter;
//    
//    CHTStickerView *stickerView2 = [[CHTStickerView alloc] initWithContentView:testLabel];
//    stickerView2.center = CGPointMake(100, 100);
//    stickerView2.delegate = self;
//    [stickerView2 setImage:[UIImage imageNamed:@"Close"] forHandler:CHTStickerViewHandlerClose];
//    [stickerView2 setImage:[UIImage imageNamed:@"Rotate"] forHandler:CHTStickerViewHandlerRotate];
//    stickerView2.showEditingHandlers = NO;
//    [self.view addSubview:stickerView2];
//    
//    self.selectedView = stickerView;
//}

#pragma mark - UIImagePickerController Delegate

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    // user hit cancel
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    self.chosenImage = info[UIImagePickerControllerOriginalImage];

    float oldWidth = self.chosenImage.size.width;//self.view.frame.size.width;
    float scaleFactor = 280 / oldWidth;
    
    float newHeight = self.chosenImage.size.height * scaleFactor;//self.view.frame.size.height * scaleFactor;
    float newWidth = oldWidth * scaleFactor;
    
    CGRect rect = self.originalImageView.frame;
    rect.size.height = newHeight;
    rect.size.width = newWidth;
    
    self.originalImageView.frame = rect;
    self.originalImageView.center = CGPointMake(self.view.frame.size.width/2 , self.view.frame.size.height/2);
    self.originalImageView.image = self.chosenImage;
    self.originalImageView.contentMode = UIViewContentModeScaleAspectFill;
    
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

- (void)stickerTapped:(id)sender
{
    NSLog(@"sticker menu tapped!!");
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

- (void)menuTapped:(id)sendder
{
    if (_verticalMenu.isOpen)
    {
        return [_verticalMenu dismissWithCompletionBlock:nil];
    }
    
    [self.verticalMenu showFromNavigationBar:self.slidingViewController.navigationController.navigationBar
                                      inView:self.view];
    NSLog(@"menu tapped!!");
}

- (void)configVerticalView
{
    FCVerticalMenuItem *item1 = [[FCVerticalMenuItem alloc] initWithTitle:@"Save"
                                                             andIconImage:[UIImage imageNamed:@"save"]];
    item1.actionBlock = ^{
        NSLog(@"Saved!!!");
        
        UIGraphicsBeginImageContextWithOptions(self.originalImageView.bounds.size, self.originalImageView.opaque, 0.0);
        [self.originalImageView.layer renderInContext:UIGraphicsGetCurrentContext()];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        img = newImage;
        
        UIImageWriteToSavedPhotosAlbum(newImage, nil, nil, nil);
    };
    
    FCVerticalMenuItem *item2 = [[FCVerticalMenuItem alloc] initWithTitle:@"Facebook"
                                                             andIconImage:[UIImage imageNamed:@"facebook"]];
    item2.actionBlock = ^{
        NSLog(@"Facebook");
        FBPhotoParams *params = [[FBPhotoParams alloc] init];
        params.photos = @[img];
        
        [FBDialogs presentShareDialogWithPhotoParams:params
                                         clientState:nil
                                             handler:^(FBAppCall *call, NSDictionary *results, NSError *error) {
                                                 if (error) {
                                                     NSLog(@"Error: %@", error.description);
                                                 } else {
                                                     NSLog(@"Success!");
                                                 }
                                             }];
    };
    
    FCVerticalMenuItem *item3 = [[FCVerticalMenuItem alloc] initWithTitle:@"Twitter"
                                                             andIconImage:[UIImage imageNamed:@"twitter"]];
    item3.actionBlock = ^{
        NSLog(@"test element 3");
    };
    
    FCVerticalMenuItem *item4 = [[FCVerticalMenuItem alloc] initWithTitle:@"Instagram"
                                                             andIconImage:[UIImage imageNamed:@"instagram"]];
    item4.actionBlock = ^{
        NSLog(@"test element 4");
        NSURL *igImageHookupPath = [[NSURL alloc] initWithString:[NSString stringWithFormat:@"file://%@", imagePath]];
        self.dic.UTI = @"com.instagram.exclusivegram";
        self.dic = [self setupControllerWithURL:igImageHookupPath usingDelegate:self];
        self.dic = [UIDocumentInteractionController interactionControllerWithURL:igImageHookupPath];
        [self.dic presentOpenInMenuFromRect:self.view.frame inView:self.view animated:YES];
    };
    
    FCVerticalMenuItem *item5 = [[FCVerticalMenuItem alloc] initWithTitle:@"Email"
                                                             andIconImage:[UIImage imageNamed:@"mail"]];
    item5.actionBlock = ^{
        NSLog(@"test element 5");
    };
    
    FCVerticalMenuItem *item6 = [[FCVerticalMenuItem alloc] initWithTitle:@"Message"
                                                             andIconImage:[UIImage imageNamed:@"message"]];
    item6.actionBlock = ^{
        NSLog(@"test element 6");
    };
    
    FCVerticalMenuItem *item7 = [[FCVerticalMenuItem alloc] initWithTitle:@"Reset All"
                                                             andIconImage:[UIImage imageNamed:@"delete"]];
    item7.actionBlock = ^{
        NSLog(@"test element 7");
    };
    
    
    self.verticalMenu = [[FCVerticalMenu alloc] initWithItems:@[item1, item2, item3, item4, item5, item6, item7]];
    self.verticalMenu.appearsBehindNavigationBar = NO;
    self.verticalMenu.liveBlurTintColor = [UIColor blackColor];
}

#pragma mark - MFMailComposeViewController

- (void)openMail
{
    if ([MFMailComposeViewController canSendMail])
    {
        UIImage *myImage = img;
        NSData *imageData = UIImagePNGRepresentation(myImage);
        NSString *emailBody = @"Scary Photo Props";
        
        MFMailComposeViewController *mailer = [[MFMailComposeViewController alloc] init];
        mailer.mailComposeDelegate = self;
        [mailer setSubject:@"Scary Photo Props"];
        [mailer addAttachmentData:imageData mimeType:@"image/png" fileName:@"ScaryPhotoProps"];
        [mailer setMessageBody:emailBody isHTML:NO];
        [self presentViewController:mailer animated:YES completion:nil];
    }
    else
    {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Failure"
                                                        message:@"Your device doesn't support the composer sheet"
                                                       delegate:nil
                                              cancelButtonTitle:@"OK"
                                              otherButtonTitles: nil];
        [alert show];
    }
    
}

#pragma mark - MFMessageComposeViewController

- (void)showSMS
{
    
    if(![MFMessageComposeViewController canSendText])
    {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    UIImage *myImage = img;
    NSData *imageData = UIImagePNGRepresentation(myImage);
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController addAttachmentData:imageData typeIdentifier:@"public.data" filename:@"image.png"];
    [self.navigationController presentViewController:messageController animated:YES completion:nil];
}

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    NSLog(@"###### : %@",NSStringFromCGRect(controller.view.frame));
    
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - RevMob Delegate

- (void)revmobAdDidFailWithError:(NSError *)error
{
    NSLog(@"### REVMOB : Error : %@", error);
}

- (void)revmobAdDidReceive
{
    NSLog(@"### REVMOB : Ads recevieve");
}

- (void)revmobAdDisplayed
{
    NSLog(@"### REVMOB : Ads diplayed");
}

- (void)revmobUserClosedTheAd
{
    NSLog(@"### REVMOB : User closed ads");
}

- (void)revmobUserClickedInTheAd
{
    NSLog(@"### REVMOB : User cliked in adds");
}

@end
