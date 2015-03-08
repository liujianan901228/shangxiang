//
//  CommonTextFiled.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/18.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "CommonTextFiled.h"

@interface CommonTextFiled ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView* textView;
@property (nonatomic, strong) UILabel* textHolder;
@property (nonatomic, strong) UILabel* textTip;

@end

@implementation CommonTextFiled

- (instancetype)initWithFrame:(CGRect)frame
{
    if(self = [super initWithFrame:frame])
    {
        self.layer.borderColor = UIColorFromRGB(COLOR_LINE_NORMAL).CGColor;
        self.layer.borderWidth = 0.5;
        
        _textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        _textView.delegate = self;
        _textView.backgroundColor = [UIColor clearColor];
        _textView.font = [UIFont systemFontOfSize:14];
        _textView.frame = CGRectInset(self.bounds, 6, 3);
        [self addSubview:_textView];
        
        _textHolder = [[UILabel alloc] initWithFrame:CGRectMake(_textView.left + 4, _textView.top, 300, 28)];
        _textHolder.font = [UIFont systemFontOfSize:14];
        _textHolder.textColor = [UIColor colorWithWhite:0 alpha:0.25];
        _textHolder.userInteractionEnabled = NO;
        _textHolder.backgroundColor = [UIColor clearColor];
        [_textHolder setText:@"请输入"];
        [self addSubview:_textHolder];
        
        _textTip = [UILabel new];
        _textTip.right = _textView.right - 4;
        _textTip.bottom = _textView.bottom - 2;
        _textTip.size = CGSizeMake(150, 16);
        _textTip.font = [UIFont systemFontOfSize:12];
        _textTip.textAlignment = NSTextAlignmentRight;
        _textTip.textColor = UIColorFromRGB(0xc6c6c6);
        _textTip.backgroundColor = [UIColor clearColor];
        _textTip.clipsToBounds = YES;
        _textTip.layer.cornerRadius = 2;
        [self addSubview:_textTip];
        
        [self textViewDidChange:_textView];
    }
    return self;
}

- (void)setTextPlaceHolder:(NSString *)textPlaceHolder
{
    if(_textHolder)
    {
        _textHolder.text = textPlaceHolder;
    }
}


- (void)setMaxInputCount:(NSInteger)maxInputCount
{
    _maxInputCount = maxInputCount;
    [self textViewDidChange:_textView];
}

- (void)textViewDidChange:(UITextView *)textView
{
    _textHolder.hidden = textView.text.length > 0;
    
    if (textView.text.length > self.maxInputCount)
    {
        _textTip.textColor = UIColorFromRGB(0xff6262);
        _textTip.text = [NSString stringWithFormat:@"字数超出了%zd字",(long)(textView.text.length - self.maxInputCount)];
    }
    else
    {
        _textTip.textColor = UIColorFromRGB(0xc6c6c6);
        _textTip.text = [NSString stringWithFormat:@"您还可以输入%zd字",self.maxInputCount - textView.text.length];
    }
    _textTip.bottom = _textView.bottom - 2;
    _textTip.right = _textView.right - 4;
    
}

- (void)dealloc
{
    _textView.delegate = nil;
}

- (NSString*)getContentText
{
    if(_textView)
    {
        return _textView.text;
    }
    return nil;
}


//插在开头
- (void)insertMessage:(NSString*)message
{
    _textView.text = [message stringByAppendingString:_textView.text];
    [self textViewDidChange:_textView];
}

@end
