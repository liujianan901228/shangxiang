//
//  LoadErrorView.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "LoadErrorView.h"

@interface LoadErrorView()
@property(nonatomic,strong)UIImageView* errorImageView;
@property(nonatomic,strong)UILabel* errorLabel;
@property(nonatomic,strong)UILabel* errorMessageLabel;
@property(nonatomic,strong)UIButton* reloadButton;

@end

@implementation LoadErrorView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = RGBCOLOR(0xfb, 0xfc, 0xfd);;
        
        UIImage* image = [UIImage imageForKey:@"erro_background_image"];
        CGFloat errorLabelHeight = [ToolsHelper calculateSingleLineHeight:16.0f];
        CGFloat errorMsgLabelHeight = [ToolsHelper calculateSingleLineHeight:12.0f];
        CGFloat btnHeight = 40;
        
        self.errorImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, (self.height-(image.size.height+20+errorLabelHeight+8+errorMsgLabelHeight+20+btnHeight))/2, kScreenWidth, image.size.height)];
        self.errorImageView.contentMode = UIViewContentModeCenter;
        self.errorImageView.image = [UIImage imageForKey:@"erro_background_image"];
        [self addSubview:self.errorImageView];
        
        self.errorLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, _errorImageView.bottom+20, kScreenWidth, errorLabelHeight)];
        self.errorLabel.font = [UIFont systemFontOfSize:18.0f];
        self.errorLabel.textAlignment = NSTextAlignmentCenter;
        self.errorLabel.textColor = UIColorFromRGB(0x414141);
        self.errorLabel.text = @"网络连接失败";
        self.errorLabel.backgroundColor = [UIColor clearColor];
        [self addSubview:self.errorLabel];
        
        self.errorMessageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.errorLabel.bottom+8, kScreenWidth, errorMsgLabelHeight)];
        self.errorMessageLabel.font = [UIFont systemFontOfSize:12.0f];
        self.errorMessageLabel.textColor = UIColorFromRGB(0x414141);
        self.errorMessageLabel.text = @"您可以尝试刷新或者检查网络连接情况";
        self.errorMessageLabel.backgroundColor = [UIColor clearColor];
        self.errorMessageLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:self.errorMessageLabel];
        
        NSString* title = @"刷新一下";
        
        self.reloadButton = [[UIButton alloc] initWithFrame:CGRectMake((kScreenWidth-160)/2, self.errorMessageLabel.bottom+20, 160, 40)];
        self.reloadButton.backgroundColor = [UIColor clearColor];
        self.reloadButton.layer.cornerRadius = 3;
        self.reloadButton.layer.borderWidth = 1;
        self.reloadButton.layer.borderColor = UIColorFromRGB(0x0babd1).CGColor;
        [self.reloadButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
        [self.reloadButton setTitle:title forState:UIControlStateNormal];
        [self.reloadButton setTitleColor:UIColorFromRGB(0x0babd1) forState:UIControlStateNormal];
        [self.reloadButton setTitle:title forState:UIControlStateNormal];
        
        [self.reloadButton addTarget:self action:@selector(reloadButtonClick) forControlEvents:UIControlEventTouchUpInside];
        
        [self addSubview:self.reloadButton];
        
    }
    return self;
}

-(void)setFrame:(CGRect)frame {
    [super setFrame:frame];
    CGFloat errorLabelHeight = [ToolsHelper calculateSingleLineHeight:16.0f];
    CGFloat errorMsgLabelHeight = [ToolsHelper calculateSingleLineHeight:12.0f];
    CGFloat btnHeight = 40;
    UIImage* image = [UIImage imageForKey:@"erro_background_image"];
    self.errorImageView.frame = CGRectMake(0, (self.height-(image.size.height+20+errorLabelHeight+8+errorMsgLabelHeight+20+btnHeight))/2, kScreenWidth, image.size.height);
    self.errorLabel.frame = CGRectMake(0, _errorImageView.bottom+20, kScreenWidth, errorLabelHeight);
    self.errorMessageLabel.frame = CGRectMake(0, self.errorLabel.bottom+8, kScreenWidth, errorMsgLabelHeight);
    self.reloadButton.frame = CGRectMake((kScreenWidth-160)/2, self.errorMessageLabel.bottom+20, 160, 40);
}

-(void)reloadButtonClick
{
    if([self.delegate respondsToSelector:@selector(requestToReLoadData)])
    {
        [self.delegate requestToReLoadData];
    }
}

@end
