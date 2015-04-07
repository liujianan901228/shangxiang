//
//  OrderInfoViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/31.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderInfoViewController.h"
#import "DiscoverManager.h"
#import "OrderInfoObject.h"
#import "SingLineImageCollectionView.h"
#import "CreateVotiveViewController.h"
#import "ListTempleManager.h"
#import "GradeInfoObject.h"
#import "LFFGPhotoAlbumView.h"
#import "PayInfoViewController.h"

@interface OrderInfoViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) OrderInfoObject* infoObject;
@property (nonatomic, strong) SingLineImageCollectionView* viewHallThumb;
@property (nonatomic, strong) UILabel* wishGradeLabel;
@property (nonatomic, strong) GradeInfoObject* gradeInfo;

@end

@implementation OrderInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"订单详情";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    [self setupForDismissKeyboard];
    
    [self loadData];
}


- (void)setup
{
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, self.view.height)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setScrollEnabled:YES];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setAutoresizingMask:UIViewAutoresizingFlexibleHeight];
    [self.view addSubview:_scrollView];
    
    UILabel* orderNumberLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 15, self.view.width - 40, 20)];
    [orderNumberLabel setNumberOfLines:1];
    [orderNumberLabel setBackgroundColor:[UIColor clearColor]];
    [orderNumberLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [orderNumberLabel setFont:[UIFont systemFontOfSize:14]];
    [orderNumberLabel setTextColor:UIColorFromRGB(0x808080)];
    [orderNumberLabel setText:[NSString stringWithFormat:@"订单号 : %@",self.infoObject.orderLongId]];
    [_scrollView addSubview:orderNumberLabel];
    
    UILabel* nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, orderNumberLabel.bottom + 5, self.view.width - 40, 20)];
    [nameLabel setNumberOfLines:1];
    [nameLabel setBackgroundColor:[UIColor clearColor]];
    [nameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [nameLabel setFont:[UIFont systemFontOfSize:16]];
    [nameLabel setTextColor:UIColorFromRGB(0x767676)];
    [nameLabel setText:[NSString stringWithFormat:@"%@   %@%@",self.infoObject.wishName,self.infoObject.alsoWish,self.infoObject.wishType]];
    [_scrollView addSubview:nameLabel];
    
    UIView* lineView = [[UIView alloc] initWithFrame:CGRectMake(0, nameLabel.bottom + 5, self.view.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [_scrollView addSubview:lineView];
    
    UILabel* templeNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.bottom + 10, (self.view.width - 40) / 2, 20)];
    [templeNameLabel setNumberOfLines:1];
    [templeNameLabel setBackgroundColor:[UIColor clearColor]];
    [templeNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [templeNameLabel setFont:[UIFont systemFontOfSize:14]];
    NSMutableAttributedString* templeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"寺庙: %@",self.infoObject.templeName]];
    [templeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSRangeMake(0, 4)];
    [templeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, 4)];
    [templeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x808080) range:NSRangeMake(4, self.infoObject.templeName.length)];
    [templeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSRangeMake(4, self.infoObject.templeName.length)];
    [templeNameLabel setAttributedText:templeString];
    [_scrollView addSubview:templeNameLabel];
    
    
    UILabel* attchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 150, lineView.bottom + 10, 100, 20)];
    [attchNameLabel setNumberOfLines:1];
    [attchNameLabel setBackgroundColor:[UIColor clearColor]];
    [attchNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [attchNameLabel setFont:[UIFont systemFontOfSize:14]];
    
    NSMutableAttributedString* attchString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"法师: %@",self.infoObject.builddhistName]];
    [attchString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSRangeMake(0, 4)];
    [attchString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, 4)];
    [attchString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x808080) range:NSRangeMake(4, self.infoObject.builddhistName.length)];
    [attchString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSRangeMake(4, self.infoObject.builddhistName.length)];
    
    [attchNameLabel setAttributedText:attchString];
    [_scrollView addSubview:attchNameLabel];
    
    
    
    _wishGradeLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, templeNameLabel.bottom + 5, (self.view.width - 40) / 2, 20)];
    [_wishGradeLabel setNumberOfLines:1];
    [_wishGradeLabel setBackgroundColor:[UIColor clearColor]];
    [_wishGradeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [_wishGradeLabel setFont:[UIFont systemFontOfSize:14]];
    NSMutableAttributedString* wishGradeString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"香烛: %@",self.infoObject.wishGrade]];
    [wishGradeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSRangeMake(0, 4)];
    [wishGradeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, 4)];
    [wishGradeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x808080) range:NSRangeMake(4, self.infoObject.wishGrade.length)];
    [wishGradeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSRangeMake(4, self.infoObject.wishGrade.length)];
    [_wishGradeLabel setAttributedText:wishGradeString];
    [_scrollView addSubview:_wishGradeLabel];
    
    
    UILabel* dateLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.view.width - 150, templeNameLabel.bottom + 5, 150, 20)];
    [dateLabel setNumberOfLines:1];
    [dateLabel setBackgroundColor:[UIColor clearColor]];
    [dateLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [dateLabel setFont:[UIFont systemFontOfSize:14]];
    
    NSDate *confromTimesp = [NSDate dateWithTimeIntervalSince1970:self.infoObject.retime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy年MM月dd日"];

    NSMutableAttributedString* dateString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"时间: %@",[formatter stringFromDate:confromTimesp]]];
    [dateString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSRangeMake(0, 4)];
    [dateString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, 4)];
    [dateString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x808080) range:NSRangeMake(4, [formatter stringFromDate:confromTimesp].length)];
    [dateString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSRangeMake(4, [formatter stringFromDate:confromTimesp].length)];
    
    [dateLabel setAttributedText:dateString];
    [_scrollView addSubview:dateLabel];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, dateLabel.bottom + 10, self.view.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [_scrollView addSubview:lineView];
    
    UIView* contentLabelView = [[UIView alloc] initWithFrame:CGRectMake(15, lineView.bottom, self.view.width - 40, 75)];
    [contentLabelView setBackgroundColor:[UIColor clearColor]];
    [_scrollView addSubview:contentLabelView];
    
    UITextView* textView = [[UITextView alloc] initWithFrame:CGRectMake(0, 0, contentLabelView.width, contentLabelView.height)];
    [textView setBackgroundColor:[UIColor clearColor]];
    [textView setFont:[UIFont systemFontOfSize:15]];
    
    if(self.infoObject.wishText && self.infoObject.wishText.length > 0)
    {
        NSMutableAttributedString* contentString = [[NSMutableAttributedString alloc] initWithString:[NSString stringWithFormat:@"祈求内容: %@",self.infoObject.wishText]];
        
        [contentString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSRangeMake(0, 6)];
        [contentString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, 6)];
        [contentString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x808080) range:NSRangeMake(6, self.infoObject.wishText.length)];
        [contentString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSRangeMake(6, self.infoObject.wishText.length)];

        
        [textView setAttributedText:contentString];
    }
    [contentLabelView addSubview:textView];
    
    lineView = [[UIView alloc] initWithFrame:CGRectMake(0, contentLabelView.bottom + 10, self.view.width, 0.5)];
    [lineView setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [_scrollView addSubview:lineView];
    
    
    
    if([self.infoObject.status isEqualToString:@"已完成"])
    {
        
        if(self.infoObject.images && self.infoObject.images.count > 0)
        {
            UILabel* recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.bottom + 10, self.view.width - 40, 20)];
            [recordLabel setNumberOfLines:1];
            [recordLabel setBackgroundColor:[UIColor clearColor]];
            [recordLabel setLineBreakMode:NSLineBreakByTruncatingTail];
            [recordLabel setFont:[UIFont systemFontOfSize:15]];
            [recordLabel setTextColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT)];
            [recordLabel setText:@"代上香祈福记录"];
            [_scrollView addSubview:recordLabel];
        
        
            _viewHallThumb = [[SingLineImageCollectionView alloc] initWithFrame:CGRectMake(20, recordLabel.bottom + 20, self.view.width - 40, 72)];
            
            __weak typeof(self) weakSelf = self;
            _viewHallThumb.actionBlock = ^(TemplePictureObject* picObject,UIImageView* imageView)
            {
                NSMutableArray *infos = @[].mutableCopy;
                for (NSUInteger i = 0; i < weakSelf.infoObject.images.count && i < 9; i++)
                {
                    TemplePictureObject* object = (TemplePictureObject*)[weakSelf.infoObject.images objectAtIndex:i];
                    UIImageView *image = imageView;
                    LFFGPhotoAlbumPageInfo *info = [LFFGPhotoAlbumPageInfo new];
                    if([object.picSmallUrl isEqualToString:picObject.picSmallUrl])
                    {
                        info.thumbView = image;
                    }
                    info.thumbSize = image.size;
                    info.largeURL = object.picBigUrl;
                    NSLog(@"%@",info.largeURL);
                    //info.largeSize = photo.largeSize;
                    [infos addObject:info];
                }
                LFFGPhotoAlbumView *albumView = [LFFGPhotoAlbumView new];
                albumView.pageInfos = infos;
                [albumView showFromImageView:imageView toContainer:weakSelf.view.window];
            };
            [_viewHallThumb setBackgroundColor:[UIColor clearColor]];
            [_viewHallThumb setObject:self.infoObject.images];
            [_scrollView addSubview:_viewHallThumb];
        }
        
        if(self.isWilling && self.infoObject.isRedeem)
        {
            CGFloat offsetY = (self.infoObject.images && self.infoObject.images.count > 0) ? _viewHallThumb.bottom + 20 : lineView.bottom + 20;
            UIButton* buttonSubmitCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20,offsetY , self.view.width - 40, 40)];
            [buttonSubmitCreateOrder setTitle:@"在此还愿" forState:UIControlStateNormal];
            [buttonSubmitCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
            [buttonSubmitCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
            [buttonSubmitCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
            [buttonSubmitCreateOrder addTarget:self action:@selector(submitCreateOrder) forControlEvents:UIControlEventTouchUpInside];
            [_scrollView addSubview:buttonSubmitCreateOrder];
        }
    }
    else if([self.infoObject.status isEqualToString:@"未支付"])
    {
        UIButton* buttonSubmitCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, lineView.bottom + 20, self.view.width - 40, 40)];
        [buttonSubmitCreateOrder setTitle:@"继续支付" forState:UIControlStateNormal];
        [buttonSubmitCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
        [buttonSubmitCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
        [buttonSubmitCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
        [buttonSubmitCreateOrder addTarget:self action:@selector(pay) forControlEvents:UIControlEventTouchUpInside];
        [_scrollView addSubview:buttonSubmitCreateOrder];

    }
    else
    {
        UILabel* recordLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, lineView.bottom + 10, self.view.width - 40, 20)];
        [recordLabel setNumberOfLines:1];
        [recordLabel setBackgroundColor:[UIColor clearColor]];
        [recordLabel setLineBreakMode:NSLineBreakByTruncatingTail];
        [recordLabel setFont:[UIFont systemFontOfSize:15]];
        [recordLabel setTextColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT)];
        [recordLabel setText:@"代上香祈福记录"];
        [_scrollView addSubview:recordLabel];
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake((_scrollView.width - 63)/2, recordLabel.bottom + 20, 63, 50)];
        [imageView setBackgroundColor:[UIColor clearColor]];
        [imageView setImage:[UIImage imageForKey:@"receipt"]];
        [_scrollView addSubview:imageView];
        
        UILabel* label = [[UILabel alloc] initWithFrame:CGRectMake(0, imageView.bottom + 10, _scrollView.width, 20)];
        [label setNumberOfLines:1];
        [label setTextAlignment:NSTextAlignmentCenter];
        [label setBackgroundColor:[UIColor clearColor]];
        [label setLineBreakMode:NSLineBreakByTruncatingTail];
        [label setFont:[UIFont systemFontOfSize:14]];
        [label setTextColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT)];
        [label setText:[NSString stringWithFormat:@"预计%@回执照片",self.infoObject.expectBuddhadate]];
        [_scrollView addSubview:label];
    }
    
}

