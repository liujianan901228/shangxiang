//
//  DiscoverPopViewCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/15.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverPopViewCell.h"
#import "TempleObject.h"

@interface DiscoverPopViewCell ()

@property (nonatomic, strong) UILabel* templeLabel;

@end

@implementation DiscoverPopViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if(self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        _templeLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, self.contentView.width - 40, 50)];
        [_templeLabel setNumberOfLines:1];
        [_templeLabel setBackgroundColor:[UIColor clearColor]];
        [_templeLabel setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
        [_templeLabel setFont:[UIFont systemFontOfSize:16]];
        [_templeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [self.contentView addSubview:_templeLabel];
        
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.contentView.width, 0.5)];
        [line setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
        [self.contentView addSubview:line];
        
    }
    return self;
}


- (void)baseSetup
{
    self.templeLabel.text = nil;
}

- (void)setObject:(id)object
{
    [super setObject:object];
    TempleObject* templeObject = (TempleObject*)object;
    [self.templeLabel setText:templeObject.templeName];
}


+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return 50.0f;
}

@end
