//
//  ListTempleInfoViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/16.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "ListTempleInfoViewController.h"
#import "ListTempleManager.h"
#import "TempleInfoObject.h"
#import "UIImageView+WebCache.h"
#import "SingLineImageCollectionView.h"
#import "AttachInfoObject.h"
#import "CreateOrderViewController.h"
#import "LFFGPhotoAlbumView.h"

@interface ListTempleInfoViewController ()<UIScrollViewDelegate>
{
    NSInteger _requestCount;
}

@property (nonatomic, strong) UISegmentedControl* segSwitch;
@property (nonatomic, strong) UIScrollView* scrollView;
@property (nonatomic, strong) SingLineImageCollectionView* viewHallThumb;
@property (nonatomic, strong) TempleInfoObject* templeInfoObject;
@property (nonatomic, strong) AttachInfoObject* attachInfoObject;

@end

@implementation ListTempleInfoViewController

- (instancetype)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self loadTempleInfoData];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    NSLog(@"sfd");
}

- (void)initUI
{
    _segSwitch = [[UISegmentedControl alloc] initWithItems:[NSArray arrayWithObjects:@"寺庙介绍", @"法师介绍", nil]];
    NSDictionary* textAttributes = [NSDictionary dictionaryWithObjectsAndKeys:UIColorFromRGB(COLOR_FONT_FORM_NORMAL), NSForegroundColorAttributeName, [UIFont systemFontOfSize:14.f], NSFontAttributeName, nil, NSShadowAttributeName, nil];
    NSDictionary* SelectTextAttributes = [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName, [UIFont systemFontOfSize:14.f], NSFontAttributeName, nil, NSShadowAttributeName, nil];
    [_segSwitch setFrame:CGRectMake(0, 10, self.view.width, 40)];
    [_segSwitch setTintColor:[UIColor clearColor]];
    [_segSwitch setTitleTextAttributes:textAttributes forState:UIControlStateNormal];
    [_segSwitch setTitleTextAttributes:SelectTextAttributes forState:UIControlStateSelected];
    [_segSwitch setTitleTextAttributes:SelectTextAttributes forState:UIControlStateHighlighted];
    [_segSwitch setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segSwitch setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xc7c6c9)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [_segSwitch setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xc7c6c9)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [_segSwitch setDividerImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_BG_NORMAL)] forLeftSegmentState:UIControlStateNormal rightSegmentState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [_segSwitch.layer setMasksToBounds:YES];
    [_segSwitch setSelectedSegmentIndex:0];
    [_segSwitch addTarget:self action:@selector(switchShow:) forControlEvents:UIControlEventValueChanged];
    [self.view addSubview:_segSwitch];
    
    _scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, _segSwitch.bottom + 10, self.view.width, self.view.height - _segSwitch.bottom - 10)];
    [_scrollView setBackgroundColor:[UIColor clearColor]];
    [_scrollView setAlwaysBounceVertical:NO];
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    [_scrollView setPagingEnabled:YES];
    _scrollView.delegate = self;
    [_scrollView setContentSize:CGSizeMake(self.view.width * 2, _scrollView.height)];
    
    UIScrollView* templeView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, _scrollView.width, _scrollView.height)];
    [templeView setBackgroundColor:[UIColor clearColor]];
    [templeView setAlwaysBounceVertical:YES];
    templeView.showsHorizontalScrollIndicator = NO;
    templeView.showsVerticalScrollIndicator = NO;
    
    _viewHallThumb = [[SingLineImageCollectionView alloc] initWithFrame:CGRectMake(0, 0, self.view.width, 85)];
    __weak typeof(self) weakSelf = self;
    _viewHallThumb.actionBlock = ^(TemplePictureObject* picObject,UIImageView* imageView)
    {
        NSMutableArray *infos = @[].mutableCopy;
        for (NSUInteger i = 0; i < weakSelf.templeInfoObject.images.count && i < 9; i++)
        {
            TemplePictureObject* object = (TemplePictureObject*)[weakSelf.templeInfoObject.images objectAtIndex:i];
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
        [albumView showFromImageView:imageView toContainer:weakSelf.view];
        NSLog(@"%@ 啦啦啦啦啦了 ",picObject.picSmallUrl);
    };
    [_viewHallThumb setBackgroundColor:[UIColor whiteColor]];
    [_viewHallThumb setObject:_templeInfoObject.images];
    [templeView addSubview:_viewHallThumb];
    
    UILabel* labelHall = [[UILabel alloc] initWithFrame:CGRectMake(20, _viewHallThumb.bottom + 20, self.view.width - 40, 30)];
    [labelHall setBackgroundColor:[UIColor clearColor]];
    [labelHall setLineBreakMode:NSLineBreakByTruncatingTail];
    [labelHall setNumberOfLines:1];
    
    NSString* string = [NSString stringWithFormat:@"%@  [%@,建于公元%@年]",_templeInfoObject.templeName,_templeInfoObject.templeProvince,_templeInfoObject.templeBuildTime];
    NSInteger lastCount = _templeInfoObject.templeProvince.length + 8 + _templeInfoObject.templeBuildTime.length;
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:string attributes:nil];

    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(COLOR_FONT_FORM_HINT) range:[string rangeOfString:[NSString stringWithFormat:@"[%@,建于公元%@年]",_templeInfoObject.templeProvince,_templeInfoObject.templeBuildTime]]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSRangeMake(_templeInfoObject.templeName.length + 2, lastCount)];
    
    [attributedString addAttribute:NSForegroundColorAttributeName value:UIColorFromRGB(COLOR_FONT_NORMAL) range:[string rangeOfString:_templeInfoObject.templeName]];
    [attributedString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16] range:NSRangeMake(0, _templeInfoObject.templeName.length)];
    
    [labelHall setAttributedText:attributedString];
    [templeView addSubview:labelHall];
    
    
    UILabel* labelDesireCount = [[UILabel alloc] initWithFrame:CGRectMake(20, labelHall.bottom, self.view.width - 40, 15)];
    labelDesireCount.text = [NSString stringWithFormat:@"已有%zd人在此求愿",_templeInfoObject.orderCount];
    labelDesireCount.font = [UIFont systemFontOfSize:14.0f];
    labelDesireCount.textColor = UIColorFromRGB(COLOR_FONT_FORM_HINT);
    [templeView addSubview:labelDesireCount];
    
    UIView* line = [[UIView alloc] initWithFrame:CGRectMake(0, labelDesireCount.bottom + 10, self.view.width, 0.5)];
    [line setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [templeView addSubview:line];
    
    
    CGSize size = [_templeInfoObject.templeDescription sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(self.view.width - 40, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    UILabel* labelDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, line.bottom + 10, size.width, size.height)];
    [labelDescription setLineBreakMode:NSLineBreakByWordWrapping];
    [labelDescription setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [labelDescription setNumberOfLines:0];
    [labelDescription setFont:[UIFont systemFontOfSize:14]];
    [labelDescription setText:_templeInfoObject.templeDescription];
    [templeView addSubview:labelDescription];
    
    UIButton* buttonCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, labelDescription.bottom + 20, self.view.width - 40, 40)];
    [buttonCreateOrder setTitle:@"在此求愿" forState:UIControlStateNormal];
    [buttonCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [buttonCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [buttonCreateOrder addTarget:self action:@selector(goCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [templeView addSubview:buttonCreateOrder];
    
    [templeView setContentSize:CGSizeMake(_scrollView.width, MAX(_scrollView.height + 1, templeView.height))];
    [_scrollView addSubview:templeView];
    
    
    UIScrollView* attachView = [[UIScrollView alloc] initWithFrame:CGRectMake(_scrollView.width, 0, _scrollView.width, _scrollView.height)];
    [attachView setBackgroundColor:[UIColor clearColor]];
    [attachView setAlwaysBounceVertical:YES];
    attachView.showsHorizontalScrollIndicator = NO;
    attachView.showsVerticalScrollIndicator = NO;
    
    UIImageView* attachImageView = [[UIImageView alloc] initWithFrame:CGRectMake(20, 10, 85, 85)];
    [attachImageView setClipsToBounds:YES];
    [attachImageView setContentMode:UIViewContentModeScaleAspectFit];
    [attachImageView sd_setImageWithURL:[NSURL URLWithString:_attachInfoObject.headSmallUrl] placeholderImage:[UIImage imageForKey:@"avatar_null"]];
    [attachView addSubview:attachImageView];
    
    UILabel* attchNameLabel = [[UILabel alloc] initWithFrame:CGRectMake(attachImageView.right + 20, 30, attachView.width - attachImageView.right - 20, 25)];
    [attchNameLabel setNumberOfLines:1];
    [attchNameLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [attchNameLabel setFont:[UIFont systemFontOfSize:16]];
    [attchNameLabel setText:_attachInfoObject.buddhistName];
    [attachView addSubview:attchNameLabel];
    
    UILabel* attchTimeLabel = [[UILabel alloc] initWithFrame:CGRectMake(attachImageView.right + 20, attchNameLabel.bottom, attachView.width - attachImageView.right - 20, 15)];
    [attchTimeLabel setNumberOfLines:1];
    [attchTimeLabel setLineBreakMode:NSLineBreakByTruncatingTail];
    [attchTimeLabel setFont:[UIFont systemFontOfSize:12]];
    [attchTimeLabel setTextColor:UIColorFromRGB(COLOR_FONT_FORM_HINT)];
    [attchTimeLabel setText:[NSString stringWithFormat:@"[皈依:%@年]",_attachInfoObject.conversion]];
    [attachView addSubview:attchTimeLabel];
    
    UIView* attachLine = [[UIView alloc] initWithFrame:CGRectMake(0, attachImageView.bottom + 10, attachView.width, 0.5)];
    [attachLine setBackgroundColor:UIColorFromRGB(COLOR_LINE_NORMAL)];
    [attachView addSubview:attachLine];
    
    CGSize attchsize = [_attachInfoObject.attacheDescription sizeForFont:[UIFont systemFontOfSize:14] size:CGSizeMake(self.view.width - 40, CGFLOAT_MAX) mode:NSLineBreakByWordWrapping];
    UILabel* attchLabelDescription = [[UILabel alloc] initWithFrame:CGRectMake(20, attachLine.bottom + 10, attchsize.width, attchsize.height)];
    [attchLabelDescription setLineBreakMode:NSLineBreakByWordWrapping];
    [attchLabelDescription setTextColor:UIColorFromRGB(COLOR_FONT_NORMAL)];
    [attchLabelDescription setNumberOfLines:0];
    [attchLabelDescription setFont:[UIFont systemFontOfSize:14]];
    [attchLabelDescription setText:_attachInfoObject.attacheDescription];
    [attachView addSubview:attchLabelDescription];
    
    UIButton* attchButtonCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, attchLabelDescription.bottom + 20, self.view.width - 40, 40)];
    [attchButtonCreateOrder setTitle:@"在此求愿" forState:UIControlStateNormal];
    [attchButtonCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [attchButtonCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [attchButtonCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [attchButtonCreateOrder addTarget:self action:@selector(goCreateOrder) forControlEvents:UIControlEventTouchUpInside];
    [attachView addSubview:attchButtonCreateOrder];
    
    [attachView setContentSize:CGSizeMake(_scrollView.width, MAX(_scrollView.height + 1, attachView.height))];
    [_scrollView addSubview:attachView];
    
    [self.view addSubview:_scrollView];
}

- (void)loadTempleInfoData
{
    [self showChrysanthemumHUD:YES];
    typeof(self) weakSelf = self;
    [ListTempleManager getTempleInfo:self.templeObject.templeId successBlock:^(id obj) {
        weakSelf.templeInfoObject = obj;
        _requestCount ++ ;
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
            [weakSelf initUI];
        }
    } failed:^(id error) {
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
        }
        [weakSelf dealWithError:error];
    }];
    
    [ListTempleManager getAttchInfo:self.templeObject.attacheId successBlock:^(id obj) {
        weakSelf.attachInfoObject = obj;
        _requestCount ++;
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
            [weakSelf initUI];
        }
    } failed:^(id error) {
        if(_requestCount == 2)
        {
            [weakSelf removeAllHUDViews:YES];
        }
         [weakSelf dealWithError:error];
    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    _scrollView.delegate = nil;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(scrollView == _scrollView)
    {
        if(_scrollView.contentOffset.x >= _scrollView.width && _segSwitch.selectedSegmentIndex != 1)
        {
            [_segSwitch setSelectedSegmentIndex:1];
        }
        else if(_scrollView.contentOffset.x <= 0 && _segSwitch.selectedSegmentIndex != 0)
        {
            [_segSwitch setSelectedSegmentIndex:0];
        }
    }
}
    
- (void)goCreateOrder
{
    CreateOrderViewController* createOrderViewController = [[CreateOrderViewController alloc] init];
    createOrderViewController.templeObject = self.templeObject;
    createOrderViewController.wishType = self.wishType;
    [self.navigationController pushViewController:createOrderViewController animated:YES];
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


@end
