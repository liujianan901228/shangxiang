//
//  NotificationViewController.m
//  shangxiang
//
//  Created by limingchen on 15/2/9.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "NotificationViewController.h"
#import "NotificationDataSource.h"
#import "MyRequestManager.h"

@interface NotificationViewController ()<UITableViewDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) NotificationDataSource* notifyDataSource;

@end

@implementation NotificationViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    self.title = @"系统通知";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _notifyDataSource = [[NotificationDataSource alloc] init];
    _tableView.dataSource = _notifyDataSource;
    _tableView.delegate = self;
    _tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:_tableView];
    
    [self loadData];
}


#pragma mark UITableView delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    id <BaseTableViewDataSource> dataSource = (id <BaseTableViewDataSource> )tableView.dataSource;
    
    id    object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    Class cls = [dataSource tableView:tableView cellClassForObject:object];
    
    return [cls tableView:tableView rowHeightForObject:object];
}


- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)loadData
{
    [self showChrysanthemumHUD:YES];
    __weak typeof(self) weakSelf = self;
    [MyRequestManager getNotificationList:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        BaseTableViewSectionObject* section =  [weakSelf.notifyDataSource.sections objectAtIndex:0];
        [section.items removeAllObjects];
        [section.items addObjectsFromArray:obj];
        [weakSelf.tableView reloadData];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
    
}

@end
