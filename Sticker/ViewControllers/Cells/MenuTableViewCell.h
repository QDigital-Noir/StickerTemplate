//
//  MenuTableViewCell.h
//  Sticker
//
//  Created by Q on 11/26/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MenuTableViewCell : UITableViewCell

@property (nonatomic, strong) UILabel *categoryTitle;

// TODO : Ability to add icon.

- (void)setupCellLayoutWithCategoryName:(NSString *)cateName;

@end
