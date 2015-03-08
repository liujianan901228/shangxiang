#import "DiscoverViewController.h"
#import "DiscoverManager.h"
#import "DiscoverTableViewDataSource.h"
#import "EGORefreshTableHeaderView.h"
#import "LoadMoreFooterView.h"
#import "OrderObject.h"
#import "DiscoverPopView.h"
#import "DiscoverInfoViewController.h"
#import "Reachability.h"

#define Page_Number_Count   10//  每页拉去十条

@interface DiscoverViewController ()<UITableViewDelegate,LoadMoreFooterViewDelegate,EGORefreshTableHeaderDelegate,DiscoverDelegate>
{
    BOOL _reloading;//是否加载或者刷新
    NSInteger _currentPage;//当前页面
    NSString* _tid;//当前寺庙的ID
    UIButton* _buttonTitle ;
}

@property (nonatomic, strong) UITableView* taleviw;
@property (nonatomic, strong) DiscoverTableViewDataSource* discoverDataSource;
@property (nonatomic, strong) EGORefreshTableHeaderView *refreshHeaderView;
@property (nonatomic, strong) LoadMoreFooterView *loadMoreFooterView;
@property (nonatomic, strong) DiscoverPopView* popView;
@property (nonatomic, assign) NSInteger selectIndex;//选中

@end

@implementation DiscoverViewController


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    NSInteger tableViewHeight = 0;
    
    if(!self.isNoFilter)
    {
        _buttonTitle = [[UIButton alloc] initWithFrame:CGRectZero];
        [_buttonTitle setTitle:@"全部道场" forState:UIControlStateNormal];
        [_buttonTitle setTitleEdgeInsets:UIEdgeInsetsMake(0, -30, 0, 30)];
        [_buttonTitle setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateNormal];
        [_buttonTitle.titleLabel setFont:[UIFont systemFontOfSize:18]];
        [_buttonTitle.titleLabel setTextAlignment:NSTextAlignmentCenter];
        [_buttonTitle setImage:[UIImage imageForKey:@"arrow_bottom"] forState:UIControlStateNormal];
        [_buttonTitle setImageEdgeInsets:UIEdgeInsetsMake(0, 65, 0, -65)];
        [_buttonTitle sizeToFit];
        [_buttonTitle addTarget:self action:@selector(showTemp) forControlEvents:UIControlEventTouchUpInside];
        self.navigationItem.titleView = _buttonTitle;
        
        typeof(self) weakSelf = self;
        _popView = [[DiscoverPopView alloc] initWithActionBlock:^(TempleObject* object,NSInteger index) {
            //点击了换tid
            weakSelf.selectIndex = index;
            [weakSelf->_buttonTitle setTitle:object.templeName forState:UIControlStateNormal];
            weakSelf->_tid = object.templeId;
            [weakSelf requestRefreshData];
            [weakSelf.popView closePopView];
        }];
        [self requestTempleList];
        
        tableViewHeight = self.view.height - TarbarHeight - NaiviagationHeight;
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiscoverList:) name:AppUserLoginNotification object:nil];
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateDiscoverList:) name:AppUserLogoutNotification object:nil];
    }
    else
    {
        if(self.blessType == BelssType_Dobless)
        {
            self.title = @"我的加持";
            tableViewHeight = self.view.height  - NaiviagationHeight;
        }
        else if(self.blessType == BelssType_Receive)
        {
            self.title = @"为我加持";
            tableViewHeight = self.view.height  - NaiviagationHeight;
        }
    }
    
    _taleviw = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, tableViewHeight)];
    [_taleviw setBackgroundColor:[UIColor clearColor]];
    _discoverDataSource = [[DiscoverTableViewDataSource alloc] init];
    _discoverDataSource.delegate = self;
    _taleviw.dataSource = _discoverDataSource;
    _taleviw.delegate = self;
    [_taleviw setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    
    if(_refreshHeaderView == nil)
    {
        EGORefreshTableHeaderView *headerView = [[EGORefreshTableHeaderView alloc] initWithFrame:CGRectMake(0.0f, 0.0f - _taleviw.bounds.size.height, _taleviw.frame.size.width, _taleviw.bounds.size.height)];
        headerView.delegate = self;
        [_taleviw addSubview:headerView];
        _refreshHeaderView = headerView;
        [_refreshHeaderView refreshLastUpdatedDate];
        [_refreshHeaderView setFirstFresh:_taleviw];
    }
    
    
    if (_loadMoreFooterView == nil)
    {
        _loadMoreFooterView = [[LoadMoreFooterView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 40)];
        _loadMoreFooterView.delegate = self;
        _taleviw.tableFooterView = _loadMoreFooterView;
        _taleviw.tableFooterView.hidden = YES;
    }
    
    [self.view addSubview:_taleviw];
    
    _reloading = YES;
    _currentPage = 1;
    [self requestRefreshData];
}


