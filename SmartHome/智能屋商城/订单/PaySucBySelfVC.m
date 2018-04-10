//
//  PaySucBySelfVC.m
//  SmartMall
//
//  Created by Smart house on 2017/9/14.
//  Copyright © 2017年 verb. All rights reserved.
//

#import "PaySucBySelfVC.h"

#import "OrderDetailVC.h"

@interface PaySucBySelfVC (){
    UIView *customInfoView;
}

@end

@implementation PaySucBySelfVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = My_gray;
    //    self.navigationController.navigationBar.barTintColor = [UIColor whiteColor];
    self.navigationItem.title = @"支付成功";
    
    NSLog( @"orderInfo = %@",_orderInfo);
    
    UIButton *backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 35, 40, 40)];
    [backBtn setImage:[UIImage imageNamed:@"fanhui(b)"] forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backClick) forControlEvents:UIControlEventTouchUpInside];
    
    backBtn.contentEdgeInsets = UIEdgeInsetsMake(0, -16, 0, 0);
    self.navigationItem.hidesBackButton = YES;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
//    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
    
    
    [self createView];
}

-(void)createView{
    
    UIView *succView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, Sc_w, 93)];
    succView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"jianbiantiao-0"]];
    
    UIImageView *image1 = [[UIImageView alloc]initWithFrame:CGRectMake(10, 28 + 5, 49, 34)];
    image1.image = [UIImage imageNamed:@"ziti"];
    
    UILabel *label1 = [[UILabel alloc]initWithFrame:CGRectMake(70, 28, 250, 19)];
    label1.font = [UIFont systemFontOfSize:19];
    label1.textColor = [UIColor whiteColor];
    label1.text = @"订单支付成功";
    
    UILabel *label2 = [[UILabel alloc]initWithFrame:CGRectMake(70, 28 + 19 + 8, Sc_w - 100, 14)];
    label2.font = [UIFont systemFontOfSize:14];
    label2.textColor = [UIColor whiteColor];
    label2.text = @"您可以选择到您附近的自提点提货";
    
    
    customInfoView = [[UIView alloc]initWithFrame:CGRectMake(0, 93, Sc_w, 60)];
    customInfoView.backgroundColor = [UIColor whiteColor];
    
    UIImageView *locaImage = [[UIImageView alloc]initWithFrame:CGRectMake(10, 20, 20, 21)];
    locaImage.image = [UIImage imageNamed:@"tihuoren-0"];
    
    UILabel *hosterName = [[UILabel alloc]initWithFrame:CGRectMake(40, 22.5 - 3, 100, 21)];
    hosterName.font = [UIFont systemFontOfSize:15];
    hosterName.text = _nameAndTele[@"realname"];
    
    UILabel *teleLab = [[UILabel alloc]initWithFrame:CGRectMake(110, 22.5 - 3, 100, 21)];
    teleLab.font = [UIFont systemFontOfSize:15];
    teleLab.text = _nameAndTele[@"mobile"];
    
    
    
    [customInfoView addSubview:locaImage];
    [customInfoView addSubview:hosterName];
    [customInfoView addSubview:teleLab];
    
    
    UIView *view3 = [[UIView alloc]initWithFrame:CGRectMake(0, 93 + 70, Sc_w, 44)];
    view3.backgroundColor = [UIColor whiteColor];
    
    UILabel *label31 = [[UILabel alloc]initWithFrame:CGRectMake(10, 10, 100, 24)];
    label31.font = [UIFont systemFontOfSize:15];
    label31.text = @"实付金额";
    
    
    UILabel *label32 = [[UILabel alloc]initWithFrame:CGRectMake(Sc_w - 110, 10, 100, 24)];
    label32.font = [UIFont systemFontOfSize:15];
    label32.text = [NSString stringWithFormat:@"￥%.2f",_totalMoney];
    label32.textColor = Color_system;
    label32.textAlignment = NSTextAlignmentRight;
    
    [view3 addSubview:label31];
    [view3 addSubview:label32];
    
    CGFloat hh = 93 + 70 + 44 + 27;
    UIButton *detilBtn = [[UIButton alloc]initWithFrame:CGRectMake(39, hh, 130, 43)];
    
    detilBtn.backgroundColor = [UIColor whiteColor];
    [detilBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [detilBtn setTitle:@"订单详情" forState:UIControlStateNormal];
    detilBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    detilBtn.layer.cornerRadius = 5.0;
    detilBtn.layer.borderWidth = 1;
    detilBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [detilBtn addTarget:self action:@selector(detilBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    
    UIButton *backStartBtn = [[UIButton alloc]initWithFrame:CGRectMake(Sc_w - 39 - 130, hh, 130, 43)];
    
    backStartBtn.backgroundColor = [UIColor whiteColor];
    [backStartBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [backStartBtn setTitle:@"返回首页" forState:UIControlStateNormal];
    backStartBtn.titleLabel.font = [UIFont systemFontOfSize:15];
    backStartBtn.layer.cornerRadius = 5.0;
    backStartBtn.layer.borderWidth = 1;
    backStartBtn.layer.borderColor = [UIColor grayColor].CGColor;
    [backStartBtn addTarget:self action:@selector(backStartBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    //    您可以选择到您附近的自提点提货
    
    [succView addSubview:image1];
    [succView addSubview:label1];
    [succView addSubview:label2];
    [succView addSubview:customInfoView];
    [succView addSubview:view3];
    
    [self.view addSubview:succView];
    [self.view addSubview:detilBtn];
    [self.view addSubview:backStartBtn];
}

-(void)detilBtnClick{
    
    NSLog(@"跳往下一个页面");
    
    OrderDetailVC *vc = [[OrderDetailVC alloc]init];
    
    vc.orderInfo = _orderInfo;
    vc.totalMoney = _totalMoney;
    vc.statusInfo = @"待发货";
    vc.nameAndTele = _nameAndTele;
    vc.issendFree = 1;
    
    [self.navigationController pushViewController:vc animated:YES];
    
}

-(void)backStartBtnClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}


-(void)backClick{
    [self.navigationController popToRootViewControllerAnimated:YES];
}
@end
