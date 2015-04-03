//
//  ShareViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ShareViewController.h"
#import "LookOrderViewCell.h"
#import "LookOrderDataSource.h"
#import "DiscoverManager.h"
#import "OrderObject.h"
#import "ShareView.h"
#import "OrderInfoViewController.h"
#import "OrderInfoObject.h"

@interface ShareViewController ()<UITableViewDelegate,LookOrderDelegate>

@property (nonatomic, strong) LookOrderDataSource* orderDataSource;
@property (nonatomic, strong) UITableView* tableView;
@property (nonatomic, strong) ShareView* shareView;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = UIColorFromRGB(0xf5f5f5);
    
    UIImageView* backGroundImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.view.width - 216)/2, 0, 216, 167)];
    [backGroundImageView setImage:[UIImage imageForKey:@"share_background"]];
    [backGroundImageView setBackgroundColor:UIColorRGB(245, 245, 245)];
    [self.view addSubview:backGroundImageView];
    
    UIView* buttonView = [[UIView alloc] initWithFrame:CGRectMake(0, 200, self.view.width, 30)];
    [buttonView setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:buttonView];
    
    UIButton* lookButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 0, 100, 30)];
    [lookButton setBackgroundColor:UIColorFromRGB(0xc7c6c9)];
    [lookButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [lookButton setTitle:@"查看订单" forState:UIControlStateNormal];
    [lookButton addTarget:self action:@selector(lookButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:lookButton];
    
    
    UIButton* shareButton = [[UIButton alloc] initWithFrame:CGRectMake(self.view.width - 20 - 100, 0, 100, 30)];
    [shareButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareButton setBackgroundColor:UIColorFromRGB(0xebebeb)];
    [shareButton setTitle:@"分享" forState:UIControlStateNormal];
    [shareButton addTarget:self action:@selector(shareButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [buttonView addSubview:shareButton];
    
    _tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, buttonView.bottom + 20, self.view.width, self.view.height - self.tableView.top)];
    [_tableView setBackgroundColor:self.view.backgroundColor];
    [_tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    _orderDataSource = [[LookOrderDataSource alloc] init];
    _orderDataSource.cellDelegate = self;
    _tableView.dataSource = _orderDataSource;
    _tableView.delegate = self;
    [self.view addSubview:_tableView];
    
    _shareView = [ShareView new];
    __weak typeof(self) weakSelf = self;
    _shareView.shareBlock = ^(WxType type, NSString* shareText)
    {
        if(!shareText || shareText.length == 0)
        {
            [APPNAVGATOR showAlert:@"请输入分享内容" Message:nil];
        }
        else
        {
            if(type == WxType_Weibo)
            {
                [weakSelf sendWeiboContent:shareText];
            }
            else
            {
                [weakSelf sendLinkContent:type text:shareText];
            }
        }
    };
    
    [self loadData];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(shareSuccess) name:ShareSuccessNotification object:nil];
}

- (void)lookButtonClicked:(UIButton*)button
{
    OrderInfoViewController* infoViewController = [[OrderInfoViewController alloc] init];
    infoViewController.orderId = self.orderId;
    [self.navigationController pushViewController:infoViewController animated:YES];
}

- (void)shareSuccess
{
    [_shareView close];
}


- (void)sendWeiboContent:(NSString*)text
{
    
    WBAuthorizeRequest *authRequest = [WBAuthorizeRequest request];
    authRequest.redirectURI = kRedirectURI;
    authRequest.scope = @"all";
    
    WBSendMessageToWeiboRequest *request = [WBSendMessageToWeiboRequest requestWithMessage:[self messageToShare:text]];
    request.message = [self messageToShare:text];
    request.userInfo = @{@"ShareMessageFrom": @"SendMessageToWeiboViewController",
                         @"Other_Info_1": [NSNumber numberWithInt:123],
                         @"Other_Info_2": @[@"obj1", @"obj2"],
                         @"Other_Info_3": @{@"key1": @"obj1", @"key2": @"obj2"}};
    //    request.shouldOpenWeiboAppInstallPageIfNotInstalled = NO;
    [WeiboSDK sendRequest:request];
}


- (WBMessageObject *)messageToShare:(NSString*)text
{
    WBMessageObject *message = [WBMessageObject message];
    


    WBWebpageObject *webpage = [WBWebpageObject object];
    webpage.objectID = @"identifier1";
    webpage.title = text;
    webpage.description = @"上香";
    webpage.thumbnailData = UIImageJPEGRepresentation([UIImage imageForKey:@"logo"], 0.7);
    webpage.webpageUrl = @"http://shangxiang.com";
    message.mediaObject = webpage;
    
    
    return message;
}

- (void)sendLinkContent:(WxType)type text:(NSString*)shareText
{
    WXMediaMessage *message = [WXMediaMessage message];
    message.title = shareText;
//    message.description = shareText;
    [message setThumbImage:[UIImage imageForKey:@"logo"]];
    
    WXWebpageObject *ext = [WXWebpageObject object];
    ext.webpageUrl = @"http://shangxiang.com";
    
    message.mediaObject = ext;
    message.mediaTagName = @"WECHAT_TAG_JUMP_SHOWRANK";
    
    SendMessageToWXReq* req = [[SendMessageToWXReq alloc] init];
    req.bText = NO;
    req.message = message;
    if(type == WxType_Friend)
    {
        req.scene = WXSceneTimeline;
    }
    else
    {
        req.scene = WXSceneSession;
    }
    [WXApi sendReq:req];
}


- (void)shareButtonClicked:(UIButton*)button
{
    [_shareView showInWindow:self.view.window orderText:self.orderContentText];
}

- (void)loadData
{
    //获取最新n条
    [self showChrysanthemumHUD:YES];
    __weak typeof(self) weakSelf = self;
    
    [DiscoverManager getDiscoverList:nil pageNumber:1 numberCount:10 bless:BelssType_None successBlock:^(id obj) {
        NSMutableArray* orderArray = (NSMutableArray*)obj;
        if(orderArray && orderArray.count > 0)
        {
            __block NSInteger requestCount = 0;
            __block CGFloat totalHeight = 0;
            for(OrderObject* object in orderArray)
            {
                __block BaseTableViewSectionObject* section = [weakSelf.orderDataSource.sections objectAtIndex:0];
                [DiscoverManager getOrderInfo:object.orderId successBlock:^(id obj) {
                    requestCount ++;
                    CGFloat cellHeight = [LookOrderViewCell getCellHeight:obj];
                    totalHeight += cellHeight;
                    if(totalHeight <= weakSelf.view.height - weakSelf.tableView.top)
                    {
                        [section.items addObject:obj];
                    }
                    if(requestCount == orderArray.count)
                    {
                        [weakSelf.tableView reloadData];
                        [weakSelf removeAllHUDViews:YES];
                    }
                } failed:^(id error) {
                    requestCount ++;
                    if(requestCount == orderArray.count)
                    {
                        [weakSelf removeAllHUDViews:YES];
                    }
                }];
            }
        }
        else
        {
            [weakSelf removeAllHUDViews:YES];
        }
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
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
    [_shareView showInWindow:self.view.window orderText:self.orderContentText];
}

#pragma LookDelegate
- (void)shareText:(LookOrderViewCell*)cell
{
    [_shareView showInWindow:self.view.window orderText:((OrderInfoObject*)cell.object).wishText];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    _tableView.dataSource = nil;
    _tableView.delegate = nil;
}

- (void)goBack
{
    if(USEROPERATIONHELP.isLogin)
    {
        [APPNAVGATOR turnToOrderRecordPage];
    }
    else
    {
        [APPNAVGATOR calendarTurnWillingGuide];
    }
}

@end
