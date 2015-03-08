//
//  OrderRecordViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderRecordViewController.h"
#import "ORderRecorderDataSource.h"
#import "MyRequestManager.h"
#import "WillingObject.h"
#import "OrderInfoViewController.h"

@interface OrderRecordViewController ()<UITableViewDelegate,OrderRecordViewCellDelegate>
{
    UISegmentedControl* _segSwitch;
    UIScrollView* _scrollView;
    NSInteger _requestCount;
}

@property (nonatomic,strong) UITableView* willTableView;
@property (nonatomic,strong) UITableView* redeemTableview;
@property (nonatomic,strong) ORderRecorderDataSource* willDataSouce;
@property (nonatomic,strong) ORderRecorderDataSource* redeemDataSouce;

@end

@implementation OrderRecordViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.title = @"我的订单";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    
    UIView* selectView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 50)];
    [selectView setBackgroundColor:[UIColor clearColor]];
    
    _segSwitch = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"求愿单", @"还愿单", nil]];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(COLOR_FONT_FORM_NORMAL), NSForegroundColorAttributeName, [UIFont systemFontOfSize:14.f], NSFontAttributeName, nil];
    NSDictionary* SelectTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:14.f], NSFontAttributeName, nil, NSShadowAttributeName, nil];
    [_segSwitch setFrame:CGRectMake(10, 10, selectView.width - 20, 30)];
    [_segSwitch setTintColor:[UIColor clearColor]];
    [_segSwitch setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [_segSwitch setTitleTextAttributes:SelectTextAttributes forState:UIControlStateSelected];
    [_segSwitch setTitleTextAttributes:SelectTextAttributes forState:UIControlStateHighlighted];
    [_segSwitch setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_GRAY)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segSwitch setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_PRESSED)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segSwitch setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_PRESSED)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [_segSwitch setDividerImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_BG_NORMAL)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segSwitch.layer setMasksToBounds:YES];
    [_segSwitch setSelectedSegmentIndex:0];
    [_segSwitch addTarget:self action:@selector(switchShow:) forControlEvents:UIControlEventValueChanged];
    [selectView addSubview:_segSwitch];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, 49.5, self.view.width, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [selectView addSubview:line];
    
    [self.view addSubview:selectView];
    
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, selectView.bottom, self.view.width, self.view.height - selectView.bottom - 64)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setAlwaysBounceVertical:NO];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setPagingEnabled:NO];
    [_scrollView setContentSize:CGSizeMake(_scrollView.width * 2, _scrollView.height)];
    [self.view addSubview:_scrollView];

    
    _willTableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, _scrollView.height)];
    [_willTableView setBackgroundColor:[UIColor clearColor]];
    _willDataSouce = [[ORderRecorderDataSource alloc] init];
    _willDataSouce.cellDelegate = self;
    _willTableView.dataSource = _willDataSouce;
    _willTableView.delegate = self;
    _willTableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([_willTableView respondsToSelector:@selector(setSeparatorInset:)])
    {
        _willTableView.separatorInset = UIEdgeInsetsZero;
    }
    [_scrollView addSubview:_willTableView];
    
    _redeemTableview = [[UITableView alloc] initWithFrame:CGRectMake(_scrollView.width, 0, _scrollView.width, _scrollView.height)];
    [_redeemTableview setBackgroundColor:[UIColor clearColor]];
    _redeemDataSouce = [[ORderRecorderDataSource alloc] init];
    _redeemDataSouce.cellDelegate = self;
    _redeemTableview.dataSource = _redeemDataSouce;
    _redeemTableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    if ([_redeemTableview respondsToSelector:@selector(setSeparatorInset:)])
    {
        _redeemTableview.separatorInset = UIEdgeInsetsZero;
    }
    [_scrollView addSubview:_redeemTableview];
    
    [self loadData];
    
}


- (void)loadData
{
    [self showChrysanthemumHUD:YES];
    typeof(self) weakSelf = self;
    _requestCount = 0;
    [MyRequestManager getMemerOrderList:USEROPERATIONHELP.currentUser.userId also:@"0" page:1 pageCount:-1 successBlock:^(id obj) {
        _requestCount ++ ;
        BaseTableViewSectionObject* section = [weakSelf.willDataSouce.sections objectAtIndex:0];
        [section.items removeAllObjects];
        [section.items addObjectsFromArray:obj];
        [weakSelf.willTableView reloadData];
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
        }
    } failed:^(id error)
    {
        _requestCount ++;
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
            //[weakSelf dealWithError:error];
        }
    }];
    
    [MyRequestManager getMemerOrderList:USEROPERATIONHELP.currentUser.userId also:@"1" page:1 pageCount:-1 successBlock:^(id obj) {
        _requestCount ++ ;
        BaseTableViewSectionObject* section = [weakSelf.redeemDataSouce.sections objectAtIndex:0];
        [section.items removeAllObjects];
        [section.items addObjectsFromArray:obj];
        [weakSelf.redeemTableview reloadData];
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
        }
    } failed:^(id error)
    {
        _requestCount ++;
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
            //[weakSelf dealWithError:error];
        }
    }];
    
}



- (void)dealloc
{
    _willTableView.dataSource = nil;
    _willTableView.delegate = nil;
    _redeemTableview.dataSource = nil;
    _redeemTableview.delegate = nil;
}

- (void)switchShow:(UISegmentedControl*)segment
{
    switch (segment.selectedSegmentIndex)
    {
        case 0:
            [_scrollView setContentOffset:CGPointMake(0, 0) animated:YES];
            break;
        case 1:
            [_scrollView setContentOffset:CGPointMake(_scrollView.width, 0) animated:YES];
            break;
        default:
            
            break;
    }
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"sfd");
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
    infoViewController.isWilling = _segSwitch.selectedSegmentIndex == 0 ? YES : NO;
    [self.navigationController pushViewController:infoViewController animated:YES];
}

@end