- (void)updateDiscoverList:(NSNotification*)notification
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
    [DiscoverManager getDiscoverList:_tid pageNumber:_currentPage numberCount:Page_Number_Count bless:self.blessType successBlock:^(id obj) {
        BaseTableViewSectionObject* sectionObject = [weakSelf.discoverDataSource.sections objectAtIndex:0];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [sectionObject.items addObjectsFromArray:obj];//插入数据
            [weakSelf.taleviw reloadData];
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
    [DiscoverManager getDiscoverList:_tid pageNumber:_currentPage numberCount:Page_Number_Count bless:self.blessType successBlock:^(id obj) {
        [weakSelf doneRefreshData];
        BaseTableViewSectionObject* sectionObject = [weakSelf.discoverDataSource.sections objectAtIndex:0];
        [sectionObject.items removeAllObjects];
        [sectionObject.items addObjectsFromArray:obj];
        dispatch_async(dispatch_get_main_queue(), ^{
            [weakSelf.taleviw reloadData];
        });
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
        [weakSelf doneRefreshData];
    }];
    
}

- (void)requestTempleList
{
    typeof(self) weakSelf = self;
    [DiscoverManager getTempleList:^(id obj) {

        BaseTableViewSectionObject* section = [weakSelf.popView.discoverPopDataSource.sections objectAtIndex:0];
        [section.items removeAllObjects];
        TempleObject* object = [[TempleObject alloc] init];
        object.templeName = @"全部道场";
        object.templeId = nil;
        [section.items addObject:object];
        [section.items addObjectsFromArray:obj];
    } failed:^(id error) {
         NSLog(@"dsf");
    }];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _taleviw.delegate = nil;
    _taleviw.dataSource = nil;
    _refreshHeaderView.delegate = nil;
    _loadMoreFooterView.delegate = nil;
}

//显示道场
- (void)showTemp
{
    self.popView.discoverPopDataSource.selectIndex = _selectIndex;
    [self.popView showPopViewInWindow:self.view.window];
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
    id <BaseTableViewDataSource> dataSource = (id <BaseTableViewDataSource> )tableView.dataSource;
    DiscoverViewCell* cell = (DiscoverViewCell*)[tableView cellForRowAtIndexPath:indexPath];
    id    object = [dataSource tableView:tableView objectForRowAtIndexPath:indexPath];
    
    DiscoverInfoViewController* infoViewContrller = [[DiscoverInfoViewController alloc] init];
    infoViewContrller.orderObject = object;
    infoViewContrller.orderCell = cell;
    [self.navigationController pushViewController:infoViewContrller animated:YES];
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
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_taleviw];
        [_loadMoreFooterView loadMoreshScrollViewDataSourceDidFinishedLoading:_taleviw];
    }
}

- (void)doneRefreshData
{
    if (_reloading)
    {
        _reloading = NO;
        [_refreshHeaderView egoRefreshScrollViewDataSourceDidFinishedLoading:_taleviw];
    }
}

#pragma DiscoverCell Delegate
- (void)didClickAddBelss:(DiscoverViewCell*)cell
{
    if(!USEROPERATIONHELP.isLogin)
    {
        [APPNAVGATOR turnToLoginGuide];
        return;
    }
    typeof(self) weakSelf = self;
    [self showChrysanthemumHUD:YES];
    [DiscoverManager addBlessingsdo:((OrderObject*)cell.object).orderId userId:USEROPERATIONHELP.currentUser.userId successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        ((OrderObject*)cell.object).isBelss = YES;
        [cell setBlessSuccess];
        if(obj)  [weakSelf showTimedHUD:YES message:obj];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

@end