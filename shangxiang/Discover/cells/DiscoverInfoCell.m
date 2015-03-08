//
//  DiscoverInfoCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/22.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverInfoCell.h"
#import "BlessingsMemberObject.h"
#import "UIImageView+WebCache.h"

@interface DiscoverInfoCell ()

@property (nonatomic, strong) UIImageView* headerImageView;
@property (nonatomic, strong) UILabel* nameLabel;
@property (nonatomic, strong) UILabel* descrptionLabel;

@end

@implementation DiscoverInfoCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(60, 10, 30, 30)];
        [_headerImageView setClipsToBounds:YES];
        [_headerImageView setContentMode:UIViewContentModeScaleAspectFill];
        [_headerImageView.layer setBorderWidth:0.5];
        [_headerImageView.layer setBorderColor:[UIColor lightGrayColor].CGColor];
        [_headerImageView.layer setCornerRadius:15];
        [self.contentView addSubview:_headerImageView];
        
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(_headerImageView.right + 10, 10, self.width - _headerImageView.right - 20, 15)];
        [self.nameLabel setNumberOfLines:1];
        [self.nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.nameLabel setFont:[UIFont systemFontOfSize:12.0f]];
        [self.contentView addSubview:self.nameLabel];
        
        self.descrptionLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.nameLabel.left, self.nameLabel.bottom + 3, self.width - _headerImageView.right - 20, 10)];
        [self.descrptionLabel setNumberOfLines:1];
        [self.descrptionLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.descrptionLabel setFont:[UIFont systemFontOfSize:10.0f]];
        [self.descrptionLabel setTextColor:UIColorFromRGB(COLOR_FONT_FORM_HINT)];
        [self.contentView addSubview:self.descrptionLabel];
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(_headerImageView.left, 49.5, self.width - _headerImageView.left, 0.5)];
        line.backgroundColor = UIColorFromRGB(COLOR_LINE_NORMAL);
        [line setAutoresizingMask:UIViewAutoresizingFlexibleBottomMargin];
        [self.contentView addSubview:line];
    }
    return self;
}

- (void)setObject:(id)object
{
    [super setObject:object];
    BlessingsMemberObject* blessingsMemberObject = (BlessingsMemberObject*)object;
    [self.headerImageView sd_setImageWithURL:[NSURL URLWithString:blessingsMemberObject.thumbUrl] placeholderImage:[UIImage imageForKey:@"avatar_null"]];
    [self.nameLabel setText:[LUtility getDisCoverShowName:blessingsMemberObject.nickName trueName:blessingsMemberObject.trueName]];
    [self.descrptionLabel setText:[NSString stringWithFormat:@"%@加持祈福",blessingsMemberObject.retime]];
    
}

- (void)baseSetup
{
    self.descrptionLabel.text = nil;
    self.nameLabel.text = nil;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return 50.0f;
}

@end
