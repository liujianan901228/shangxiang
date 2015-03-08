//
//  NotificationCell.m
//  shangxiang
//
//  Created by limingchen on 15/2/9.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "NotificationCell.h"

@interface NotificationCell ()

@property (nonatomic, strong) UILabel* contentLabel;
@property (nonatomic, strong) UILabel* timeLabel;
@property (nonatomic, strong) UIView* lineView;

@end

@implementation NotificationCell


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        self.contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, 5, self.width - 20, 0)];
        [self.contentLabel setFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT]];
        [self.contentLabel setLineBreakMode:NSLineBreakByWordWrapping];
        [self.contentLabel setNumberOfLines:0];
        [self.contentView addSubview:self.contentLabel];
        
        self.timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, self.contentLabel.bottom, self.width - 20, 23)];
        [self.timeLabel setNumberOfLines:1];
        [self.timeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.timeLabel setBackgroundColor:[UIColor clearColor]];
        [self.timeLabel setFont:[UIFont systemFontOfSize:12]];
        [self.timeLabel setTextColor:UIColorFromRGB(COLOR_FONT_FORM_HINT)];
        [self.contentView addSubview:self.timeLabel];
        
        _lineView = [[UIView alloc] initWithFrame:CGRectMake(0, self.timeLabel.bottom, self.width, 0.5)];
        [_lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
        [self.contentView addSubview:_lineView];
        
    }
    return self;
}

+ (CGFloat)getCellHeight:(NotificationObject*)object
{
    CGFloat height = 0;
    height += 5;//上边距离
    if(object && object.title)
    {
        CGSize size = [object.title sizeForFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT] size:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
        height += size.height;//大文本的高度
    }
    //height += 5;
    height += 23;//time的高度
    return height;
}

- (void)layoutSubviewsByObject:(NotificationObject*)object
{
    CGSize size = [self.contentLabel.text sizeForFont:[UIFont systemFontOfSize:SIZE_FONT_DICOVER_CONTENT] size:CGSizeMake(kScreenWidth - 20, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    self.contentLabel.size = size;
    self.timeLabel.top = self.contentLabel.bottom;
    [self.lineView setTop:self.timeLabel.bottom - 0.5];
    self.contentView.height = [NotificationCell getCellHeight:object];
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return [NotificationCell getCellHeight:object];
}


- (void)baseSetup
{
    self.contentLabel.text = nil;
    self.timeLabel.text = nil;
}

- (void)setObject:(id)object
{
    [super setObject:object];
    NotificationObject* notifyObject = (NotificationObject*)object;
    [self.contentLabel setText:notifyObject.title];
    [self.timeLabel setText:notifyObject.time];
    [self layoutSubviewsByObject:object];
}

@end
