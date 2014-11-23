//
//  ViewController.m
//  Sticker
//
//  Created by Q on 11/23/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()

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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

@end
