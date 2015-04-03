//
//  DiscoverPopView.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/15.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverPopView.h"
#import "DiscoverPopViewCell.h"

@interface DiscoverPopView ()<UITableViewDelegate,UIGestureRecognizerDelegate>

@end

@implementation DiscoverPopView

- (instancetype)init
{
    if(self = [super init])
    {
        self.frame = CGRectMake(0, 64, kScreenWidth, kScreenHeight - 64);
        self.backgroundColor = [UIColor colorWithWhite:0.000 alpha:0.60];
        
        __weak typeof(self) _weakSelf = self;
        YYGestureRecognizer* gesture = [[YYGestureRecognizer alloc] init];
        gesture.action = ^(YYGestureRecognizer *gesture, YYGestureRecognizerState state)
        {
            if(state == YYGestureRecognizerStateBegan)
            {
                [_weakSelf closePopView];
            }
        };
        gesture.delegate = self;
        [_weakSelf addGestureRecognizer:gesture];
        
        _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
        _discoverPopDataSource = [[DiscoverPopViewDataSource alloc] init];
        _tableView.dataSource = _discoverPopDataSource;
        _tableView.delegate = self;
        [self addSubview:_tableView];
    }
    return self;
}

- (instancetype)initWithActionBlock:(didSelectDiscoverBlock)actionBlock
{
    if(self = [self init])
    {
        self.actionBlock = actionBlock;
    }
    return self;
}

- (void)showPopViewInWindow:(UIWindow*)window
{
    if(self.superview || !window) return;
    [window addSubview:self];
    [_tableView reloadData];
}

- (void)closePopView
{
    if(self.superview)
    {
        [self removeFromSuperview];
    }
}

#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <BaseTableViewDataSource> dataSource = (id <BaseTableViewDataSource> )tableView.dataSource;
    
    id    object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:tableView cellClassForObject:object];
    
    return [cls tableView:tableView rowHeightForObject:object];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(self.actionBlock)
    {
        id <BaseTableViewDataSource> dataSource = (id <BaseTableViewDataSource> )tableView.dataSource;
        id    object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
        self.actionBlock(object,indexPath.row);
    }
}


#pragma UIGesture Delegate
-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch {
    if([touch.view isKindOfClass:[DiscoverPopViewCell class]] || [touch.view.superview isKindOfClass:[DiscoverPopViewCell class]])
    {
        return NO;
    }
    return YES;
}

@end
