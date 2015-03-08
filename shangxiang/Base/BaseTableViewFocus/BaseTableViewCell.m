//
//  BaseTableViewCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BaseTableViewCell.h"
#import "SDWebImageManager.h"

@implementation BaseTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        
    }
    return self;
}

- (void)setFrame:(CGRect)frame {
    
    frame.size.width = kScreenWidth;
    
    [super setFrame:frame];
    
}

- (void)setObject:(id)object
{
    _object = object;
    [self baseSetup];
}

- (void)baseSetup
{
    self.imageView.image = nil;
    self.imageView.hidden = YES;
    self.textLabel.text = nil;
    self.textLabel.hidden = YES;
    self.detailTextLabel.text = nil;
    self.detailTextLabel.hidden = YES;
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return 44.0f;
}



@end
