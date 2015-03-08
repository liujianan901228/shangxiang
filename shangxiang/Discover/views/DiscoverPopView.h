//
//  DiscoverPopView.h
//  shangxiang
//
//  Created by 倾慕 on 15/1/15.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DiscoverPopViewDataSource.h"
#import "TempleObject.h"

typedef void(^didSelectDiscoverBlock)(TempleObject* object,NSInteger index);

@interface DiscoverPopView : UIView

@property (nonatomic, strong) UITableView* tableView;

@property (nonatomic, strong) DiscoverPopViewDataSource* discoverPopDataSource;

@property (nonatomic, strong) didSelectDiscoverBlock actionBlock;

- (void)showPopViewInWindow:(UIWindow*)window;

- (void)closePopView;

- (instancetype)initWithActionBlock:(didSelectDiscoverBlock)actionBlock;

@end
