//
//  OrderRecordViewCell.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderRecordViewCell.h"
#import "WillingObject.h"

#define kCatchWidth 80

@interface OrderRecordViewCell ()<UIScrollViewDelegate>

@property(nonatomic, strong) UIScrollView *scrollView;
@property(nonatomic, strong) UIView* buttonView;
@property(nonatomic, strong) UIView* scrollContentView;
@property(nonatomic, strong) UILabel* labelOrderTitle;
@property(nonatomic, strong) UILabel* labelOrderDesc;
@property(nonatomic, strong) UILabel* labelStatus;

@end

@implementation OrderRecordViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
    {
        self.clipsToBounds = YES;
        self.backgroundColor = [UIColor clearColor];
        
        _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        _scrollView.showsHorizontalScrollIndicator = NO;
        _scrollView.showsVerticalScrollIndicator = NO;
        _scrollView.delegate = self;
        [_scrollView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView setContentSize:CGSizeMake(_scrollView.width + kCatchWidth, 50)];
        [self.contentView addSubview:_scrollView];
        
        _buttonView = [[UIView alloc] initWithFrame:CGRectMake(self.width - kCatchWidth, 0, kCatchWidth, 50)];
        [_buttonView setBackgroundColor:[UIColor clearColor]];
        [_scrollView addSubview:_buttonView];
        
        UIButton* deleteButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [deleteButton setFrame:CGRectMake(0, 0, 80, 50)];
        [deleteButton setBackgroundColor:[UIColor redColor]];
        [deleteButton setTitle:@"删除" forState:UIControlStateNormal];
        [deleteButton addTarget:self action:@selector(deleteButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [deleteButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonView addSubview:deleteButton];
        
        _scrollContentView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.width, 50)];
        [_scrollContentView setBackgroundColor:[UIColor whiteColor]];
        [_scrollView addSubview:_scrollContentView];
        
        self.labelStatus = [[UILabel alloc] initWithFrame:CGRectMake(self.width - 10 - 60, (self.height - 20)/2, 60, 20)];
        [self.labelStatus setFont:[UIFont systemFontOfSize:14.0f]];
        [self.labelStatus setTextColor:UIColorFromRGB(0x9f9f9e)];
        self.labelStatus.numberOfLines = 1;
        [self.labelStatus setFont:[UIFont systemFontOfSize:14]];
        self.labelStatus.lineBreakMode = NSLineBreakByTruncatingTail;
        [_scrollContentView addSubview:self.labelStatus];
        
        self.labelOrderTitle = [[UILabel alloc] initWithFrame:CGRectMake(16, 10, self.width -16 - self.labelStatus.width - 10 - 10, 15)];
        [self.labelOrderTitle setFont:[UIFont systemFontOfSize:12.0f]];
        [self.labelOrderTitle setTextColor:UIColorFromRGB(0x5a5a5a)];
        self.labelOrderTitle.numberOfLines = 1;
        self.labelOrderTitle.lineBreakMode  = NSLineBreakByTruncatingTail;
        [_scrollContentView addSubview:self.labelOrderTitle];
        
        self.labelOrderDesc = [[UILabel alloc] initWithFrame:CGRectMake(16, 28, self.width -16 - self.labelStatus.width - 10 - 10, 12)];
        [self.labelOrderDesc setFont:[UIFont systemFontOfSize:9.0f]];
        [self.labelOrderDesc setTextColor:UIColorFromRGB(0xbababa)];
        self.labelOrderDesc.numberOfLines = 1;
        self.labelOrderDesc.lineBreakMode = NSLineBreakByTruncatingTail;
        [_scrollContentView addSubview:self.labelOrderDesc];
        
        
        UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.width, 0.5)];
        [line setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
        [self.contentView addSubview:line];
        
        UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTapgesture:)];
        [_scrollContentView addGestureRecognizer:tapGesture];
    }
    return self;
}

- (void)baseSetup
{
    self.labelOrderTitle.text = nil;
    self.labelOrderDesc.text = nil;
    self.labelStatus.text = nil;
    [_scrollView setContentOffset:CGPointZero animated:NO];
}

- (void)setObject:(id)object
{
    [super setObject:object];
    WillingObject* willingObject = (WillingObject*)object;
    [self.labelOrderTitle setText:[NSString stringWithFormat:@"%@(%@)",willingObject.templeName,willingObject.buddhistName]];
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:[willingObject.retime integerValue]];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];
    [self.labelOrderDesc setText:[NSString stringWithFormat:@"订单号:%@  %@",willingObject.orderNumber,[formatter stringFromDate:confromTimesp]]];
    [self.labelStatus setText:willingObject.status];
    if([willingObject.status isEqualToString:@"未支付"])
    {
        _scrollView.scrollEnabled = YES;
    }
    else
    {
        _scrollView.scrollEnabled = NO;
    }
}

- (void)handleTapgesture:(UITapGestureRecognizer*)gesture
{
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(clickCell:)])
    {
        [self.cellDelegate clickCell:self];
    }
}

- (void)deleteButtonClicked:(UIButton*)button
{
    if(self.cellDelegate && [self.cellDelegate respondsToSelector:@selector(deleteCell:)])
    {
        [self.cellDelegate deleteCell:self];
    }
}

+ (CGFloat)tableView:(UITableView*)tableView rowHeightForObject:(id)object
{
    return 50.0f;
}


#pragma UIScrollView Delegate
- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset {
    
    if (scrollView.contentOffset.x > 45) {
        targetContentOffset->x = kCatchWidth;
    }
    else
    {
        *targetContentOffset = CGPointZero;
        
        // Need to call this subsequently to remove flickering. Strange.
        dispatch_async(dispatch_get_main_queue(), ^{
            [scrollView setContentOffset:CGPointZero animated:YES];
        });
    }
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView {
    if (scrollView.contentOffset.x < 0)
    {
        scrollView.contentOffset = CGPointZero;
    }
    
    self.buttonView.frame = CGRectMake(scrollView.contentOffset.x + (CGRectGetWidth(self.bounds) - kCatchWidth), 0.0f, kCatchWidth, CGRectGetHeight(self.bounds));
}

- (void)dealloc
{
    _scrollView.delegate = nil;
}

@end