- (void)submitCreateOrder
{
    CreateVotiveViewController* viewController = [[CreateVotiveViewController alloc] init];
    viewController.infoObject = self.infoObject;
    [self.navigationController pushViewController:viewController animated:YES];
}

- (void)loadData
{
    [self showChrysanthemumHUD:YES];
    __weak typeof(self) weakSelf = self;
    
    [DiscoverManager getOrderInfo:self.orderId successBlock:^(id obj) {
        [weakSelf removeAllHUDViews:YES];
        weakSelf.infoObject = obj;
        [weakSelf setup];
        [weakSelf getGradInfo];
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
    
}

- (void)getGradInfo
{
    __weak typeof(self) weakSelf = self;
    [ListTempleManager getGradeInfo:^(id obj) {
        NSMutableArray* gradeArray = (NSMutableArray*)obj;
        for(GradeInfoObject* info in gradeArray)
        {
            if([info.gradeName isEqualToString:weakSelf.infoObject.wishGrade])
            {
                NSString* text = [NSString stringWithFormat:@"香烛: %@  ￥%.2f",weakSelf.infoObject.wishGrade,info.gradePrice];
                NSMutableAttributedString* wishGradeString = [[NSMutableAttributedString alloc] initWithString:text];
                [wishGradeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0xbababa) range:NSRangeMake(0, 4)];
                [wishGradeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:14] range:NSRangeMake(0, 4)];
                [wishGradeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(0x808080) range:NSRangeMake(4, self.infoObject.wishGrade.length)];
                [wishGradeString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:15] range:NSRangeMake(4, self.infoObject.wishGrade.length)];
                [wishGradeString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT) range:[text rangeOfString:[NSString stringWithFormat:@"￥%.2f",info.gradePrice]]];
                weakSelf.gradeInfo = info;
                [weakSelf.wishGradeLabel setAttributedText:wishGradeString];
            }
        }
    } failed:^(id error) {
        
    }];
}

- (void)pay
{
    PayInfoViewController* viewController = [[PayInfoViewController alloc] init];
    viewController.orderId = self.infoObject.orderId;
    viewController.price = self.gradeInfo.gradePrice;
    viewController.orderContentText = self.infoObject.wishText;
    viewController.productName = self.gradeInfo.gradeName;
    [self.navigationController pushViewController:viewController animated:YES];
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
