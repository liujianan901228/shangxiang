//
//  BlessViewController.m
//  shangxiang
//
//  Created by limingchen on 15/3/18.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BlessViewController.h"
#import "DiscoverViewController.h"



@interface BlessViewController ()

@property (nonatomic, strong) UIView* segmenControl;
@property (nonatomic, strong) UIButton* buttonDiscoverTotalTome;
@property (nonatomic, strong) UIButton* buttonDiscoverTotalToother;
@property (nonatomic, strong) UIViewController *currentViewController;//当前子视图控制器

@end

@implementation BlessViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _segmenControl = [[UIView alloc] initWithFrame:CGRectMake(0, 10, self.view.width, 40)];
    [_segmenControl setBackgroundColor:[UIColor clearColor]];
    [self.view addSubview:_segmenControl];
    

    _buttonDiscoverTotalTome = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.view.width / 2.0, 40)];
    [_buttonDiscoverTotalTome.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_buttonDiscoverTotalTome addTarget:self action:@selector(switchShow:) forControlEvents:UIControlEventTouchUpInside];
    [_segmenControl addSubview:_buttonDiscoverTotalTome];
    
    
    _buttonDiscoverTotalToother = [[UIButton alloc] initWithFrame:CGRectMake(_buttonDiscoverTotalTome.right, 0, self.view.width / 2.0, 40)];
    [_buttonDiscoverTotalToother setTag:2];
    [_buttonDiscoverTotalToother.titleLabel setFont:[UIFont systemFontOfSize:14.0f]];
    [_buttonDiscoverTotalToother addTarget:self action:@selector(switchShow:) forControlEvents:UIControlEventTouchUpInside];
    [_segmenControl addSubview:_buttonDiscoverTotalToother];

    
    DiscoverViewController* viewController1 = [[DiscoverViewController alloc] init];
    viewController1.blessType = BelssType_Dobless;
    viewController1.isNoFilter = YES;
    [self addChildViewController:viewController1];
    DiscoverViewController* viewController2 = [[DiscoverViewController alloc] init];
    viewController2.blessType = BelssType_Receive;
    viewController2.isNoFilter = YES;
    [self addChildViewController:viewController2];
    
    _currentViewController = (_index == 0) ? viewController1 : viewController2;
    _currentViewController.view.frame = CGRectMake(0, _segmenControl.bottom, self.view.width, self.view.height - _segmenControl.bottom);
    [self.view  addSubview:_currentViewController.view];
    
    [self updateSwitch];
}

#pragma mark segment事件
-(void)itemSelected:(NSUInteger )aIndex
{
    //判断是否存在子视图控制器
    if(self.childViewControllers && self.childViewControllers.count > aIndex)
    {
        UIViewController *control = [self.childViewControllers objectAtIndex:aIndex];
        
        //判断是否点击的是当前的
        if(_currentViewController == control)
        {
            _currentViewController.view.frame = _currentViewController.view.frame;
            return;
        }
        
        control.view.frame  = CGRectMake(0, _segmenControl.bottom, self.view.width, self.view.height - _segmenControl.bottom);
        
        //切换child view controller
        
        [self transitionFromViewController:_currentViewController toViewController:control duration:0.00 options:UIViewAnimationOptionTransitionNone animations:^{
        }completion:^(BOOL finished)
         {
             
             [_currentViewController willMoveToParentViewController:nil];
             _currentViewController = control;
         }];
        
    }
}

- (void)switchShow:(UIButton*)button
{
    NSInteger currentIndex= button.tag == 2 ? 1 : 0;
    
    if(currentIndex == _index) return;
    
    [self itemSelected:currentIndex];
    _index = currentIndex;
    
    [self updateSwitch];
}

- (void)updateSwitch
{
    self.title = _index == 0 ? @"我的加持" : @"为我加持";
    
    if(_index == 0)
    {
        [_buttonDiscoverTotalTome setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xc7c6c9)] forState:UIControlStateNormal];
        [_buttonDiscoverTotalToother setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb)] forState:UIControlStateNormal];
        [_buttonDiscoverTotalTome setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonDiscoverTotalToother setTitleColor:UIColorFromRGB(COLOR_FONT_FORM_NORMAL) forState:UIControlStateNormal];
    }
    else
    {
        [_buttonDiscoverTotalToother setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xc7c6c9)] forState:UIControlStateNormal];
        [_buttonDiscoverTotalTome setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(0xebebeb)] forState:UIControlStateNormal];
        [_buttonDiscoverTotalToother setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_buttonDiscoverTotalTome setTitleColor:UIColorFromRGB(COLOR_FONT_FORM_NORMAL) forState:UIControlStateNormal];
    }
    
    NSString* blessing = USEROPERATIONHELP.currentUser.doBlessings > 0 ? [NSString stringWithFormat:@"我的加持%zd",USEROPERATIONHELP.currentUser.doBlessings] : @"我的加持";
    NSMutableAttributedString* attributedText = [[NSMutableAttributedString alloc] initWithString:blessing];
    [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_HIGHLIGHT)}
                            range:NSMakeRange(4, [attributedText length] - 4)];
    if (_index == 0)
    {
        [attributedText setAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}
                                range:NSMakeRange(0, 4)];
    }
    else
    {
        [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_FORM_NORMAL)}
                                range:NSMakeRange(0, 4)];
    }
    

    [_buttonDiscoverTotalTome setAttributedTitle:attributedText forState:UIControlStateNormal];
    
    blessing = USEROPERATIONHELP.currentUser.receivedBlessings > 0 ? [NSString stringWithFormat:@"为我加持%zd",USEROPERATIONHELP.currentUser.receivedBlessings] : @"为我加持";
    attributedText = [[NSMutableAttributedString alloc] initWithString:blessing];
    [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_HIGHLIGHT) }
                        range:NSMakeRange(4, [attributedText length] - 4)];
    
    if (_index == 1)
    {
        [attributedText setAttributes:@{ NSForegroundColorAttributeName : [UIColor whiteColor]}
                                range:NSMakeRange(0, 4)];
    }
    else
    {
        [attributedText setAttributes:@{ NSForegroundColorAttributeName : UIColorFromRGB(COLOR_FONT_FORM_NORMAL)}
                                range:NSMakeRange(0, 4)];
    }
    [_buttonDiscoverTotalToother setAttributedTitle:attributedText forState:UIControlStateNormal];

    
}


@end
