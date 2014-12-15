//
//  StickerCollectionViewCell.h
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface StickerCollectionViewCell : UICollectionViewCell

@property (nonatomic, strong) IBOutlet UIImageView *imageView;
@property (nonatomic, strong) IBOutlet UIImageView *lockedImageView;

- (void)setImageWithURL:(NSString *)urlString andIsPaid:(BOOL)isPaid andCateName:(NSString *)cateName;
@end
