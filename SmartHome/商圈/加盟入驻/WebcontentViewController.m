//
//  WebcontentViewController.m
//  SmartMall
//
//  Created by Smart house on 2017/11/2.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "WebcontentViewController.h"

#import "ApplyEnterViewController.h"
#import "MBProgressHUD.h"

@interface WebcontentViewController ()<UIWebViewDelegate>

@end

@implementation WebcontentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.navigationItem.title = @"加盟入驻";
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    UIWebView *webview = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, Sc_h - 64 - 49)];
    
    webview.userInteractionEnabled = YES;
    webview.delegate = self;
    webview.opaque = NO;
    webview.scalesPageToFit = YES;
    webview.backgroundColor = [UIColor whiteColor];
    
    NSString *urlStr = [ResourceFront stringByAppendingString:@"r=merch.appregister.desc"];
    
    webview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:webview];
    
    
    [webview loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:urlStr]]];
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}


-(void)viewWillAppear:(BOOL)animated{
    self.navigationController.navigationBarHidden = NO;
}

- (void)webViewDidStartLoad:(UIWebView *)webView{
    
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
}
- (void)webViewDidFinishLoad:(UIWebView *)webView{
    UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake(0, Sc_h-64-49, Sc_w, 49)];
    btn.backgroundColor = Color_system;
    [btn setTitle:@"我有实体门店,我要合作" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(attendClick:) forControlEvents:UIControlEventTouchUpInside];
    btn.titleLabel.font = [UIFont systemFontOfSize:15];
    [self.view addSubview:btn];
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}

-(void)attendClick:(UIButton *)sender{
    self.hidesBottomBarWhenPushed = YES;
    ApplyEnterViewController *vc = [ApplyEnterViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error{
    
    [MBProgressHUD hideHUDForView:self.view animated:YES];
}


@end

