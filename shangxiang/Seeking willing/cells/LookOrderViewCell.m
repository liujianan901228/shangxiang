//
//  LookOrderViewCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "LookOrderViewCell.h"

@interface LookOrderViewCell ()

@property (nonatomic, strong) UILabel* firstLabel;
@property (nonatomic, strong) UIButton* shareButton;
@property (nonatomic, strong) UIImageView* circleImageView;
@property (nonatomic, strong) UIView* lineView;
@property (nonatomic, strong) UIView* firstLineView;

@end

@implementation LookOrderViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.contentView.backgroundColor = UIColorFromRGB(0xECECEC);
        
        _firstLineView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        [_firstLineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
        [_firstLineView setHidden:YES];
        [self.contentView addSubview:_firstLineView];
        
        _circleImageView = [[UIImageView alloc] initWithFrame:CGRectMake(8, 13, 9, 9)];
        [_circleImageView setImage:[UIImage imageForKey:@"circleImage"]];
        [self.contentView addSubview:_circleImageView];
        
        _firstLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 10, self.contentView.width - 40, 0)];
        [_firstLabel setNumberOfLines:0];
        [_firstLabel setFont:[UIFont systemFontOfSize:14]];
        [self.contentView addSubview:_firstLabel];
        
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.contentView.width - 20 - 130, _firstLabel.bottom, 130, 30)];
        [_shareButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [_shareButton setTitleColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT) forState:UIControlStateNormal];
        [_shareButton setTitle:@"[随喜转发] 功德无量" forState:UIControlStateNormal];
        [_shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.contentView addSubview:_shareButton];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _shareButton.bottom, self.width, 0.5)];
        [_lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

- (void)shareButtonClicked:(UIButton*)button
{
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(shareText:)])
    {
        [self.cellDelegate shareText:self];
    }
}

+ (CGFloat)getCellHeight:(OrderInfoObject*)orderInfoObject
{
    CGFloat height = 0;
    height += 10;//上边距离
    NSString* contentText = [NSString stringWithFormat:@"%@%@请%@于%@%@%@%@前已达成心愿",orderInfoObject.province,orderInfoObject.wishName,orderInfoObject.builddhistName,orderInfoObject.templeName,orderInfoObject.alsoWish,orderInfoObject.wishType,orderInfoObject.wishDate];
    if(contentText && contentText.length > 0)
    {
        CGSize size = [contentText sizeForFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT] size:CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        height += size.height;//大文本的高度
    }
    height += 30;//share的高度
    return height;
}

- (void)layoutSubviewsByObject:(OrderInfoObject*)orderInfoObject
{
    NSString* contentText = [NSString stringWithFormat:@"%@%@请%@于%@%@%@%@前已达成心愿",orderInfoObject.province,orderInfoObject.wishName,orderInfoObject.builddhistName,orderInfoObject.templeName,orderInfoObject.alsoWish,orderInfoObject.wishType,orderInfoObject.wishDate];
    if(contentText && contentText.length > 0)
    {
        CGSize size = [contentText sizeForFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT] size:CGSizeMake(kScreenWidth - 40, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        self.firstLabel.size = size;
    }
    
    [self.shareButton setTop:self.firstLabel.bottom];
    [self.lineView setTop:self.shareButton.bottom];
    self.contentView.height = [LookOrderViewCell getCellHeight:orderInfoObject];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return [LookOrderViewCell getCellHeight:object];
}

- (void)setObject:(id)object
{
    [super setObject:object];
    if(self.indexPath.row == 0)
    {
        [_firstLineView setHidden:NO];
    }
    OrderInfoObject* orderInfoObject = (OrderInfoObject*)object;
    [self.firstLabel setText:[NSString stringWithFormat:@"%@%@请%@于%@%@%@%@前已达成心愿",orderInfoObject.province,orderInfoObject.wishName,orderInfoObject.builddhistName,orderInfoObject.templeName,orderInfoObject.alsoWish,orderInfoObject.wishType,orderInfoObject.wishDate]];
    [self layoutSubviewsByObject:object];
}

- (void)baseSetup
{
    self.firstLabel.text = nil;
}

@end
