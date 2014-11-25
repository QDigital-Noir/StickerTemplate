//
//  MenuViewController.m
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "MenuViewController.h"
#import "UIViewController+ECSlidingViewController.h"

@interface MenuViewController ()

@property (nonatomic, strong) UINavigationController *transitionsNavigationController;

@end

@implementation MenuViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.transitionsNavigationController = (UINavigationController *)self.slidingViewController.topViewController;

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

@end
