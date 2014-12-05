//
//  StickerCollectionViewController.h
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCollectionViewController : UIViewController

@property (nonatomic, strong) IBOutlet UICollectionView  *stickerCollectionView;
@property (nonatomic, strong) NSArray *stickerArray;

@end
