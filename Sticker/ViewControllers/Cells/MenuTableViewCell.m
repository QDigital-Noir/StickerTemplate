//
//  MenuTableViewCell.m
//  Sticker
//
//  Created by Q on 11/26/14.
//  Copyright (c) 2014 Q. All rights reserved.
//

#import "MenuTableViewCell.h"

@implementation MenuTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - Setup cell layout

- (void)setupCellLayoutWithCategoryName:(NSString *)cateName
{
    self.categoryTitle = [[UILabel alloc] initWithFrame:CGRectMake(10, 0, self.frame.size.width, self.frame.size.height)];
    self.categoryTitle.font = FONT_BOLD(20);
    self.categoryTitle.textColor = [UIColor blackColor];
    self.categoryTitle.textAlignment = NSTextAlignmentLeft;
    self.categoryTitle.text = cateName;
    self.backgroundColor = [UIColor clearColor];
    
    [self.contentView addSubview:self.categoryTitle];
}

@end
