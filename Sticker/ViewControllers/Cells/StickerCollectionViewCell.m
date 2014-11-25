//
//  StickerCollectionViewCell.m
//  Sticker
//
//  Created by Q on 11/25/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "StickerCollectionViewCell.h"

@implementation StickerCollectionViewCell

- (void)setImageWithURL:(NSString *)urlString
{
    NSURL *url = [NSURL URLWithString:urlString];
    __weak typeof(self) weakSelf = self;
    
    [self.imageView setImageWithURL:url
                   placeholderImage:[UIImage imageNamed:@"placeholder.png"]
                            options:SDWebImageCacheMemoryOnly
                           progress:^(NSInteger receivedSize, NSInteger expectedSize) {
                               // Add indicator
                               [weakSelf.progressView setHidden:NO];
                               [weakSelf.progressView setProgress:(float)receivedSize/expectedSize animated:NO];
                               
                           } completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
                               [weakSelf performSelector:@selector(reset) withObject:nil afterDelay:0.5];
                               NSLog(@"cacheType : %d", cacheType);
                           }];
    self.imageView.contentMode = UIViewContentModeScaleAspectFit;
}

@end
