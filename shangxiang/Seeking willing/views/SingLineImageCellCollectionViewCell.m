//
//  SingLineImageCellCollectionViewCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/17.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "SingLineImageCellCollectionViewCell.h"
#import "UIImageView+WebCache.h"

@implementation SingLineImageCellCollectionViewCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        _singImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
        _singImageView.contentMode = UIViewContentModeScaleAspectFill;
        _singImageView.clipsToBounds = YES;
        
        [self.contentView addSubview:_singImageView];
    }
    return self;
}

- (void)setObject:(TemplePictureObject *)object
{
    if(object)
    {
        [_singImageView sd_setImageWithURL:[NSURL URLWithString:object.picSmallUrl] placeholderImage:[UIImage imageForKey:@"img_not_available"]];
    }
}

@end
