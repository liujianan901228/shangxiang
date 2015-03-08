//
//  BrowserViewController.m
//  shangxiang
//
//  Created by 倾慕 on 15/1/13.
//  Copyright (c) 2015年 倾慕. All rights reserved.
//

#import "BrowserViewController.h"

@interface BrowserViewController ()<UIWebViewDelegate>

@property (nonatomic, strong) UIWebView* webView;

@end

@implementation BrowserViewController

- (instancetype)init
{
    if(self = [super init])
    {
        _webView = [[UIWebView alloc] init];
        _webView.delegate = self;
        [_webView setBackgroundColor:UIColorFromRGB(0xffffff)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    _webView.frame = CGRectMake(0, 0, self.view.width, self.view.height);
    [self.view addSubview:_webView];
    if(_url && _url.length > 0)
    {
        NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:self.url]];
        [_webView loadRequest:request];
    }
    else
    {
        [self showTimedHUD:YES message:@"链接地址为空"];
    }
}

- (void)dealloc
{
    _webView.delegate = nil;
    _webView = nil;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)webViewDidStartLoad:(UIWebView *)webView
{
    [self showChrysanthemumHUD:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    [self removeAllHUDViews:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
    NSString *title = [webView stringByEvaluatingJavaScriptFromString:@"document.title"];
    self.title = title;
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout = 'none';"];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error
{
    [self removeAllHUDViews:YES];
    [[UIApplication sharedApplication] setNetworkActivityIndicatorVisible:NO];
}

@end
