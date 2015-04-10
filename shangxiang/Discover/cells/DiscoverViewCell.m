//
//  DiscoverViewCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverViewCell.h"
#import "OrderObject.h"
#import "UIImageView+WebCache.h"

@interface DiscoverViewCell()

@property (nonatomic, strong) UIImageView* headImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* descrptionLabel;
@property (nonatomic, strong) UILabel* contentLabel;

@property (nonatomic, strong) UIView* blessContentView;
@property (nonatomic, strong) UIView* firstLine;

@property (nonatomic, strong) UILabel* blessLabell;
@property (nonatomic, strong) UIButton* blessButton;

@end

@implementation DiscoverViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _firstLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 0.5)];
        _firstLine.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
        _firstLine.hidden = YES;
        [self.contentView addSubview:_firstLine];
        
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 30, 30)];
        [self.headImageView setClipsToBounds:YES];
        [self.headImageView setContentMode:UIViewContentModeScaleAspectFill];
        [self.headImageView.layer setBorderWidth:0.5];
        [self.headImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [self.headImageView.layer setCornerRadius:15];
        [self.contentView addSubview:self.headImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.headImageView.right + 10, 10, self.width - self.headImageView.right - 20, 15)];
        [self.nameLabel setNumberOfLines:1];
        [self.nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.nameLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.contentView addSubview:self.nameLabel];
        
        self.descrptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 3, self.width - self.headImageView.right - 20, 10)];
        [self.descrptionLabel setNumberOfLines:1];
        [self.descrptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.descrptionLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [self.descrptionLabel setTextColor:UIColorFromRGB(COLOR_FONT_FORM_HINT)];
        [self.contentView addSubview:self.descrptionLabel];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.descrptionLabel.bottom + 10, self.width - self.headImageView.right - 20, 0)];
        [self.contentLabel setFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT]];
        [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentLabel setNumberOfLines:0];
        [self.contentView addSubview:self.contentLabel];
        
        self.blessContentView = [[UIView alloc] initWithFrame:CGRectMake(self.nameLabel.left, 0, self.width - self.headImageView.right - 20, 30)];
        self.blessContentView.backgroundColor = [UIColor clearColor];
        self.blessLabell = [[UILabel alloc] initWithFrame:CGRectMake(0, 10, self.blessContentView.width - 40, 10)];
        [self.blessLabell setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.blessLabell setFont:[UIFont systemFontOfSize:10.0f]];
        [self.blessLabell setTextColor:UIColorFromRGB(COLOR_FONT_FORM_HINT)];
        [self.blessContentView addSubview:self.blessLabell];
        
        self.blessButton = [[UIButton alloc] initWithFrame:CGRectMake(self.blessContentView.width - 50, 0, 50, 30)];
        [self.blessButton setTitle:@"加持" forState:UIControlStateNormal];
        [self.blessButton.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [self.blessButton setTitleColor:UIColorFromRGB(COLOR_FONT_FORM_HINT) forState:UIControlStateNormal];
        [self.blessButton setBackgroundColor:[UIColor clearColor]];
        [self.blessButton setImage:[UIImage imageForKey:@"button_blessit_normal"] forState:UIControlStateNormal];
        [self.blessButton setImage:[UIImage imageForKey:@"button_blessit_pressed"] forState:UIControlStateDisabled];
        [self.blessButton setImage:[UIImage imageForKey:@"button_blessit_pressed"] forState:UIControlStateHighlighted];
        [self.blessButton addTarget:self action:@selector(blessButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.blessButton setImageEdgeInsets:UIEdgeInsetsMake(0, -5, 0, 0)];
        [self.blessContentView addSubview:self.blessButton];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0 - self.blessContentView.left, self.blessContentView.height - 0.5, self.width, 0.5)];
        line.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
        [line setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
        [self.blessContentView addSubview:line];
        
        [self.contentView addSubview:self.blessContentView];
    
    }
    return self;
}


- (void)baseSetup
{
    self.nameLabel.text = nil;
    self.descrptionLabel.text = nil;
    self.contentLabel.text = nil;
    self.blessLabell.text = nil;
    [self.blessButton setEnabled:YES];
}

- (void)setObject:(id)object
{
    [super setObject:object];
    OrderObject* orderObject = (OrderObject*)object;
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:orderObject.headUrl] placeholderImage:[UIImage imageForKey:@"avatar_null"]];
    [self.nameLabel setText:[LUtility getDisCoverShowName:orderObject.wishName trueName:orderObject.wishName]];
    NSString* showDate = orderObject.wishDate;
    if(![orderObject.wishDate isEqualToString:@"刚刚"])
    {
        showDate = [showDate stringByAppendingString:@"前"];
    }
    NSMutableAttributedString* stringText = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"%@在%@%@%@%@%@:",showDate,@" ",orderObject.templeName,@" ",orderObject.alsoWish,orderObject.wishType]];
    [stringText setAttributeKey:NSForegroundColorAttributeName value:[UIColor blueColor] range:[[NSString stringWithFormat:@"%@在%@%@%@%@%@:",showDate,@" ",orderObject.templeName,@" ",orderObject.alsoWish,orderObject.wishType] rangeOfString:orderObject.templeName]];
    [self.descrptionLabel setAttributedText:stringText];
    
    [self.contentLabel setText:orderObject.wishText];
    
    NSString* blessText = @"无人加持";
    
    if(orderObject.nameBelssings && orderObject.nameBelssings.length > 0 && orderObject.coBlessings)
    {
       blessText = [orderObject.nameBelssings stringByAppendingString:@"等"];
        blessText = [blessText stringByAppendingString:[NSString stringWithFormat:@"%zd人加持",orderObject.coBlessings]];
    }
    
    if(orderObject.isBelss)
    {
        [self.blessButton setEnabled:NO];
    }
    
    self.firstLine.hidden = self.indexPath.row == 0 ? NO :YES;
    [self.blessLabell setText:blessText];
    [self layoutSubviewsByObject];
}

- (void)setBlessSuccess
{
    [self.blessButton setEnabled:NO];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return [DiscoverViewCell getDiscoverHeight:object];
}

+ (CGFloat)getDiscoverHeight:(OrderObject*)object
{
    CGFloat height = 0;
    height += 10;//上边距离
    height += 30;//头像距离
    height += 10;//头像下边距
    if(object && object.wishText)
    {
        CGSize size = [object.wishText sizeForFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT] size:CGSizeMake(kScreenWidth - 70, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        height += size.height;//大文本的高度
    }
    height += 30;//底部的高度
    return height;
}

- (void)layoutSubviewsByObject
{
    CGSize size = [self.contentLabel.text sizeForFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT] size:CGSizeMake(kScreenWidth - 70, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    self.contentLabel.size = size;
    self.blessContentView.top = self.contentLabel.bottom;
    self.contentView.height = 80 + size.height;
}


- (void)blessButtonClicked:(UIButton*)button
{
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(didClickAddBelss:)])
    {
        [self.cellDelegate didClickAddBelss:self];
    }
}

@end
