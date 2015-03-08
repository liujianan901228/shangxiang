//
//  FeedbackViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/24.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "FeedbackViewController.h"
#import "CommonTextFiled.h"
#import "MyRequestManager.h"

@interface FeedbackViewController ()

@property (nonatomic, strong) CommonTextFiled* textView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"意见反馈";
    self.view.backgroundColor = UIColorFromRGB(COLOR_BG_NORMAL);
    
    _textView = [[CommonTextFiled alloc] initWithFrame:CGRectMake(20, 15, self.view.width - 40, 115)];
    [_textView setMaxInputCount:100];
    [_textView setTextPlaceHolder:@"请输入你的意见,我们将竭诚接纳建议"];
    [self.view addSubview:_textView];
    
    UIButton* buttonSubmitCreateOrder = [[UIButton alloc] initWithFrame:CGRectMake(20, _textView.bottom + 20, self.view.width - 40, 40)];
    [buttonSubmitCreateOrder setTitle:@"提交" forState:UIControlStateNormal];
    [buttonSubmitCreateOrder setTitleColor:UIColorFromRGB(0xffffff) forState:UIControlStateNormal];
    [buttonSubmitCreateOrder setBackgroundColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_NORMAL)];
    [buttonSubmitCreateOrder setBackgroundImage:[UIImage imageWithColor:UIColorFromRGB(COLOR_FORM_BG_BUTTON_HIGHLIGHT)] forState:UIControlStateHighlighted];
    [buttonSubmitCreateOrder addTarget:self action:@selector(buttonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:buttonSubmitCreateOrder];
    
}

- (void)buttonClicked:(UIButton*)button
{
    [self showChrysanthemumHUD:YES];
    typeof(self) weakSelf = self;
    [MyRequestManager postFeedBackInfo:USEROPERATIONHELP.currentUser.userId content:[_textView getContentText] successBlock:^(NSDictionary* obj) {
        [weakSelf removeAllHUDViews:YES];
        NSString* msg = [obj stringForKey:@"msg" withDefault:@""];
        [weakSelf showTimedHUD:YES message:msg];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf goBack];
        });
    } failed:^(id error) {
        [weakSelf removeAllHUDViews:YES];
        [weakSelf dealWithError:error];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
