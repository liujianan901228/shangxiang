//
//  AppNavigator.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/10.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "AppNavigator.h"
#import "LoginViewController.h"
#import "OrderRecordViewController.h"
#import "MyViewController.h"
#import "Reachability.h"

@interface AppNavigator()<UITabBarControllerDelegate>

@property(nonatomic,strong)HomeTabBarViewController* homeTabBarController;

@end

@implementation AppNavigator

-(instancetype)init
{
    if(self = [super init])
    {
        UIStoryboard  *storyboard = [UIStoryboard storyboardWithName:@"HomePage" bundle:nil];
        _homeTabBarController = (HomeTabBarViewController *)[storyboard instantiateInitialViewController];
        _homeTabBarController.delegate = self;
        self.currentContentNav = (UINavigationController*)[_homeTabBarController.viewControllers objectAtIndex:0];
    }
    return self;
}


-(void)openDefaultMainViewController
{
    APPDELEGATE.window.rootViewController = self.homeTabBarController;
    self.currentContentNav = [self.homeTabBarController.viewControllers objectAtIndex:0];
    [self.homeTabBarController setSelectedIndex:0];
}


- (void)calendarTurnWillingGuide
{
    [self.homeTabBarController setSelectedIndex:0];
    self.currentContentNav = (UINavigationController*)[_homeTabBarController.viewControllers objectAtIndex:0];

    UINavigationController* threeNavigationController = (UINavigationController*)[_homeTabBarController.viewControllers objectAtIndex:2];
    [threeNavigationController popToRootViewControllerAnimated:NO];
}

- (void)turnToLoginGuide
{
    if([[Reachability reachabilityWithHostName:@"www.shangxiang.com"] currentReachabilityStatus] == kNotReachable)
    {
        if(self.currentContentNav && self.currentContentNav.viewControllers && self.currentContentNav.viewControllers.count > 0)
        {
            BaseViewController* controller = [self.currentContentNav.viewControllers objectAtIndex:0];
            [controller showTimedHUD:YES message:@"当前无网络连接，请检查您的网络"];
        }
        return;
    }
    LoginViewController* loginViewController = [[LoginViewController alloc] init];
    RootNavigationViewController *navigationController = [[RootNavigationViewController alloc] initWithRootViewController:loginViewController];
    [self.currentContentNav presentViewController:navigationController animated:YES completion:^{
        
    }];
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController
{
    self.currentContentNav = (RootNavigationViewController*)viewController;
}


- (void)showAlert:(NSString*)title Message:(NSString*)msg
{
    UIAlertView* viewAlert = [[UIAlertView alloc] init];
    [viewAlert setTitle:title];
    [viewAlert setMessage:msg];
    [viewAlert addButtonWithTitle:@"确定"];
    [viewAlert show];
}

-(void)switchToLivingTab:(NSInteger)index
{
    [self.currentContentNav popToRootViewControllerAnimated:NO];
    [self.homeTabBarController setSelectedIndex:index];
    self.currentContentNav = (UINavigationController*)[_homeTabBarController.viewControllers objectAtIndex:index];
}

- (void)turnToOrderRecordPage
{
    [self.homeTabBarController setSelectedIndex:3];
    self.currentContentNav = (UINavigationController*)[_homeTabBarController.viewControllers objectAtIndex:3];
    
    BOOL containOrderRecoder = NO;
    for(UIViewController* controller in self.currentContentNav.viewControllers)
    {
        if([controller isKindOfClass:[OrderRecordViewController class]])
        {
            containOrderRecoder = YES;
            [self.currentContentNav popToViewController:controller animated:NO];
            return;
        }
    }
    if(!containOrderRecoder)
    {
        OrderRecordViewController* viewController = [[OrderRecordViewController alloc] init];
        [self.currentContentNav pushViewController:viewController animated:NO];
        UINavigationController* firstNavigationController = (UINavigationController*)[_homeTabBarController.viewControllers objectAtIndex:0];
        [firstNavigationController popToRootViewControllerAnimated:NO];
    }
}

@end
