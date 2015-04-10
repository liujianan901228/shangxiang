//
//  SXGuideViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/4/4.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "SXGuideViewController.h"

@interface SXGuideViewController ()

@property (nonatomic, strong) UIScrollView* scrollView;

@end

@implementation SXGuideViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    _scrollView = [[UIScrollView alloc] initWithFrame:self.view.bounds];
    _scrollView.pagingEnabled = YES;
    _scrollView.showsHorizontalScrollIndicator = NO;
    _scrollView.showsVerticalScrollIndicator = NO;
    _scrollView.alwaysBounceHorizontal = YES;
    _scrollView.alwaysBounceVertical = NO;
    _scrollView.bounces = NO;
    _scrollView.contentSize = CGSizeMake(_scrollView.width * 4, _scrollView.height);
    [self.view addSubview:_scrollView];
    
    for(NSInteger index = 0 ;index < 4;index++)
    {
        UIImageView* imageView = [[UIImageView alloc] initWithFrame:CGRectMake(index* _scrollView.width, 0, _scrollView.width, _scrollView.height)];
        imageView.contentMode = UIViewContentModeScaleToFill;
        [imageView setImage:[UIImage imageForKey:[NSString stringWithFormat:@"guide_%zd",index + 1]]];
        
        if(index == 3)
        {
            imageView.userInteractionEnabled = YES;
            UITapGestureRecognizer* tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(enterMainController)];
            [imageView addGestureRecognizer:tapGesture];
            
        }
        
        [_scrollView addSubview:imageView];
    }
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:NO];
}

- (void)enterMainController
{
    [APPNAVGATOR openDefaultMainViewController];
    [APPDELEGATE.window addSubview:self.view];
    
    [[UIApplication sharedApplication] setStatusBarHidden:NO withAnimation:NO];
    
    [UIView transitionWithView:self.view duration:0.5f options:UIViewAnimationOptionBeginFromCurrentState | UIViewAnimationOptionCurveLinear animations:^{
        self.view.alpha = 0.0f;
    } completion:^(BOOL finished) {
        [self.view removeFromSuperview];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
