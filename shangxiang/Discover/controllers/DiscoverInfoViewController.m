//
//  DiscoverInfoViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/22.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "DiscoverInfoViewController.h"
#import "DiscoverManager.h"
#import "DiscoverInfoDataSource.h"
#import "DiscoverViewCell.h"
#import "CreateOrderViewController.h"
#import "OrderInfoObject.h"
#import "DiscoverManager.h"

@interface DiscoverInfoViewController ()<UITableViewDelegate,DiscoverDelegate>

@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) DiscoverInfoDataSource* discoverInfoDataSouce;

@end

@implementation DiscoverInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    self.title = @"查看祈福";
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height - NaiviagationHeight)];
    [_tableView setBackgroundColor:[UIColor clearColor]];
    _discoverInfoDataSouce = [[DiscoverInfoDataSource alloc] init];
    _tableView.dataSource = _discoverInfoDataSouce;
    _tableView.delegate = self;
    DiscoverViewCell* tableHeaderView = [[DiscoverViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"tableHeaderView"];
    
    UIButton* button = [[UIButton alloc] initWithFrame:CGRectMake(_tableView.width - 20 - 100, 10, 100, 30)];
    [button setTitle:@"同愿祈福" forState:UIControlStateNormal];
    [button.layer setCornerRadius:3];
    [button setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [button setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [button setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [button addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [tableHeaderView addSubview:button];
    
    [tableHeaderView setFrame:CGRectMake(0, 0, _tableView.width, [DiscoverViewCell getDiscoverHeight:self.orderObject])];
    [tableHeaderView setObject:self.orderObject];
    [tableHeaderView setCellDelegate:self];
    _tableView.tableHeaderView = tableHeaderView;
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self.view addSubview:_tableView];
    
    [self loadData];
}

- (void)loadData
{
    [self showChrysanthemumHUD:YES];
    typeof(self) weakSelf = self;
    [DiscoverManager getOrderInfoByBlessNumber:self.orderObject.orderId successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        BaseTableViewSectionObject* section =  [weakSelf.discoverInfoDataSouce.sections objectAtIndex:0];
        [section.items removeAllObjects];
        [section.items addObjectsFromArray:obj];
        [weakSelf.tableView reloadData];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)buttonClicked:(UIButton*)button
{
    if(!USEROPERATIONHELP.isLogin)
    {
        [APPNAVGATOR turnToLoginGuide];
        return;
    }
    
    [self showChrysanthemumHUD:YES];
    __weak typeof(self) weakSelf = self;
    
    [DiscoverManager getOrderInfo:self.orderObject.orderId successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        OrderInfoObject* infoObject = obj;
        TempleObject* templeObject = [[TempleObject alloc] init];
        templeObject.templeId = weakSelf.orderObject.tid;
        templeObject.templeName = weakSelf.orderObject.templeName;
        templeObject.templeProvince = infoObject.province;
        templeObject.templeSmallUrl = infoObject.templeThumb;
        templeObject.attacheName = infoObject.builddhistName;
        templeObject.attacheSmallUrl = infoObject.builddHistThumb;
        CreateOrderViewController* viewController = [[CreateOrderViewController alloc] init];
        viewController.templeObject = templeObject;
        viewController.wishType = [LUtility getWishType:infoObject.wishType];
        [weakSelf.navigationController pushViewController:viewController animated:YES];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
    
   
}

- (void)loadOrderInfoData
{
    
    
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
        [weakSelf.orderCell setBlessSuccess];
        [weakSelf loadData];
        if(obj)  [weakSelf showTimedHUD:YES message:obj];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

@end
