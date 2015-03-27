//
//  ListTempleViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ListTempleViewController.h"
#import "ListTempleViewDataSource.h"
#import "TempleObject.h"
#import "DiscoverManager.h"
#import "ListTempleInfoViewController.h"
#import "Reachability.h"

@interface ListTempleViewController ()<UITableViewDelegate,ListTempleViewCellDelegate>

@property (nonatomic, strong) ListTempleViewDataSource* listTempleDataSource;
@property (nonatomic, strong) UITableView* tableView;

@end

@implementation ListTempleViewController

- (UITableView*)tableView
{
    if(!_tableView)
    {
        _tableView = [[UITableView alloc] initWithFrame:self.view.frame];
        [_tableView setBackgroundColor:[UIColor clearColor]];
        _listTempleDataSource = [[ListTempleViewDataSource alloc] init];
        _listTempleDataSource.cellDelegate = self;
        _tableView.dataSource = _listTempleDataSource;
        _tableView.delegate = self;
        [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    }
    return _tableView;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self.view addSubview:self.tableView];

    [self loadMoreData:nil];
}


- (void)loadMoreData:(NSString*)tid
{
    typeof(self) weakSelf = self;
    [DiscoverManager getTempleList:self.wishType successBlock:^(id obj) {
        BaseTableViewSectionObject* sectionObject = [weakSelf.listTempleDataSource.sections objectAtIndex:0];
        [sectionObject.items addObjectsFromArray:obj];//插入数据
        [weakSelf.tableView reloadData];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
    
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
    if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
    {
        [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
        return;
    }
    
    id <BaseTableViewDataSource> dataSource = (id <BaseTableViewDataSource> )tableView.dataSource;
    
    id    object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    ListTempleInfoViewController* infoController = [[ListTempleInfoViewController alloc] init];
    infoController.wishType = self.wishType;
    infoController.templeObject = object;
    infoController.title = ((TempleObject*)object).templeName;
    [self.navigationController pushViewController:infoController animated:YES];
}

#pragma ListTempleDelegate
- (void)clickCell:(ListTempleViewCell*)cell
{
    if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
    {
        [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
        return;
    }
    
    ListTempleInfoViewController* infoController = [[ListTempleInfoViewController alloc] init];
    infoController.wishType = self.wishType;
    infoController.templeObject = cell.object;
    infoController.title = ((TempleObject*)cell.object).templeName;
    [self.navigationController pushViewController:infoController animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

@end
