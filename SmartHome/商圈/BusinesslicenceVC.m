//
//  BusinesslicenceVC.m
//  SmartMall
//
//  Created by Smart house on 2017/11/7.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "BusinesslicenceVC.h"

@interface BusinesslicenceVC (){
    CGRect Orframe;
}

@end

@implementation BusinesslicenceVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationItem.title = @"商户执照";
    
    self.view.backgroundColor = My_gray;
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    for (int i = 0; i<_images.count; i++) {
        UIButton *btn = [[UIButton alloc]initWithFrame:CGRectMake((Sc_w - 300)/2, 10 + 80 * i, 300, 300)];
        btn.tag = i;
        [btn addTarget:self action:@selector(btnClick:) forControlEvents:UIControlEventTouchUpInside];
        dispatch_async(dispatch_get_global_queue(0, 0), ^{
            UIImage *image = [UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:_images[i]]]];
            dispatch_async(dispatch_get_main_queue(), ^{
                [btn setImage:image forState:UIControlStateNormal];
                [self.view addSubview:btn];
            });
        });
    }
}

-(void)btnClick:(UIButton *)sender{
    sender.selected = !sender.selected;
    if (sender.selected) {
        Orframe = sender.frame;
        sender.frame = CGRectMake(0, (Sc_h - Sc_w - 64)/2 , Sc_w, Sc_w);
    }else
        sender.frame = Orframe;
}

-(void)backClick{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
