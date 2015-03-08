//
//  CustomRowButton.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "CustomRowButton.h"

@implementation CustomRowButton
@synthesize actionReciver;
- (void)dealloc
{
    self.actionReciver = nil;
}
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    [self setup];
}

-(void)setup
{
    if (self.actionReciver == nil)
    {
        UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        button.autoresizingMask = (UIViewAutoresizingFlexibleHeight |
                                   UIViewAutoresizingFlexibleWidth |
                                   UIViewAutoresizingFlexibleLeftMargin |
                                   UIViewAutoresizingFlexibleRightMargin |
                                   UIViewAutoresizingFlexibleTopMargin |
                                   UIViewAutoresizingFlexibleBottomMargin);
        [button setAlpha:0.0];
        self.actionReciver = button;
    }
    
    if (self.actionReciver.superview == nil)
    {
        [self addSubview:self.actionReciver];
        [self bringSubviewToFront:self.actionReciver];
    }
    
    for (UIView* view in self.subviews)
    {
        if (view == self.actionReciver)
        {
            continue;
        }
        view.userInteractionEnabled = NO;
    }
    
}

- (void)addTarget:(id)target action:(SEL)action forControlEvents:(UIControlEvents)controlEvents
{
    [self.actionReciver addTarget:target action:action forControlEvents:controlEvents];
    [super addTarget:target action:action forControlEvents:controlEvents];
}

#pragma mark set stat
- (void)setEnabled:(BOOL)enabled
{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UIControl class]])
        {
            UIControl* control = (UIControl*)view;
            [control setEnabled:enabled];
        }
    }
    
    [super setEnabled:enabled];
}

- (void)setHighlighted:(BOOL)highlighted
{
    for (UIView* view in self.subviews) {
        if ([view isKindOfClass:[UIControl class]])
        {
            UIControl* control = (UIControl*)view;
            [control setHighlighted:highlighted];
        }
        
        if ([view isKindOfClass:[UILabel class]])
        {
            UILabel* label = (UILabel*)view;
            [label setHighlighted:highlighted];
        }
        
        if ([view isKindOfClass:[UIImageView class]])
        {
            UIImageView* image = (UIImageView*)view;
            [image setHighlighted:highlighted];
        }
    }
    
    [super setHighlighted:highlighted];
}

- (void)setSelected:(BOOL)selected
{
    for (UIView* view in self.subviews)
    {
        if ([view isKindOfClass:[UIControl class]])
        {
            UIControl* control = (UIControl*)view;
            [control setSelected:selected];
        }
    }
    [super setSelected:selected];
}

@end
