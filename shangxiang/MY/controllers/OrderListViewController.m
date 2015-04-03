//
//  OrderListViewController.m
//  shangxiang
//
//  Created by limingchen on 15/4/3.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderListViewController.h"
#import "ORderRecorderDataSource.h"
#import "MyRequestManager.h"
#import "WillingObject.h"
#import "OrderInfoViewController.h"
#import "Reachability.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreFooterView.h"

#define Page_Number_Count   15//  每页拉去十条

@interface OrderListViewController ()<UITableViewDelegate,OrderRecordViewCellDelegate,LoadMoreFooterViewDelegate,EGORefreshTableHeaderDelegate>
{
    BOOL _reloading;//是否加载或者刷新
    NSInteger _currentPage;//当前页面
}
@property (nonatomic,strong) UITableView* willTableView;
@property (nonatomic,strong) ORderRecorderDataSource* willDataSouce;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) LoadMoreFooterView *loadMoreFooterView;

@end

@implementation OrderListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    
    _willTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - 50 - TarbarHeight - NaiviagationHeight)];
    [_willTableView setBackgroundColor:[UIColor clearColor]];
    _willDataSouce = [[ORderRecorderDataSource alloc] init];
    _willDataSouce.cellDelegate = self;
    _willTableView.dataSource = _willDataSouce;
    _willTableView.delegate = self;
    _willTableView.scrollEnabled = YES;
    _willTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([_willTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        _willTableView.separatorInset = UIEdgeInsetsZero;
    }
    
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _willTableView.bounds.size.height, _willTableView.frame.size.width, _willTableView.bounds.size.height)];
        headerView.delegate = self;
        [_willTableView addSubview:headerView];
        _refreshHeaderView = headerView;
        [_refreshHeaderView refreshLastUpdatedDate];
        [_refreshHeaderView setFirstFresh:_willTableView];
    }
    
    
    if (_loadMoreFooterView == nil)
    {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        _loadMoreFooterView.delegate = self;
        _willTableView.tableFooterView = _loadMoreFooterView;
        _willTableView.tableFooterView.hidden = YES;
    }
    
    [self.view addSubview:_willTableView];
    [self refresh];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)refresh
{
    _reloading = YES;
    _currentPage = 1;
    [self requestRefreshData];
}


- (void)loadMoreData:(NSString*)tid
{
    if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
    {
        [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
        [self doneLoadMoreData];
        return;
    }
    typeof(self) weakSelf = self;
    
    NSString* also = self.isWill ? @"0" : @"1";
    
    [MyRequestManager getMemerOrderList:USEROPERATIONHELP.currentUser.userId also:also page:_currentPage pageCount:Page_Number_Count successBlock:^(id obj) {
        BaseTableViewSectionObject* section = [weakSelf.willDataSouce.sections objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^
       {
           [section.items addObjectsFromArray:obj];//插入数据
           [weakSelf.willTableView reloadData];
           [weakSelf doneLoadMoreData];
           if(!obj || [obj count] < Page_Number_Count)
           {
               [_loadMoreFooterView setState:LoadMoreNoData];//无更多数据
           }
       });
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
        [weakSelf doneLoadMoreData];
        [_loadMoreFooterView setState:LoadMoreNoData];//无更多数据
    }];
}

- (void)requestRefreshData
{
    if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
    {
        [self showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
        [self doneRefreshData];
        return;
    }
    typeof(self) weakSelf = self;
    
    [_loadMoreFooterView setState:LoadMoreNormal];
    NSString* also = self.isWill ? @"0" : @"1";
    [MyRequestManager getMemerOrderList:USEROPERATIONHELP.currentUser.userId also:also page:_currentPage pageCount:Page_Number_Count successBlock:^(id obj) {
        BaseTableViewSectionObject* section = [weakSelf.willDataSouce.sections objectAtIndex:0];
        dispatch_async(dispatch_get_main_queue(), ^
           {
               [weakSelf doneRefreshData];
               [section.items removeAllObjects];
               [section.items addObjectsFromArray:obj];
               [weakSelf.willTableView reloadData];
               [weakSelf.willTableView scrollToTopAnimated:NO];
           });
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
        [weakSelf doneRefreshData];
    }];
    
}

#pragma mark - UIScrollView delegate method

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [_refreshHeaderView egoRefreshScrollViewDidScroll:scrollView];
    [_loadMoreFooterView loadMoreScrollViewDidScroll:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate{
    
    [_refreshHeaderView egoRefreshScrollViewDidEndDragging:scrollView];
}


#pragma mark - EGORefreshTableHeaderDelegate methods

- (void)egoRefreshTableHeaderDidTriggerRefresh:(EGORefreshTableHeaderView *)view
{
    if(!_reloading)
    {
        _reloading = YES;
        _currentPage = 1;
        [self requestRefreshData];
    }
}

- (BOOL)egoRefreshTableHeaderDataSourceIsLoading:(EGORefreshTableHeaderView *)view
{
    return _reloading;
}

- (NSDate *)egoRefreshTableHeaderDataSourceLastUpdated:(EGORefreshTableHeaderView *)view
{
    return [NSDate date];
}

#pragma mark - LoadMoreFooterView delegate method

- (void)loadMoreTableFooterDidTriggerRefresh:(LoadMoreFooterView *)view
{
    if(!_reloading)
    {
        _reloading = YES;
        _currentPage ++ ;
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.loadMoreFooterView setHidden:NO];
        });
        
        [self loadMoreData:nil];
    }
}
- (BOOL)loadMoreTableFooterDataSourceIsLoading:(LoadMoreFooterView *)view
{
    return _reloading;
}


- (void)doneLoadMoreData
{
    if (_reloading)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_willTableView];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_willTableView];
    }
}

- (void)doneRefreshData
{
    if (_reloading)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_willTableView];
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

#pragma OrderCellDelegate
- (void)deleteCell:(OrderRecordViewCell*)cell
{
    [self showChrysanthemumHUD:YES];
    __weak typeof(self) weakSelf = self;
    __weak OrderRecordViewCell* weakCell = cell;
    
    WillingObject* willingObject = (WillingObject*)cell.object;
    [MyRequestManager deleteOrder:willingObject.orderId successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        BaseTableViewSectionObject* section = [_willDataSouce.sections objectAtIndex:0];
        [section.items removeObjectAtIndex:weakCell.indexPath.row];
        [weakSelf.willTableView reloadData];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

- (void)clickCell:(OrderRecordViewCell*)cell
{
    OrderInfoViewController* infoViewController = [[OrderInfoViewController alloc] init];
    infoViewController.orderId = ((WillingObject*)cell.object).orderId;
    infoViewController.isWilling = self.isWill;
    [self.navigationController pushViewController:infoViewController animated:YES];
}

- (void)dealloc
{
    _willTableView.dataSource = nil;
    _willTableView.delegate = nil;
}


@end
