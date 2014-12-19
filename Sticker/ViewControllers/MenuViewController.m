//
//  MenuViewController.m
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "MenuViewController.h"
#import "MenuTableViewCell.h"
#import "UIViewController+ECSlidingViewController.h"
#import "StickerCollectionViewController.h"
#import "BPTransition.h"

@interface MenuViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UINavigationController *transitionsNavigationController;
@property (nonatomic, strong) IBOutlet UITableView *menuTableView;
@property (nonatomic, strong) NSMutableArray *categoryArray;
@property (nonatomic, strong) BPTransition *transitions;
@property (nonatomic, strong) UIPanGestureRecognizer *dynamicTransitionPanGesture;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;
    
    //Setup category menu.
    self.categoryArray = [NSMutableArray arrayWithArray:[[Helper sharedHelper] getStickerCategory]];
    
    //Setup table view.
    if (!IS_IPHONE_5)
    {
        self.menuTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 480 - 64);
    }
    else if (IS_IPHONE_5)
    {
        self.menuTableView.frame = CGRectMake(0, 0, self.view.frame.size.width, 568 - 64);
    }
}

- (void)didReceiveMemoryWarning {
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

#pragma mark - UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    if (section == 0)
    {
        return 3;
    }
    else
    {
        return self.categoryArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *cellIdentifier = @"MenuCell";
    MenuTableViewCell *cell;
    if(cell == nil)
    {
        cell = [[MenuTableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    
    if (indexPath.section == 0)
    {
        [self configureMenuCell:cell forRowAtIndexPath:indexPath];
    }
    else
    {
        [self configureCell:cell forRowAtIndexPath:indexPath];
    }
    
    return cell;
}

- (void)configureCell:(MenuTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setupCellLayoutWithCategoryName:self.categoryArray[indexPath.row]];
}

- (void)configureMenuCell:(MenuTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == 0)
    {
        [cell setupCellLayoutWithCategoryName:@"Unlock All & Remove Ads"];
    }
    else if (indexPath.row == 1)
    {
        [cell setupCellLayoutWithCategoryName:@"Restore All"];
    }
    else
    {
        [cell setupCellLayoutWithCategoryName:@"More Apps"];
    }
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0)
    {
        if (indexPath.row == 0)
        {
            NSLog(@"Unlock All Tapped");
            [PFPurchase buyProduct:@"com.intencemedia.moviefxstickers.unlockall" block:^(NSError *error) {
                if (!error)
                {
                    // Run UI logic that informs user the product has been purchased, such as displaying an alert view.
                    NSLog(@"Unlock All Success");
                }
                else
                {
                    NSLog(@"IAP Error : %@", error.localizedDescription);
                }
            }];
        }
        else if (indexPath.row == 1)
        {
            NSLog(@"Restore Tapped");
            [PFPurchase restore];
        }
        else
        {
            NSString *iTunesLink = @"https://itunes.apple.com/us/artist/intence-media/id592330573";
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:iTunesLink]];
        }
    }
    else
    {
        StickerCollectionViewController *stickerCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StickerCollectionViewController"];
        stickerCollectionVC.stickerArray = [[Helper sharedHelper] getStickerListWithKey:self.categoryArray[indexPath.row]];
        stickerCollectionVC.cateName = self.categoryArray[indexPath.row];
        
        [self.slidingViewController resetTopViewAnimated:NO onComplete:^{
            [self.slidingViewController.topViewController.navigationController pushViewController:stickerCollectionVC animated:YES];
        }];
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.menuTableView.frame.size.width, 40)];
    headerView.backgroundColor = [UIColor blackColor];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(15, 0, self.menuTableView.frame.size.width, 40)];
    title.backgroundColor = [UIColor blackColor];
    title.font = [UIFont fontWithName:@"Bangers-Regular" size:16];
    title.textColor = [UIColor whiteColor];
    title.textAlignment = NSTextAlignmentLeft;
    [headerView addSubview:title];
    
    if (section == 0)
    {
        title.text = @"Unlock & Restore";
    }
    else
    {
        title.text = @"Stickers";
    }
    
    return headerView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 40.0f;
}

@end
