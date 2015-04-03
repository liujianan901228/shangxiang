//
//  OrderRecordViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/11.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "OrderRecordViewController.h"
#import "OrderListViewController.h"

@interface OrderRecordViewController ()
{
    UISegmentedControl* _segSwitch;
    NSInteger _index;
}

@property (nonatomic, strong) OrderListViewController *currentViewController;//当前子视图控制器
@property (nonatomic, strong) OrderListViewController* viewController1;
@property (nonatomic, strong) OrderListViewController* viewController2;

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

    
    _viewController1 = [[OrderListViewController alloc] init];
    _viewController1.isWill = YES;
    [self addChildViewController:_viewController1];
    _viewController2 = [[OrderListViewController alloc] init];
    _viewController2.isWill = NO;
    [self addChildViewController:_viewController2];
    
    _currentViewController = _viewController1;
    _currentViewController.view.frame = CGRectMake(0, 50, self.view.width, self.view.height - 50);
    [self.view  addSubview:_currentViewController.view];
    
}

#pragma mark segment事件
-(void)itemSelected:(NSUInteger )aIndex
{
    //判断是否存在子视图控制器
    if(self.childViewControllers && self.childViewControllers.count > aIndex)
    {
        OrderListViewController *control = [self.childViewControllers objectAtIndex:aIndex];
        
        //判断是否点击的是当前的
        if(_currentViewController == control)
        {
            _currentViewController.view.frame = _currentViewController.view.frame;
            return;
        }
        
        control.view.frame  = CGRectMake(0, 50, self.view.width, self.view.height - 50);
        
        //切换child view controller
        
        [self transitionFromViewController:_currentViewController toViewController:control duration:0.00 options:UIViewAnimationOptionTransitionNone animations:^{
        }completion:^(BOOL finished)
         {
             
             [_currentViewController willMoveToParentViewController:nil];
             _currentViewController = control;
         }];
        
    }
}


- (void)switchShow:(UISegmentedControl*)segment
{
    if(segment.selectedSegmentIndex == _index) return;
    
    _index = segment.selectedSegmentIndex;
    [self itemSelected:_index];
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    if(_viewController1 && _viewController1.isViewLoaded) [_viewController1 refresh];
    if(_viewController2 && _viewController2.isViewLoaded) [_viewController2 refresh];
}


@end
