//
//  HomeTabBarViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "HomeTabBarViewController.h"
#import "HomeTarItem.h"

@interface HomeTabBarViewController ()

@end

@implementation HomeTabBarViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = RGBCOLOR(0, 0, 0);
    
    
    UITabBar* tabBar = self.tabBar;
    
    if([LUtility isHigherIOS7]) {
        [tabBar setBarTintColor:RGBCOLOR(0, 0, 0)];
    }
    [tabBar setTintColor:RGBCOLOR(0, 0, 0)];
    
    tabBar.backgroundColor = RGBCOLOR(0, 0, 0);
    [tabBar setSelectedImageTintColor:[UIColor whiteColor]];
    tabBar.backgroundImage = [UIImage imageForKey:@"background_tabbar"];
    
    
    HomeTarItem* frist = [tabBar.items objectAtIndex:0];
    [frist renderItem:[UIImage imageForKey:@"icon_home_normal"] SelectImage:[UIImage imageForKey:@"icon_home_pressed"]];
    
    HomeTarItem* second = [tabBar.items objectAtIndex:1];
    [second renderItem:[UIImage imageForKey:@"icon_discover_normal"] SelectImage:[UIImage imageForKey:@"icon_discover_pressed"]];
    
    HomeTarItem* third = [tabBar.items objectAtIndex:2];
    [third renderItem:[UIImage imageForKey:@"icon_calendar_normal"] SelectImage:[UIImage imageForKey:@"icon_calendar_pressed"]];
    
    HomeTarItem* four = [tabBar.items objectAtIndex:3];
    [four renderItem:[UIImage imageForKey:@"icon_my_normal"] SelectImage:[UIImage imageForKey:@"icon_my_pressed"]];
    
    //设置tabbar的items图表
    //for (int i = 0; i < 4; i++)
//    {
//        CGFloat width = self.tabBar.width / 4.0;
//        CGFloat height = self.tabBar.height;
//        UIButton *itemBg  = [[UIButton alloc] initWithFrame:CGRectMake(0, 0 , width, height)];
//        [itemBg setImage:[UIImage imageForKey:@"icon_home_normal"] forState:UIControlStateNormal];
//        [itemBg setImage:[UIImage imageForKey:@"icon_home_pressed"] forState:UIControlStateHighlighted];
//        [itemBg setImage:[UIImage imageForKey:@"icon_home_pressed"] forState:UIControlStateSelected];
//        [itemBg setTitle:@"求愿" forState:UIControlStateNormal];
//        [itemBg.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        [itemBg setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateSelected];
//        [itemBg setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateHighlighted];
//        [itemBg setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//        [itemBg setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//        [itemBg setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
//        itemBg.imageEdgeInsets = UIEdgeInsetsMake((height - 20)/2 - 5, (width - 20)/2, 0, 0);
//        itemBg.titleEdgeInsets = UIEdgeInsetsMake(33, -9, 0, 0);
//        [self.tabBar addSubview:itemBg];
//        
//        width = self.tabBar.width / 4.0 ;
//        height = self.tabBar.height;
//        UIButton *itemBg2  = [[UIButton alloc] initWithFrame:CGRectMake(width, 0 , width, height)];
//        [itemBg2 setImage:[UIImage imageForKey:@"icon_discover_normal"] forState:UIControlStateNormal];
//        [itemBg2 setImage:[UIImage imageForKey:@"icon_discover_pressed"] forState:UIControlStateHighlighted];
//        [itemBg2 setImage:[UIImage imageForKey:@"icon_discover_pressed"] forState:UIControlStateSelected];
//        [itemBg2 setTitle:@"发现" forState:UIControlStateNormal];
//        [itemBg2.titleLabel setFont:[UIFont systemFontOfSize:12]];
//        [itemBg2 setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateSelected];
//        [itemBg2 setTitleColor:UIColorFromRGB(COLOR_FONT_HIGHLIGHT) forState:UIControlStateHighlighted];
//        [itemBg2 setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
//        [itemBg2 setContentHorizontalAlignment:UIControlContentHorizontalAlignmentCenter];
//        [itemBg2 setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
//        itemBg2.imageEdgeInsets = UIEdgeInsetsMake((height - 20)/2 - 5, (width - 20)/2, 0, 0);
//        itemBg2.titleEdgeInsets = UIEdgeInsetsMake(33, -9, 0, 0);
//        [self.tabBar addSubview:itemBg2];
//    }
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
}

//  ios6以下
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return interfaceOrientation == UIInterfaceOrientationPortrait;
}

// ios6以上
- (NSUInteger)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskPortrait;
}

- (BOOL)shouldAutorotate
{
    return NO;
}

- (UIInterfaceOrientation)preferredInterfaceOrientationForPresentation
{
    return UIInterfaceOrientationPortrait;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBar:(UITabBar *)tabBar didSelectItem:(UITabBarItem *)item
{
    switch (item.tag)
    {
        case 0:
            break;
        case 1:
            break;
        case 2:
            break;
        case 3:
            break;
        default:
            break;
    }
}

- (BOOL)tabBarController:(UITabBarController *)tabBarController shouldSelectViewController:(UIViewController *)viewController
{
    return YES;
}
- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{

}


@end
