//
//  ShareView.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ShareView.h"

@interface ShareView ()<UITextViewDelegate>

@property (nonatomic, strong) UIView* contentView;
@property (nonatomic, assign) BOOL isShowKeyBoard;

@end

@implementation ShareView

- (instancetype)init
{
    if(self = [super init])
    {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardDidShown:) name:UIKeyboardDidShowNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasChange:) name:UIKeyboardDidChangeFrameNotification object:nil];
    }
    return self;
}

- (void)showInWindow:(UIWindow*)window orderText:(NSString*)orderText
{
    if(!window || self.superview) return;
    
    self.frame = CGRectMake(0, 0, window.width, window.height);
    
    
    self.contentView = [[UIView alloc] initWithFrame:CGRectMake(10, (window.height - 200)/2.0, window.width - 20, 200)];
    [self.contentView.layer setCornerRadius:5];
    [self.contentView setBackgroundColor:UIColorFromRGB(0xf9f9f9)];
    
    
    UIButton* friendButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.contentView.width, 45)];
    [friendButton setTitle:@"分享到朋友圈" forState:UIControlStateNormal];
    [friendButton setTitleColor:UIColorFromRGB(COLOR_LINE_NORMAL) forState:UIControlStateNormal];
    [friendButton setImage:[UIImage imageForKey:@"wx_logo_friend"] forState:UIControlStateNormal];
    [friendButton setImageEdgeInsets:UIEdgeInsetsMake((45 - 35)/2, 15, (45 - 35)/2, 0)];
    [friendButton setTitleEdgeInsets:UIEdgeInsetsMake(14, 20, 10, 0)];
    [friendButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [friendButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [friendButton setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateHighlighted];
    [friendButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [friendButton addTarget:self action:@selector(shareFriendButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:friendButton];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, friendButton.bottom, self.contentView.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [self.contentView addSubview:lineView];
    
    UIButton* singButton = [[UIButton alloc] initWithFrame:CGRectMake(0, lineView.bottom, self.contentView.width, 45)];
    [singButton setTitle:@"分享到微信好友" forState:UIControlStateNormal];
    [singButton setTitleColor:UIColorFromRGB(COLOR_LINE_NORMAL) forState:UIControlStateNormal];
    [singButton setImage:[UIImage imageForKey:@"wx_logo_single"] forState:UIControlStateNormal];
    [singButton setImageEdgeInsets:UIEdgeInsetsMake((45 - 35)/2, 15, (45 - 35)/2, 0)];
    [singButton setTitleEdgeInsets:UIEdgeInsetsMake(14, 20, 10, 0)];
    [singButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [singButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
    [singButton.titleLabel setFont:[UIFont systemFontOfSize:14]];
    [singButton setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateHighlighted];
    [singButton addTarget:self action:@selector(shareSingleButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [self.contentView addSubview:singButton];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, singButton.bottom, self.contentView.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [self.contentView addSubview:lineView];
    
    UILabel* shareTitle = [[UILabel alloc] initWithFrame:CGRectMake(15, lineView.bottom + 10, self.contentView.width - 30, 15)];
    [shareTitle setNumberOfLines:1];
    [shareTitle setTextColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [shareTitle setBackgroundColor:[UIColor clearColor]];
    [shareTitle setText:@"分享内容:"];
    [shareTitle setFont:[UIFont systemFontOfSize:14]];
    [self.contentView addSubview:shareTitle];
    
    _textView = [[UITextView alloc] initWithFrame:CGRectMake(15, shareTitle.bottom,  self.contentView.width - 60 - 15 - 15, 55)];
    [_textView setBackgroundColor:[UIColor clearColor]];
    [_textView setScrollEnabled:YES];
    [_textView setKeyboardType:UIKeyboardTypeDefault];
    _textView.returnKeyType = UIReturnKeyDone;
    _textView.text = orderText;
    _textView.delegate = self;
    [self.contentView addSubview:_textView];
    
    UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.contentView.width - 60 - 15,lineView.bottom + 10, 60, 60)];
    [imageView setImage:[UIImage imageForKey:@"logo"]];
    [self.contentView addSubview:imageView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, _textView.bottom, self.contentView.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [self.contentView addSubview:lineView];
    
    
    UITapGestureRecognizer* gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    [self addGestureRecognizer:gesture];
    [self addSubview:self.contentView];
    
    [self.layer setValue:@(0.99) forKeyPath:@"transform.scale"];
    [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
        [self.layer setValue:@(1) forKeyPath:@"transform.scale"];
    } completion:^(BOOL finished) {
        [window addSubview:self];
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.60];
    }];
    
}

-(void)shareFriendButtonClick:(UIButton*)button
{
    if(self.shareBlock)
    {
        self.shareBlock(WxType_Friend,_textView.text);
    }
}

-(void)shareSingleButtonClick:(UIButton*)button
{
    if(self.shareBlock)
    {
        self.shareBlock(WxType_Single,_textView.text);
    }
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)close
{
    if(self.superview)
    {
        [self.layer setValue:@(1) forKeyPath:@"transform.scale"];
        [UIView animateWithDuration:0.1 delay:0 options:UIViewAnimationOptionCurveEaseOut animations:^{
            [self.layer setValue:@(0.99) forKeyPath:@"transform.scale"];
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
        
    }
}

- (void)keyBoardWillShow:(NSNotification *)notification
{
    CGSize keyboardSize = [[[notification userInfo] objectForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue].size;
    if(self.contentView.top != (self.height - 200 - keyboardSize.height))
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.contentView setTop:self.height - 200 - keyboardSize.height];
            self.isShowKeyBoard = YES;
        }];
    }
}

- (void)keyBoardDidShown:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if(self.contentView.top != (self.height - 200 - keyboardSize.height))
    {
        [self.contentView setTop:self.height - 200 - keyboardSize.height];
        self.isShowKeyBoard = YES;
    }
}

- (void)keyBoardWillHide:(NSNotification *)notification
{
    if(self.contentView.top != ((self.height - 200)/2.0))
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.contentView setTop:(self.height - 200)/2.0];
            self.isShowKeyBoard = NO;
        }];
    }
}

- (void)keyboardWasChange:(NSNotification *)notification
{
    NSDictionary* info = [notification userInfo];
    CGSize keyboardSize = [[info objectForKey:UIKeyboardFrameEndUserInfoKey] CGRectValue].size;
    if(self.contentView.top != (self.height - 200 - keyboardSize.height) && self.isShowKeyBoard)
    {
        [UIView animateWithDuration:0.3 animations:^{
            [self.contentView setTop:self.height - 200 - keyboardSize.height];
        }];
    }
}

#pragma mark - UITextView Delegate Methods

-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"])
    {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

@end
