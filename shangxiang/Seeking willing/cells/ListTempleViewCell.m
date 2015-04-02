//
//  ListTempleViewCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ListTempleViewCell.h"
#import "TempleObject.h"
#import "UIImageView+WebCache.h"

@interface ListTempleViewCell ()

@property(nonatomic, retain) UIImageView* viewHall;
@property(nonatomic, retain) UIImageView* viewMaster;
@property(nonatomic, retain) UILabel* labelHall;
@property(nonatomic, retain) UILabel* labelMaster;
@property(nonatomic, retain) UIButton* buttonOrder;

@end

@implementation ListTempleViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;
        
        CGFloat contentHeight = [ListTempleViewCell tableView:nil rowHeightForObject:nil];
        
        self.viewHall = [[UIImageView alloc] initWithFrame:CGRectMake(16, 8, 34, 34)];
        [self.viewHall setClipsToBounds:YES];
        [self.viewHall setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.viewHall];
        
        
        self.viewMaster = [[UIImageView alloc] initWithFrame:CGRectMake(self.viewHall.right + 8, 8, 34, 34)];
        [self.viewMaster setClipsToBounds:YES];
        [self.viewMaster setContentMode:UIViewContentModeScaleAspectFill];
        [self.contentView addSubview:self.viewMaster];

        self.buttonOrder = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.width - 60 -20, (contentHeight - 30)/2, 60, 30)];
        [self.buttonOrder setTitle:@"填订单" forState:UIControlStateNormal];
        [self.buttonOrder.titleLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.buttonOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [self.buttonOrder setBackgroundColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT)];
        [self.buttonOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
        [self.buttonOrder addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:self.buttonOrder];
        
        self.labelHall = [[UILabel alloc] initWithFrame:CGRectMake(self.viewMaster.right + 8, 12, self.contentView.width - self.buttonOrder.width - 20 - self.viewMaster.right, 15)];
        [self.labelHall setFont:[UIFont systemFontOfSize:12.0f]];
        [self.labelHall setNumberOfLines:1];
        [self.labelHall setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:self.labelHall];
        
        self.labelMaster = [[UILabel alloc] initWithFrame:CGRectMake(self.viewMaster.right + 8, 28, self.contentView.width - self.buttonOrder.width - 20 - self.viewMaster.right, 10)];
        [self.labelMaster setFont:[UIFont systemFontOfSize:10.0f]];
        [self.labelMaster setNumberOfLines:1];
        [self.labelMaster setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
        [self.labelMaster setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:self.labelMaster];
        
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, contentHeight - 0.5, self.contentView.width, 0.5)];
        [line setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
        [self.contentView addSubview:line];
        
    }
    return self;
}

- (void)buttonClicked:(UIButton*)button
{
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(clickCell:)])
    {
        [self.cellDelegate clickCell:self];
    }
}

- (void)baseSetup
{
    self.labelHall.text = nil;
    self.labelMaster.text = nil;
}

- (void)setObject:(id)object
{
    [super setObject:object];
    TempleObject* templeObject = (TempleObject*)object;
    [self.viewHall sd_setImageWithURL:[NSURL URLWithString:templeObject.templeSmallUrl] placeholderImage:[UIImage imageForKey:@"img_not_available"]];
    [self.viewMaster sd_setImageWithURL:[NSURL URLWithString:templeObject.attacheSmallUrl] placeholderImage:[UIImage imageForKey:@"img_not_available"]];
    [self.labelHall setText:[NSString stringWithFormat:@"%@ (%@)",templeObject.templeName,templeObject.templeProvince]];
    if(templeObject.buddhistName)
    {
        [self.labelMaster setText:templeObject.buddhistName];
    }
    else
    {
        [self.labelMaster setText:templeObject.attacheName];
    }
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return 50.0f;
}


@end
