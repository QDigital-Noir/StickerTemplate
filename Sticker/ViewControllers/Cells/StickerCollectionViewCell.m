//
//  StickerCollectionViewCell.m
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "StickerCollectionViewCell.h"

@implementation StickerCollectionViewCell

- (void)setImageWithURL:(NSString *)urlString andIsPaid:(BOOL)isPaid andCateName:(NSString *)cateName
{
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:urlString]
                      placeholderImage:[UIImage imageNamed:@"placeholder"]
                               options:SDWebImageRefreshCached];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
    
    BOOL isUnlock = [[Helper sharedHelper] getUnlockedStickerWithKey:cateName];
    BOOL isUnlockAll = [[Helper sharedHelper] getUnlockedStickerWithKey:@"All"];
    if (isUnlock || isUnlockAll)
    {
        NSLog(@"No overlay");
    }
    else
    {
        if (isPaid)
        {
            self.lockedImageView.backgroundColor = [UIColor clearColor];
            self.lockedImageView.image = [UIImage imageNamed:@"locked"];
            self.lockedImageView.alpha = 0.6;
        }
    }
}

- (void)prepareForReuse
{
    self.lockedImageView.image = nil;
}

@end
