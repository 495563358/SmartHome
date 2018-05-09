//
//  ProjectdesignVC.m
//  SmartMall
//
//  Created by Smart house on 2017/11/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "ProjectdesignVC.h"
#import "MBProgressHUD.h"

@interface ProjectdesignVC ()<UIWebViewDelegate>

@end

@implementation ProjectdesignVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64)];
    
    self.navigationItem.title = _titlename;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    webview.userInteractionEnabled = YES;
    webview.delegate = self;
    webview.opaque = NO;
    webview.scalesPageToFit = YES;
    webview.backgroundColor = [UIColor whiteColor];
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_urlStr]]];
    
    [self.view addSubview:webview];
    
    
//    NSString *userAgent = [webview stringByEvaluatingJavaScriptFromString:@"navigator.userAgent"];
//    NSLog(@"userAgent :%@", userAgent);
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end
