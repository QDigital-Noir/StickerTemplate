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
    
//    //Setup table view.
//    self.menuTableView = [[UITableView alloc] initWithFrame:self.view.frame];
//    self.menuTableView.dataSource = self;
//    self.menuTableView.delegate = self;
//    [self.view addSubview:self.menuTableView];
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    return self.categoryArray.count;
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
    
    [self configureCell:cell forRowAtIndexPath:indexPath];
    
    return cell;
}

- (void)configureCell:(MenuTableViewCell *)cell
    forRowAtIndexPath:(NSIndexPath *)indexPath
{
    [cell setupCellLayoutWithCategoryName:self.categoryArray[indexPath.row]];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    StickerCollectionViewController *stickerCollectionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"StickerCollectionViewController"];
    stickerCollectionVC.stickerArray = [[Helper sharedHelper] getStickerListWithKey:self.categoryArray[indexPath.row]];
    
    [self.slidingViewController resetTopViewAnimated:NO onComplete:^{
        [self.slidingViewController.topViewController.navigationController pushViewController:stickerCollectionVC animated:YES];
    }];
}

@end
