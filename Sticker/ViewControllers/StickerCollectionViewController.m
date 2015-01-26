//
//  StickerCollectionViewController.m
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "StickerCollectionViewController.h"
#import "StickerCollectionViewCell.h"
#import "ViewController.h"

@interface StickerCollectionViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UIAlertViewDelegate, ECSlidingViewControllerDelegate>

@property (nonatomic, strong) BPTransition *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation StickerCollectionViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"Portrait"]];
    [[Helper sharedHelper] hideHUD];
    
    UIButton *btnRight = [UIButton buttonWithType:UIButtonTypeCustom];
    [btnRight setFrame:CGRectMake(0, 0, 30, 30)];
    [btnRight setImage:[UIImage imageNamed:@"icon_reload"] forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(reloadTapped:) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *barBtnRight = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    [barBtnRight setTintColor:[UIColor whiteColor]];
    [self.navigationItem setRightBarButtonItem:barBtnRight];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark - UICollectionView DataSource & Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.stickerArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *identifier = @"Cell";
    StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView dequeueReusableCellWithReuseIdentifier:identifier forIndexPath:indexPath];
    [cell setImageWithURL:self.stickerArray[indexPath.row][@"URL"]
                andIsPaid:[self.stickerArray[indexPath.row][@"isPaid"] boolValue]
              andCateName:self.cateName];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    BOOL isUnlock = [[Helper sharedHelper] getUnlockedStickerWithKey:self.cateName];
    BOOL isUnlockAll = [[Helper sharedHelper] getUnlockedStickerWithKey:@"All"];
    BOOL isPaid = [self.stickerArray[indexPath.row][@"isPaid"] boolValue];
    
    if (isUnlock || isUnlockAll)
    {
        NSLog(@"Unlocked %@", self.cateName);
        StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
        AppDelegateAccessor.stickerImage = cell.imageView.image;
        AppDelegateAccessor.isFromStickers = YES;
        [self.navigationController popViewControllerAnimated:YES];
    }
    else
    {
        if (isPaid)
        {
            NSLog(@"Need to unlock!!!!!!");
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Movie FX Stickers"
                                                            message:@"This stickers need to unlock."
                                                           delegate:self
                                                  cancelButtonTitle:@"No, Thank you"
                                                  otherButtonTitles:@"Unlock now!", nil];
            [alert show];
        }
        else
        {
            StickerCollectionViewCell *cell = (StickerCollectionViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
            AppDelegateAccessor.stickerImage = cell.imageView.image;
            AppDelegateAccessor.isFromStickers = YES;
            [self.navigationController popViewControllerAnimated:YES];
        }
    }
}

#pragma mark - UIAlertViewDelegate

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0)
    {
        NSLog(@"Not purchease");
    }
    else
    {
        NSLog(@"Buying : %@", [[Helper sharedHelper] getIAPIdentifierWithKey:self.cateName]);
        KVNProgressConfiguration *basicConfiguration = [[KVNProgressConfiguration alloc] init];
        basicConfiguration.backgroundType = KVNProgressBackgroundTypeSolid;
        basicConfiguration.fullScreen = YES;
        [KVNProgress showWithStatus:@"Loading..."];
        
        [PFPurchase buyProduct:[[Helper sharedHelper] getIAPIdentifierWithKey:self.cateName] block:^(NSError *error) {
            if (!error)
            {
                // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
                NSLog(@"Unlock %@ Success", self.cateName);
                [self.stickerCollectionView reloadData];
                [KVNProgress dismiss];
            }
            else
            {
                NSLog(@"IAP Error : %@", error.localizedDescription);
                [KVNProgress showErrorWithStatus:@"Error"];
            }
        }];
    }
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

- (IBAction)menuButtonTapped:(id)sender
{
    [self.slidingViewController anchorTopViewToRightAnimated:YES];
}

#pragma mark - Button Action

- (void)reloadTapped:(id)sender
{
    [self.stickerCollectionView reloadData];
}


@end
